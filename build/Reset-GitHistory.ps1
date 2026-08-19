#Requires -Version 5.1
<#
.SYNOPSIS
    Collapses all history on a branch into a single commit and removes all tags,
    locally and on the remote.

.DESCRIPTION
    Rewrites the branch so it contains exactly one commit whose tree is byte-for-byte
    identical to the current tip. Deletes every local and remote tag. Force-pushes.

    This is DESTRUCTIVE and IRREVERSIBLE on the remote. A local backup bundle is
    written first unless -SkipBackup is specified.

.PARAMETER Branch
    Branch to rewrite. Default: main

.PARAMETER Message
    Commit message for the single resulting commit. Default: "Initial commit"

.PARAMETER Remote
    Remote name. Default: origin

.PARAMETER ExpectedRemote
    Substring that must appear in the remote URL. Guards against running this in
    the wrong clone. Default: Terraform.External.Test

.PARAMETER SkipBackup
    Skip writing the backup bundle.

.PARAMETER Force
    Skip the interactive confirmation prompt.

.EXAMPLE
    .\Reset-GitHistory.ps1

.EXAMPLE
    .\Reset-GitHistory.ps1 -Message "Initial public commit" -Force
#>
[CmdletBinding()]
param(
    [string] $Branch         = 'main',
    [string] $Message        = 'Initial commit',
    [string] $Remote         = 'origin',
    [string] $ExpectedRemote = 'Terraform.External.Test',
    [switch] $SkipBackup,
    [switch] $Force
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# ---------------------------------------------------------------- helpers ----

function Write-Step  { param([string]$Text) Write-Host "`n>> $Text" -ForegroundColor Cyan }
function Write-Info  { param([string]$Text) Write-Host "   $Text" -ForegroundColor Gray }
function Write-Ok    { param([string]$Text) Write-Host "   $Text" -ForegroundColor Green }
function Write-Warn2 { param([string]$Text) Write-Host "   $Text" -ForegroundColor Yellow }

function ConvertTo-PlainText {
    param([AllowNull()][object[]] $Value)
    if ($null -eq $Value) { return @() }
    return @(
        $Value | ForEach-Object {
            if ($_ -is [System.Management.Automation.ErrorRecord]) {
                [string]$_.Exception.Message
            }
            else {
                [string]$_
            }
        }
    )
}

function Invoke-Git {
    <#  Runs git, throws on non-zero exit, returns stdout lines.
        Sets script-scoped $script:LastGitExitCode for callers that use -IgnoreExitCode.  #>
    param(
        [Parameter(Mandatory)][string[]] $Arguments,
        [switch] $IgnoreExitCode
    )
    $raw = & git @Arguments 2>&1
    $script:LastGitExitCode = $LASTEXITCODE
    $out = ConvertTo-PlainText $raw
    if ($script:LastGitExitCode -ne 0 -and -not $IgnoreExitCode) {
        throw "git $($Arguments -join ' ') failed (exit $script:LastGitExitCode):`n$($out -join "`n")"
    }
    return $out
}

# ------------------------------------------------------------ preflight ------

Write-Step 'Preflight checks'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'git was not found on PATH.'
}

# Always operate on the repo that contains this script, not the caller's cwd.
# Prevents accidentally rewriting a sibling clone (e.g. TerraformAST).
if ($PSScriptRoot) {
    Set-Location -LiteralPath $PSScriptRoot
}

$null = Invoke-Git @('rev-parse', '--is-inside-work-tree')
$repoRoot = ((Invoke-Git @('rev-parse', '--show-toplevel')) | Select-Object -First 1).Trim()
Set-Location -LiteralPath $repoRoot
Write-Info "Repository: $repoRoot"

# Confirm we are in the intended repository.
$remoteUrl = ((Invoke-Git @('remote', 'get-url', $Remote)) | Select-Object -First 1).Trim()
Write-Info "Remote '$Remote': $remoteUrl"
if ($remoteUrl -notmatch [regex]::Escape($ExpectedRemote)) {
    throw "Remote URL does not contain '$ExpectedRemote'. Refusing to run. Override with -ExpectedRemote."
}

# Working tree must be clean, or the rewrite will not mean what you think.
# Ignore this script itself so an untracked/modified copy does not block the run.
$scriptLeaf = if ($PSCommandPath) { Split-Path -Leaf $PSCommandPath } else { 'Reset-GitHistory.ps1' }
$status = @(
    Invoke-Git @('status', '--porcelain') |
        Where-Object {
            $line = "$_"
            if (-not $line) { return $false }
            $path = if ($line.Length -ge 4) { $line.Substring(3).Trim('"') } else { $line }
            # git status can show "old -> new" for renames; take the final path.
            if ($path -match ' -> ') { $path = ($path -split ' -> ', 2)[1] }
            return ($path -ne $scriptLeaf -and $path -ne "./$scriptLeaf")
        }
)
if ($status.Count -gt 0) {
    Write-Warn2 'Uncommitted changes present:'
    $status | ForEach-Object { Write-Warn2 "     $_" }
    throw 'Commit, stash, or discard your changes first, then re-run.'
}

# Branch must exist and be the one checked out.
$currentBranch = ((Invoke-Git @('rev-parse', '--abbrev-ref', 'HEAD')) | Select-Object -First 1).Trim()
if ($currentBranch -ne $Branch) {
    throw "Currently on '$currentBranch' but -Branch is '$Branch'. Run: git checkout $Branch"
}

Write-Step 'Fetching current remote state'
$null = Invoke-Git @('fetch', $Remote, '--tags', '--prune', '--prune-tags')

# ------------------------------------------------------------ inventory ------

$commitCount = ((Invoke-Git @('rev-list', '--count', 'HEAD')) | Select-Object -First 1).Trim()
$headSha     = ((Invoke-Git @('rev-parse', '--short', 'HEAD')) | Select-Object -First 1).Trim()

$localTags = @(Invoke-Git @('tag', '--list') | ForEach-Object { $_.Trim() } | Where-Object { $_ })

$remoteTags = @(
    Invoke-Git @('ls-remote', '--tags', $Remote) |
        ForEach-Object {
            $line = "$_"
            $ref = if ($line -match "`t") { ($line -split "`t", 2)[1] } else { ($line -split '\s+', 2)[-1] }
            $ref = $ref.Trim() -replace '^refs/tags/', '' -replace '\^\{\}$', ''
            $ref
        } |
        Where-Object { $_ } |
        Sort-Object -Unique
)

$otherRemoteBranches = @(
    Invoke-Git @('ls-remote', '--heads', $Remote) |
        ForEach-Object {
            $line = "$_"
            $ref = if ($line -match "`t") { ($line -split "`t", 2)[1] } else { ($line -split '\s+', 2)[-1] }
            $ref = $ref.Trim() -replace '^refs/heads/', ''
            $ref
        } |
        Where-Object { $_ -and $_ -ne $Branch }
)

Write-Step 'What this will do'
Write-Info "Branch to rewrite ......... $Branch (currently $commitCount commit(s), tip $headSha)"
Write-Info "Resulting history ......... 1 commit: `"$Message`""
Write-Info "File contents ............. unchanged (tree is copied exactly)"
Write-Info "Local tags to delete ...... $(if ($localTags.Count)  { $localTags  -join ', ' } else { '(none)' })"
Write-Info "Remote tags to delete ..... $(if ($remoteTags.Count) { $remoteTags -join ', ' } else { '(none)' })"

if ($otherRemoteBranches.Count -gt 0) {
    Write-Warn2 "Other remote branches NOT touched by this script: $($otherRemoteBranches -join ', ')"
    Write-Warn2 "They still contain the old history. Delete them separately if you want them gone:"
    $otherRemoteBranches | ForEach-Object { Write-Warn2 "     git push $Remote --delete $_" }
}

# ------------------------------------------------------------- confirm -------

if (-not $Force) {
    Write-Host ''
    Write-Host 'This permanently discards all history and tags on the remote.' -ForegroundColor Red
    $answer = Read-Host "Type the branch name ($Branch) to proceed, anything else to abort"
    if ($answer -ne $Branch) {
        Write-Host 'Aborted. Nothing changed.' -ForegroundColor Yellow
        return
    }
}

# -------------------------------------------------------------- backup -------

if (-not $SkipBackup) {
    Write-Step 'Writing backup bundle'
    $stamp      = Get-Date -Format 'yyyyMMdd-HHmmss'
    $bundlePath = Join-Path (Split-Path $repoRoot -Parent) "$(Split-Path $repoRoot -Leaf)-backup-$stamp.bundle"
    $null = Invoke-Git @('bundle', 'create', $bundlePath, '--all')
    $sizeKb = [math]::Round((Get-Item $bundlePath).Length / 1KB, 1)
    Write-Ok "Backup written: $bundlePath ($sizeKb KB)"
    Write-Info "Restore with: git clone `"$bundlePath`" restored-repo"
} else {
    Write-Warn2 'Backup skipped (-SkipBackup).'
}

# --------------------------------------------------------- squash local ------

Write-Step 'Building single-commit history'

# Copy the existing tree verbatim into a brand-new parentless commit.
# This guarantees the working tree is unchanged by the rewrite.
# Use 'branch^{tree}' via a single argument so PowerShell does not eat the braces.
$tree = ((Invoke-Git @('rev-parse', "${Branch}^{tree}")) | Select-Object -First 1).Trim()
Write-Info "Tree object: $tree"

$newCommit = ((Invoke-Git @('commit-tree', $tree, '-m', $Message)) | Select-Object -First 1).Trim()
Write-Info "New root commit: $newCommit"

$null = Invoke-Git @('reset', '--hard', $newCommit)
Write-Ok "$Branch now has 1 commit."

# Sanity check: the tree must be identical to what we started from.
$verifyTree = ((Invoke-Git @('rev-parse', 'HEAD^{tree}')) | Select-Object -First 1).Trim()
if ($verifyTree -ne $tree) {
    throw "Tree mismatch after rewrite ($verifyTree vs $tree). Stopping before push. Restore from the bundle."
}
Write-Ok 'Tree verified identical to original.'

# ---------------------------------------------------------- delete tags ------

if ($localTags.Count -gt 0) {
    Write-Step 'Deleting local tags'
    $null = Invoke-Git (@('tag', '-d') + $localTags)
    Write-Ok "Deleted $($localTags.Count) local tag(s)."
}

if ($remoteTags.Count -gt 0) {
    Write-Step 'Deleting remote tags'
    # Batched into one push; refspec form works for both lightweight and annotated.
    $refspecs = @($remoteTags | ForEach-Object { ":refs/tags/$_" })
    $null = Invoke-Git (@('push', $Remote) + $refspecs)
    Write-Ok "Deleted $($remoteTags.Count) remote tag(s)."
}

# ----------------------------------------------------------------- push ------

Write-Step 'Force-pushing branch'
$push = Invoke-Git @('push', '--force-with-lease', $Remote, "${Branch}:${Branch}") -IgnoreExitCode
$push | ForEach-Object { Write-Info $_ }

if ($script:LastGitExitCode -ne 0) {
    Write-Warn2 'Push was rejected.'
    Write-Warn2 'Most common cause: branch protection or a required rule on GitHub.'
    Write-Warn2 "Settings -> Branches -> allow force pushes on '$Branch', push, then re-enable."
    Write-Warn2 'Your local branch is already rewritten; re-run the push once the rule is lifted:'
    Write-Warn2 "     git push --force-with-lease $Remote $Branch"
    throw 'Force push failed.'
}
Write-Ok 'Push complete.'

# ---------------------------------------------------------------- gc ---------

Write-Step 'Pruning local objects'
$null = Invoke-Git @('reflog', 'expire', '--expire=now', '--expire-unreachable=now', '--all')
$null = Invoke-Git @('gc', '--prune=now', '--quiet') -IgnoreExitCode
Write-Ok 'Local object store pruned.'

# -------------------------------------------------------------- summary ------

Write-Step 'Done'
Invoke-Git @('log', '--oneline', '--decorate', '--all') | ForEach-Object { Write-Host "   $_" }
Write-Host ''
Write-Warn2 'Note: GitHub may still serve old commits by SHA for a period after a force push.'
Write-Warn2 'If any commit ever contained a credential, rotate it. Rewriting history does not revoke it.'
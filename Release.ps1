
[CmdletBinding()]
Param(

    [Parameter()]
    [ValidateSet("Major","Minor","Build")]
    [String]
    $Build = "Build",

    [Parameter()]
    [String]
    $CommitMessage = ""

)

$_commitMessage = if ($CommitMessage.Length -eq 0) {
    Read-Host -Prompt "Enter the commit message"
} else {$CommitMessage}

if (-not($_commitMessage)) {
    Write-Error "No commit message"
    return
}

$versionPath  = (Resolve-Path -Path "build\latestVersion.json").Path
$content      = Get-Content -Path $versionPath -Raw -Force -ErrorAction Stop

$version = $content | ConvertFrom-Json
$v       = [Version]$version.Version

Write-Host "--- Current Version --- `r`n$($version | Format-Table | Out-String)" -ForegroundColor Magenta

$updatedVersion = switch ($Build) {
    "Major" {"$($v.Major + 1).0.0"}
    "Minor" {"$($v.Major).$($v.Minor + 1).0"}
    "Build" {"$($v.Major).$($v.Minor).$($v.Build + 1)"}
}

$nextVersion = [PSCustomObject]@{
    Version       = $updatedVersion
    CommitMessage = $_commitMessage
}

Write-Host "`n--- Release Version --- `r`n$($nextVersion | Format-Table | Out-String)" -ForegroundColor Magenta

$nextVersion | ConvertTo-Json | Out-File $versionPath -Force

git add -A
git commit -m $nextVersion.CommitMessage
git tag -a $nextVersion.Version -m $nextVersion.CommitMessage
git push origin main
git push origin $nextVersion.Version





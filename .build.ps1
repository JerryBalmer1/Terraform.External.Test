[CmdletBinding(DefaultParameterSetName="__AllParameterSets")]
Param(

    # Must use Invoke-Build -Release "Build", etc..
    [Parameter(ParameterSetName="Release")]
    [ValidateSet("Major","Minor","Build")]
    [String]
    $Release

)

################################################################################
# InvokeBuild - ArgumentCompleters
################################################################################

Register-ArgumentCompleter -CommandName Invoke-Build.ps1 -ParameterName Task -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $boundParameters)

    (Invoke-Build -Task ?? -File ($boundParameters['File'])).get_Keys() -like "$wordToComplete*" | .{process{
        New-Object System.Management.Automation.CompletionResult $_, $_, 'ParameterValue', $_
    }}
}

Register-ArgumentCompleter -CommandName Invoke-Build.ps1 -ParameterName File -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $boundParameters)

    Get-ChildItem -Directory -Name "$wordToComplete*" | .{process{
        New-Object System.Management.Automation.CompletionResult $_, $_, 'ProviderContainer', $_
    }}

    if (!($boundParameters['Task'] -eq '**')) {
        Get-ChildItem -File -Name "$wordToComplete*.ps1" | .{process{
            New-Object System.Management.Automation.CompletionResult $_, $_, 'Command', $_
        }}
    }
}

################################################################################
# InvokeBuild - Install InvokeBuild
################################################################################

if (-not(Get-Module -ListAvailable -Name InvokeBuild)) {
    Install-Module -Name InvokeBuild -Scope CurrentUser -Verbose -Force
}

################################################################################
# InvokeBuild - Tasks
################################################################################

function Get-FixtureDirectories {
    Get-ChildItem -Path (Join-Path $BuildRoot 'fixtures') -Directory -ErrorAction Stop |
        Where-Object { Test-Path (Join-Path $_.FullName '*.tf') } |
        Sort-Object Name
}

function Clear-TerraformArtifacts {
    param([string]$Directory)
    foreach ($name in @('.terraform', 'generated', '.terraform.lock.hcl', 'terraform.tfstate', 'terraform.tfstate.backup')) {
        Remove-Item (Join-Path $Directory $name) -Force -Recurse -ErrorAction SilentlyContinue
    }
}

task clean {
    foreach ($fixture in (Get-FixtureDirectories)) {
        Clear-TerraformArtifacts -Directory $fixture.FullName
    }
    Clear-TerraformArtifacts -Directory $BuildRoot
}

task Init {
    foreach ($fixture in (Get-FixtureDirectories)) {
        Push-Location $fixture.FullName
        try {
            exec { terraform init }
        }
        finally {
            Pop-Location
        }
    }
}

task Apply {
    foreach ($fixture in (Get-FixtureDirectories)) {
        Push-Location $fixture.FullName
        try {
            exec { terraform apply --auto-approve }
        }
        finally {
            Pop-Location
        }
    }
}

task Destroy {
    foreach ($fixture in (Get-FixtureDirectories)) {
        Push-Location $fixture.FullName
        try {
            exec { terraform destroy --auto-approve }
        }
        finally {
            Pop-Location
        }
    }
}

task Build Init, Apply, Destroy, {
}

task . Build

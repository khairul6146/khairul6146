<#
.SYNOPSIS
    Deploy-ProfileRepo.ps1 - Automates staging, committing, and pushing the khairul6146 GitHub profile.

.DESCRIPTION
    Initializes git in C:\Users\khair\MyProjects\khairul6146, configures origin to
    https://github.com/khairul6146/khairul6146.git, and pushes the new profile README and banner.
#>
[CmdletBinding()]
param (
    [string]$RemoteUrl = "https://github.com/khairul6146/khairul6146.git"
)

$repoPath = $PSScriptRoot
Set-Location -Path $repoPath

Write-Host "`n🚀 Deploying GitHub Profile README for khairul6146..." -ForegroundColor Cyan

# 1. Initialize git if needed
if (-not (Test-Path "$repoPath\.git")) {
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    git init -b main
}

# 2. Configure remote if needed
$currentRemote = git remote get-url origin 2>$null
if (-not $currentRemote) {
    Write-Host "Adding remote origin: $RemoteUrl" -ForegroundColor Yellow
    git remote add origin $RemoteUrl
} else {
    Write-Host "Existing remote origin: $currentRemote" -ForegroundColor Green
}

# 3. Stage and commit files
Write-Host "Staging and committing profile assets..." -ForegroundColor Yellow
git add README.md assets/banner.svg Deploy-ProfileRepo.ps1
git commit -m "feat(profile): launch professional github profile readme and banner" 2>&1

# 4. Push to remote
Write-Host "`nAttempting to push to $RemoteUrl..." -ForegroundColor Cyan
$pushResult = git push -u origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Successfully deployed GitHub profile! Check https://github.com/khairul6146" -ForegroundColor Green
} else {
    Write-Host "`n⚠️ Push completed with status: $LASTEXITCODE" -ForegroundColor Yellow
    Write-Host "If the remote repository does not exist yet on GitHub:" -ForegroundColor White
    Write-Host "1. Go to: https://github.com/new" -ForegroundColor Cyan
    Write-Host "2. Repository name: khairul6146" -ForegroundColor Cyan
    Write-Host "3. Set to: Public" -ForegroundColor Cyan
    Write-Host "4. Do NOT check 'Add a README file' (it's already prepared locally)" -ForegroundColor Cyan
    Write-Host "5. Click 'Create repository', then re-run this script: .\Deploy-ProfileRepo.ps1`n" -ForegroundColor Cyan
}

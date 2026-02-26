# GitHub Setup Automation Script
# Automates git initialization and GitHub upload

param(
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$false)]
    [string]$RepoName = "linux-chardev-driver",
    
    [Parameter(Mandatory=$false)]
    [string]$Email = "",
    
    [switch]$SkipCommit
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Blue
Write-Host "GitHub Setup Automation" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Check if git is installed
try {
    $null = Get-Command git -ErrorAction Stop
    Write-Host "[✓] Git found" -ForegroundColor Green
} catch {
    Write-Host "[✗] ERROR: Git not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Install Git:" -ForegroundColor Yellow
    Write-Host "  winget install Git.Git" -ForegroundColor Yellow
    Write-Host "  OR download from: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# Check if already a git repository
if (Test-Path ".git") {
    Write-Host "[!] Git repository already initialized" -ForegroundColor Yellow
    $reinit = Read-Host "Reinitialize? (y/n)"
    if ($reinit -ne "y") {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit 0
    }
    Remove-Item -Recurse -Force .git
}

Write-Host ""
Write-Host "[i] Repository Configuration:" -ForegroundColor Cyan
Write-Host "    Username: $Username" -ForegroundColor White
Write-Host "    Repo Name: $RepoName" -ForegroundColor White
Write-Host "    Repository URL: https://github.com/$Username/$RepoName" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Continue? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Step 1: Configure Git" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue

# Set git config if email provided
if ($Email) {
    git config --global user.email $Email
    Write-Host "[✓] Git email configured: $Email" -ForegroundColor Green
}

# Check git user name
$gitUser = git config user.name
if (-not $gitUser) {
    Write-Host "[!] Git user name not configured" -ForegroundColor Yellow
    $name = Read-Host "Enter your name for git commits"
    git config --global user.name $name
    Write-Host "[✓] Git name configured: $name" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Step 2: Initialize Repository" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue

# Initialize git
Write-Host "[i] Initializing git repository..." -ForegroundColor Cyan
git init
Write-Host "[✓] Repository initialized" -ForegroundColor Green

# Rename to main branch
Write-Host "[i] Setting default branch to 'main'..." -ForegroundColor Cyan
git branch -M main
Write-Host "[✓] Branch set to main" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Step 3: Stage Files" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue

# Add all files
Write-Host "[i] Staging all files..." -ForegroundColor Cyan
git add .

# Show status
Write-Host ""
Write-Host "Files to be committed:" -ForegroundColor Cyan
git status --short
Write-Host ""

$fileCount = (git diff --cached --numstat | Measure-Object).Count
Write-Host "[✓] $fileCount files staged" -ForegroundColor Green

if (-not $SkipCommit) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host "Step 4: Create Initial Commit" -ForegroundColor Blue
    Write-Host "========================================" -ForegroundColor Blue
    
    Write-Host "[i] Creating initial commit..." -ForegroundColor Cyan
    git commit -m "Initial commit: Linux character device driver with full documentation

- Character device driver with read/write/ioctl interface
- Mutex-based thread synchronization
- Comprehensive test suite (6 test scenarios)
- Complete documentation and interview materials
- GitHub workflow and templates
- LaTeX documentation for interviews"
    
    Write-Host "[✓] Initial commit created" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Step 5: Add Remote" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue

$remoteUrl = "https://github.com/$Username/$RepoName.git"
Write-Host "[i] Adding remote: $remoteUrl" -ForegroundColor Cyan

# Remove existing remote if exists
git remote remove origin 2>$null

git remote add origin $remoteUrl
Write-Host "[✓] Remote added" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Step 6: Ready to Push!" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

Write-Host "Repository is ready to push to GitHub!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Create repository on GitHub:" -ForegroundColor White
Write-Host "   https://github.com/new" -ForegroundColor Cyan
Write-Host "   - Name: $RepoName" -ForegroundColor White
Write-Host "   - Description: Linux kernel character device driver" -ForegroundColor White
Write-Host "   - DON'T initialize with README" -ForegroundColor White
Write-Host ""
Write-Host "2. Push to GitHub:" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. If authentication required:" -ForegroundColor White
Write-Host "   - Use Personal Access Token as password" -ForegroundColor White
Write-Host "   - Generate at: https://github.com/settings/tokens" -ForegroundColor Cyan
Write-Host ""

$pushNow = Read-Host "Do you want to push now? (y/n)"
if ($pushNow -eq "y") {
    Write-Host ""
    Write-Host "[i] Pushing to GitHub..." -ForegroundColor Cyan
    Write-Host ""
    
    try {
        git push -u origin main
        Write-Host ""
        Write-Host "[✓] Successfully pushed to GitHub!" -ForegroundColor Green
        Write-Host ""
        Write-Host "View your repository at:" -ForegroundColor Green
        Write-Host "https://github.com/$Username/$RepoName" -ForegroundColor Cyan
    } catch {
        Write-Host ""
        Write-Host "[✗] Push failed!" -ForegroundColor Red
        Write-Host ""
        Write-Host "This usually means:" -ForegroundColor Yellow
        Write-Host "- Repository doesn't exist on GitHub yet" -ForegroundColor White
        Write-Host "- Authentication failed" -ForegroundColor White
        Write-Host "- No internet connection" -ForegroundColor White
        Write-Host ""
        Write-Host "Create the repository on GitHub first, then run:" -ForegroundColor Yellow
        Write-Host "git push -u origin main" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Create a summary file
$summary = @"
# Git Repository Setup Summary

**Date**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Repository**: https://github.com/$Username/$RepoName

## Configuration
- Username: $Username
- Repository Name: $RepoName
- Branch: main
- Files Staged: $fileCount

## Next Steps
1. Ensure repository exists on GitHub
2. Push: ``git push -u origin main``
3. Add topics and description on GitHub
4. Create initial release (v1.0.0)
5. Update resume/LinkedIn with project link

## Verification
- [ ] Repository visible on GitHub
- [ ] README displays correctly
- [ ] All files uploaded
- [ ] GitHub Actions enabled
- [ ] Personal information updated

## URLs
- Repository: https://github.com/$Username/$RepoName
- Issues: https://github.com/$Username/$RepoName/issues
- Actions: https://github.com/$Username/$RepoName/actions
- Settings: https://github.com/$Username/$RepoName/settings

---
Generated by github_setup.ps1
"@

$summary | Out-File -FilePath "GIT_SETUP_SUMMARY.md" -Encoding UTF8

Write-Host "Summary saved to: GIT_SETUP_SUMMARY.md" -ForegroundColor Cyan
Write-Host ""

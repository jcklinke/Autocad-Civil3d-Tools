# AutoCAD Civil 3D Tools - Swarm Initialization Script
# This script sets up the development environment according to the swarm configuration

param(
    [switch]$Verbose,
    [switch]$SkipBuild,
    [switch]$SkipAnalysis
)

Write-Host "Initializing AutoCAD Civil 3D Tools Development Swarm..." -ForegroundColor Green

# Configuration
$SolutionPath = "Acad-C3D-Tools\Acad-C3D-Tools.sln"
$ConfigFile = "claude_swarm_config.json"

# Verify prerequisites
Write-Host "`nVerifying prerequisites..." -ForegroundColor Yellow

if (-not (Test-Path $SolutionPath)) {
    Write-Error "Solution file not found: $SolutionPath"
    exit 1
}

if (-not (Test-Path $ConfigFile)) {
    Write-Warning "Swarm config file not found: $ConfigFile"
}

# Check for required tools
$RequiredTools = @("dotnet", "git", "claude")
foreach ($tool in $RequiredTools) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Warning "$tool not found in PATH"
    } else {
        Write-Host "✓ $tool available" -ForegroundColor Green
    }
}

# Analyze solution structure
if (-not $SkipAnalysis) {
    Write-Host "`nAnalyzing solution structure..." -ForegroundColor Yellow
    
    # Parse solution file to identify projects
    $SolutionContent = Get-Content $SolutionPath
    $Projects = $SolutionContent | Where-Object { $_ -match 'Project\(".*"\) = "(.+)", "(.+\.csproj)"' } | ForEach-Object {
        if ($_ -match 'Project\(".*"\) = "(.+)", "(.+\.csproj)"') {
            @{
                Name = $Matches[1]
                Path = $Matches[2]
                Type = if ($Matches[2] -like "*SHARED*") { "Shared" } else { "Standard" }
            }
        }
    }
    
    $SharedProjects = $Projects | Where-Object { $_.Type -eq "Shared" }
    $StandardProjects = $Projects | Where-Object { $_.Type -eq "Standard" }
    
    Write-Host "Found $($Projects.Count) total projects:" -ForegroundColor Cyan
    Write-Host "  - $($SharedProjects.Count) shared projects" -ForegroundColor Cyan
    Write-Host "  - $($StandardProjects.Count) standard projects" -ForegroundColor Cyan
    
    if ($Verbose) {
        Write-Host "`nShared Projects:" -ForegroundColor Yellow
        $SharedProjects | ForEach-Object { Write-Host "  - $($_.Name)" }
        
        Write-Host "`nStandard Projects:" -ForegroundColor Yellow
        $StandardProjects | ForEach-Object { Write-Host "  - $($_.Name)" }
    }
}

# Setup build environment
Write-Host "`nSetting up build environment..." -ForegroundColor Yellow

# Create build output directories
$BuildDirs = @("build", "artifacts", "logs")
foreach ($dir in $BuildDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
        Write-Host "✓ Created $dir directory" -ForegroundColor Green
    }
}

# Validate project references
Write-Host "`nValidating project references..." -ForegroundColor Yellow
try {
    $RestoreResult = & dotnet restore $SolutionPath 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Package restore successful" -ForegroundColor Green
    } else {
        Write-Warning "Package restore had warnings/errors"
        if ($Verbose) {
            Write-Host $RestoreResult -ForegroundColor Gray
        }
    }
} catch {
    Write-Error "Failed to restore packages: $_"
}

# Test build (if not skipped)
if (-not $SkipBuild) {
    Write-Host "`nTesting solution build..." -ForegroundColor Yellow
    try {
        $BuildResult = & dotnet build $SolutionPath --configuration Debug --no-restore 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Solution builds successfully" -ForegroundColor Green
        } else {
            Write-Warning "Build had warnings/errors"
            if ($Verbose) {
                Write-Host $BuildResult -ForegroundColor Gray
            }
        }
    } catch {
        Write-Error "Failed to build solution: $_"
    }
}

# Setup Git hooks (if in git repository)
if (Test-Path ".git") {
    Write-Host "`nSetting up Git integration..." -ForegroundColor Yellow
    
    # Create pre-commit hook for build validation
    $PreCommitHook = @"
#!/bin/sh
# Pre-commit hook for AutoCAD Civil 3D Tools
echo "Running pre-commit build validation..."
dotnet build Acad-C3D-Tools/Acad-C3D-Tools.sln --configuration Debug --no-restore --verbosity quiet
if [ `$? -ne 0 ]; then
    echo "Build failed. Commit aborted."
    exit 1
fi
echo "Build successful."
"@
    
    $HookPath = ".git/hooks/pre-commit"
    if (-not (Test-Path $HookPath)) {
        $PreCommitHook | Out-File -FilePath $HookPath -Encoding ASCII
        Write-Host "✓ Created pre-commit hook" -ForegroundColor Green
    }
}

# Initialize monitoring
Write-Host "`nInitializing monitoring systems..." -ForegroundColor Yellow

# Create monitoring log
$MonitoringLog = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    SwarmInitialized = $true
    SolutionPath = $SolutionPath
    ProjectCount = $Projects.Count
    SharedProjectCount = $SharedProjects.Count
    BuildStatus = if (-not $SkipBuild) { if ($LASTEXITCODE -eq 0) { "Success" } else { "Warning" } } else { "Skipped" }
    Environment = @{
        OS = $env:OS
        PowerShellVersion = $PSVersionTable.PSVersion.ToString()
        DotNetVersion = try { (& dotnet --version 2>$null) } catch { "Not available" }
        GitVersion = try { (& git --version 2>$null) } catch { "Not available" }
    }
}

$MonitoringLog | ConvertTo-Json -Depth 3 | Out-File -FilePath "logs/swarm_initialization.json"
Write-Host "✓ Monitoring log created" -ForegroundColor Green

# Display swarm configuration summary
Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "SWARM INITIALIZATION COMPLETE" -ForegroundColor Cyan
Write-Host "="*60 -ForegroundColor Cyan
Write-Host "Configuration: Hierarchical topology with 8 max agents" -ForegroundColor White
Write-Host "Primary Focus: AutoCAD Civil 3D development tools" -ForegroundColor White
Write-Host "Projects: $($Projects.Count) total ($($SharedProjects.Count) shared)" -ForegroundColor White
Write-Host "Build Status: " -NoNewline -ForegroundColor White
if (-not $SkipBuild) {
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Success" -ForegroundColor Green
    } else {
        Write-Host "⚠ Warnings" -ForegroundColor Yellow
    }
} else {
    Write-Host "- Skipped" -ForegroundColor Gray
}
Write-Host "`nAgent Specializations:" -ForegroundColor White
Write-Host "  • Core AutoCAD Developer (25% allocation)" -ForegroundColor Cyan
Write-Host "  • Civil 3D Specialist (25% allocation)" -ForegroundColor Cyan  
Write-Host "  • Data Integration Developer (15% allocation)" -ForegroundColor Cyan
Write-Host "  • UI/UX Developer (10% allocation)" -ForegroundColor Cyan
Write-Host "  • Automation Specialist (10% allocation)" -ForegroundColor Cyan
Write-Host "  • Graphics & Export Specialist (10% allocation)" -ForegroundColor Cyan
Write-Host "  • Testing & QA Specialist (5% allocation)" -ForegroundColor Cyan
Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "  1. Review swarm_workflow.md for operational details" -ForegroundColor Gray
Write-Host "  2. Use 'claude' CLI for interactive development sessions" -ForegroundColor Gray
Write-Host "  3. Follow hierarchical workflow patterns for complex tasks" -ForegroundColor Gray
Write-Host "="*60 -ForegroundColor Cyan

Write-Host "`nSwarm initialization completed successfully!" -ForegroundColor Green
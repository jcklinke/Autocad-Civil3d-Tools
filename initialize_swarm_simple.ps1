# AutoCAD Civil 3D Tools - Simplified Swarm Initialization Script

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

Write-Host "Solution file found: $SolutionPath" -ForegroundColor Green

if (Test-Path $ConfigFile) {
    Write-Host "Swarm config file found: $ConfigFile" -ForegroundColor Green
} else {
    Write-Warning "Swarm config file not found: $ConfigFile"
}

# Check for required tools
Write-Host "`nChecking required tools..." -ForegroundColor Yellow

$tools = @("dotnet", "git", "claude")
foreach ($tool in $tools) {
    try {
        $null = Get-Command $tool -ErrorAction Stop
        Write-Host "Found $tool" -ForegroundColor Green
    } catch {
        Write-Warning "$tool not found in PATH"
    }
}

# Create build directories
Write-Host "`nSetting up build environment..." -ForegroundColor Yellow

$buildDirs = @("build", "artifacts", "logs")
foreach ($dir in $buildDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
        Write-Host "Created $dir directory" -ForegroundColor Green
    } else {
        Write-Host "$dir directory already exists" -ForegroundColor Gray
    }
}

# Test dotnet restore
Write-Host "`nTesting package restore..." -ForegroundColor Yellow
try {
    $restoreOutput = & dotnet restore $SolutionPath 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Package restore successful" -ForegroundColor Green
    } else {
        Write-Warning "Package restore completed with warnings"
    }
} catch {
    Write-Error "Failed to restore packages: $_"
}

# Create monitoring log
Write-Host "`nInitializing monitoring..." -ForegroundColor Yellow

$logData = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    SwarmInitialized = $true
    SolutionPath = $SolutionPath
    Environment = @{
        OS = $env:OS
        PowerShellVersion = $PSVersionTable.PSVersion.ToString()
    }
}

try {
    $logData | ConvertTo-Json -Depth 3 | Out-File -FilePath "logs/swarm_initialization.json"
    Write-Host "Monitoring log created" -ForegroundColor Green
} catch {
    Write-Warning "Could not create monitoring log"
}

# Display summary
Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "SWARM INITIALIZATION COMPLETE" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Configuration: Hierarchical topology with 8 max agents" -ForegroundColor White
Write-Host "Primary Focus: AutoCAD Civil 3D development tools" -ForegroundColor White
Write-Host "`nAgent Specializations:" -ForegroundColor White
Write-Host "  - Core AutoCAD Developer (25% allocation)" -ForegroundColor Cyan
Write-Host "  - Civil 3D Specialist (25% allocation)" -ForegroundColor Cyan  
Write-Host "  - Data Integration Developer (15% allocation)" -ForegroundColor Cyan
Write-Host "  - UI/UX Developer (10% allocation)" -ForegroundColor Cyan
Write-Host "  - Automation Specialist (10% allocation)" -ForegroundColor Cyan
Write-Host "  - Graphics & Export Specialist (10% allocation)" -ForegroundColor Cyan
Write-Host "  - Testing & QA Specialist (5% allocation)" -ForegroundColor Cyan
Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "  1. Review swarm_workflow.md for operational details" -ForegroundColor Gray
Write-Host "  2. Use 'claude' CLI for interactive development sessions" -ForegroundColor Gray
Write-Host "  3. Follow hierarchical workflow patterns for complex tasks" -ForegroundColor Gray
Write-Host "============================================================" -ForegroundColor Cyan

Write-Host "`nSwarm initialization completed successfully!" -ForegroundColor Green
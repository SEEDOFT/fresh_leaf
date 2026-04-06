#!/usr/bin/env pwsh

<#
.SYNOPSIS
Build script for Fresh Leaf App with secure environment configuration.

.DESCRIPTION
This script reads environment variables from .env files and builds the Flutter app
with proper obfuscation and security measures.

.PARAMETER Env
Environment type: 'local' or 'prod' (default: 'prod')

.PARAMETER BuildType
Build type: 'apk', 'appbundle' (default: 'appbundle')

.EXAMPLE
.\lib\scripts\build.ps1 -Env prod -BuildType appbundle
.\lib\scripts\build.ps1 -Env local -BuildType apk

.NOTES
Ensure .env.prod or .env.local file exists with the required variables before running this script.
#>

param(
    [ValidateSet('local', 'prod')]
    [string]$Env = 'prod',
    
    [ValidateSet('apk', 'appbundle')]
    [string]$BuildType = 'appbundle'
)

# Function to read .env file
function Read-EnvFile {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "ERROR: .env file not found at $FilePath" -ForegroundColor Red
        exit 1
    }
    
    $env_vars = @{}
    Get-Content $FilePath | Where-Object { $_ -match '^[^#]+=.+$' } | ForEach-Object {
        $key, $value = $_ -split '=', 2
        $env_vars[$key.Trim()] = $value.Trim()
    }
    
    return $env_vars
}

# Resolve .env file path
$env_file = ".\.env.$Env"
Write-Host "Loading configuration from: $env_file" -ForegroundColor Cyan

# Read environment variables
$env_vars = Read-EnvFile -FilePath $env_file

# Validate required variables
$required_vars = @('API_URL')
$missing_vars = @()

foreach ($var in $required_vars) {
    if (-not $env_vars.ContainsKey($var) -or [string]::IsNullOrEmpty($env_vars[$var])) {
        $missing_vars += $var
    }
}

if ($missing_vars.Count -gt 0) {
    Write-Host "ERROR: Missing required environment variables: $($missing_vars -join ', ')" -ForegroundColor Red
    exit 1
}

Write-Host "✓ All required environment variables found" -ForegroundColor Green

# Build command
$build_cmd = 'flutter build '

if ($BuildType -eq 'apk') {
    $build_cmd += 'apk --release'
}
else {
    $build_cmd += 'appbundle --release'
}

# Add dart-define parameters from .env file
foreach ($key in $env_vars.Keys) {
    $value = $env_vars[$key]
    # Escape special characters in values
    $value = $value -replace '"', '\"'
    $build_cmd += " --dart-define=$($key)=$($value)"
}

Write-Host "`nBuilding for: $Env environment" -ForegroundColor Cyan
Write-Host "Build type: $BuildType`n" -ForegroundColor Cyan

# Execute build command
Write-Host "Executing: $build_cmd" -ForegroundColor Yellow
Invoke-Expression $build_cmd

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ Build completed successfully!" -ForegroundColor Green
    if ($BuildType -eq 'apk') {
        Write-Host "Output: build\app\outputs\apk\release\app-release.apk" -ForegroundColor Green
    }
    else {
        Write-Host "Output: build\app\outputs\bundle\release\app-release.aab" -ForegroundColor Green
    }
}
else {
    Write-Host "`n✗ Build failed!" -ForegroundColor Red
    exit 1
}

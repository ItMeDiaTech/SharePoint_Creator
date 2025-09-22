Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ".NET Desktop Runtime 8.0.2 Local Installer" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Create local directory for .NET
Write-Host "Step 1: Creating installation directory..." -ForegroundColor Yellow
$dotnetPath = "$env:USERPROFILE\.dotnet"
if (Test-Path $dotnetPath) {
    Write-Host "  Directory already exists at: $dotnetPath" -ForegroundColor Gray
} else {
    mkdir $dotnetPath -Force | Out-Null
    Write-Host "  Created directory at: $dotnetPath" -ForegroundColor Green
}
Write-Host ""

# Download the install script
Write-Host "Step 2: Downloading Microsoft installation script..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile "dotnet-install.ps1"
    Write-Host "  Download complete!" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Failed to download installation script" -ForegroundColor Red
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to close this window..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}
Write-Host ""

# Install .NET Desktop Runtime 8.0.2 to your user directory
Write-Host "Step 3: Installing .NET Desktop Runtime 8.0.2..." -ForegroundColor Yellow
Write-Host "  This may take a few minutes..." -ForegroundColor Gray
Write-Host ""
& .\dotnet-install.ps1 -Runtime windowsdesktop -Version 8.0.2 -InstallDir $dotnetPath
Write-Host ""

# Check if installation succeeded by looking for runtime files
$runtimePath = Join-Path $dotnetPath "shared\Microsoft.WindowsDesktop.App\8.0.2"
if (Test-Path $runtimePath) {
    Write-Host "  Runtime installation complete!" -ForegroundColor Green
    Write-Host "  Runtime files installed at: $runtimePath" -ForegroundColor Gray
} else {
    Write-Host "  ERROR: Installation may have failed - runtime files not found" -ForegroundColor Red
    Write-Host "  Expected location: $runtimePath" -ForegroundColor Yellow
}
Write-Host ""

# Add to PATH for current session
Write-Host "Step 4: Configuring environment variables..." -ForegroundColor Yellow
$env:PATH = "$dotnetPath;$env:PATH"
Write-Host "  Added to current session PATH" -ForegroundColor Green

# Add to PATH permanently for your user
[Environment]::SetEnvironmentVariable("PATH", "$dotnetPath;$env:PATH", [EnvironmentVariableTarget]::User)
Write-Host "  Added to user PATH permanently" -ForegroundColor Green
Write-Host ""

# Verify installation by checking files
Write-Host "Step 5: Verifying installation..." -ForegroundColor Yellow
if (Test-Path $runtimePath) {
    $fileCount = (Get-ChildItem $runtimePath -File).Count
    Write-Host "  [OK] Desktop Runtime 8.0.2 installed successfully" -ForegroundColor Green
    Write-Host "  [OK] $fileCount runtime files found" -ForegroundColor Green
} else {
    Write-Host "  [WARNING] Could not verify runtime files" -ForegroundColor Yellow
}

# Clean up
Write-Host ""
Write-Host "Step 6: Cleaning up temporary files..." -ForegroundColor Yellow
Remove-Item "dotnet-install.ps1" -Force -ErrorAction SilentlyContinue
Write-Host "  Cleanup complete!" -ForegroundColor Green

# Final message
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Location: $dotnetPath" -ForegroundColor Cyan
Write-Host "Version: .NET Desktop Runtime 8.0.2" -ForegroundColor Cyan
Write-Host ""
Write-Host "NOTE: WPF and WinForms applications should now run correctly." -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to close this window..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
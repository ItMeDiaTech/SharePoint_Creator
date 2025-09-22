Write-Host "========================================"
Write-Host ".NET Desktop Runtime 8.0.2 Installer"
Write-Host "========================================"
Write-Host ""

# Set variables
$dotnetPath = "$env:USERPROFILE\.dotnet"
$installerScript = "dotnet-install.ps1"
$installerUrl = "https://dot.net/v1/dotnet-install.ps1"

# Step 1 - Create directory
Write-Host "Step 1: Creating installation directory..."
if (Test-Path $dotnetPath) {
    Write-Host "  Directory already exists"
} else {
    mkdir $dotnetPath -Force | Out-Null
    Write-Host "  Created directory"
}
Write-Host ""

# Step 2 - Download installer
Write-Host "Step 2: Downloading installer..."
try {
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerScript
    Write-Host "  Download complete"
} catch {
    Write-Host "  ERROR: Download failed"
    Write-Host "  Press any key to exit..."
    Read-Host
    exit 1
}
Write-Host ""

# Step 3 - Run installation
Write-Host "Step 3: Installing Desktop Runtime 8.0.2..."
Write-Host "  This may take a few minutes..."
& .\$installerScript -Runtime windowsdesktop -Version 8.0.2 -InstallDir $dotnetPath
Write-Host ""

# Step 4 - Check installation
Write-Host "Step 4: Checking installation..."
$runtimePath = "$dotnetPath\shared\Microsoft.WindowsDesktop.App\8.0.2"
if (Test-Path $runtimePath) {
    Write-Host "  SUCCESS: Runtime installed"
} else {
    Write-Host "  WARNING: Could not verify installation"
}
Write-Host ""

# Step 5 - Set PATH
Write-Host "Step 5: Setting PATH variable..."
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$dotnetPath*") {
    [Environment]::SetEnvironmentVariable("PATH", "$dotnetPath;$currentPath", "User")
    Write-Host "  PATH updated"
} else {
    Write-Host "  PATH already contains .NET location"
}
Write-Host ""

# Step 6 - Cleanup
Write-Host "Step 6: Cleaning up..."
if (Test-Path $installerScript) {
    Remove-Item $installerScript -Force
    Write-Host "  Temporary files removed"
}
Write-Host ""

# Done
Write-Host "========================================"
Write-Host "Installation Complete"
Write-Host "========================================"
Write-Host ""
Write-Host "Location: $dotnetPath"
Write-Host "Runtime: Desktop Runtime 8.0.2"
Write-Host ""
Write-Host "Press Enter to exit..."
Read-Host
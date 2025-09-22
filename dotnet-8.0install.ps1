# Create local directory for .NET
$dotnetPath = "$env:USERPROFILE\.dotnet"
mkdir $dotnetPath -Force

# Download the install script
Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile "dotnet-install.ps1"

# Install .NET 8.0 to your user directory
.\dotnet-install.ps1 -Channel 8.0 -InstallDir $dotnetPath

# Add to PATH for current session
$env:PATH = "$dotnetPath;$env:PATH"

# Add to PATH permanently for your user
[Environment]::SetEnvironmentVariable("PATH", "$dotnetPath;$env:PATH", [EnvironmentVariableTarget]::User)

# Verify installation
& "$dotnetPath\dotnet" --version
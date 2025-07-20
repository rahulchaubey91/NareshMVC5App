# Dockerfile - Full Setup for Windows MVC5 App Deployment
# This image sets up SSH, Git, JDK, Visual Studio Build Tools, and deploys the .NET MVC5 app

# Base image with IIS and .NET Framework 4.8
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8

# Environment
ENV JAVA_HOME="C:\\Program Files\\Java\\jdk-24"

# Set working directory
WORKDIR /build

# Copy PublishedApp from Jenkins workspace if available
COPY PublishedApp/ C:/inetpub/wwwroot/

# Optional: Add SSH public key for agent connection (replace with real key before build)
COPY id_ed25519.pub C:/Users/Administrator/.ssh/authorized_keys

# Install Dependencies using PowerShell
SHELL ["powershell", "-Command"]

RUN \ 
    Write-Host '📦 Installing Git, JDK, Visual Studio Build Tools, Docker CLI...'; \ 
    # 1. Git
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/Git-2.44.0-64-bit.exe -OutFile git.exe; \ 
    Start-Process .\git.exe -ArgumentList "/VERYSILENT" -Wait; \

    # 2. JDK (Optional if preinstalled)
    Invoke-WebRequest -Uri https://download.oracle.com/java/24/latest/jdk-24_windows-x64_bin.exe -OutFile jdk.exe; \
    Start-Process .\jdk.exe -ArgumentList "/s" -Wait; \

    # 3. Visual Studio Build Tools for MSBuild
    Invoke-WebRequest -Uri https://aka.ms/vs/17/release/vs_BuildTools.exe -OutFile vs_buildtools.exe; \
    Start-Process .\vs_buildtools.exe -ArgumentList "--quiet --wait --norestart --nocache --installPath C:\\BuildTools --add Microsoft.VisualStudio.Workload.WebBuildTools" -Wait; \

    # 4. Docker CLI (optional if Docker Desktop pre-installed)
    Invoke-WebRequest -Uri https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe -OutFile docker-installer.exe; \
    Start-Process .\docker-installer.exe -ArgumentList "install --quiet" -Wait; \

    # 5. Create SSH directory and apply key
    mkdir C:\\Users\\Administrator\\.ssh -Force; \
    icacls C:\\Users\\Administrator\\.ssh /inheritance:r; \
    icacls C:\\Users\\Administrator\\.ssh /grant "Administrator:F"; \
    icacls C:\\Users\\Administrator\\.ssh\\authorized_keys /inheritance:r; \
    icacls C:\\Users\\Administrator\\.ssh\\authorized_keys /grant "Administrator:F"; \

    # 6. Restart SSH
    Restart-Service sshd

# Expose default web port
EXPOSE 80

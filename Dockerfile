FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2022

WORKDIR /inetpub/wwwroot

# Only copy essential files
COPY . .

# Remove development-only files
RUN del /q /s *.pdb && del /q /s *.xml && del /q /s *.config

EXPOSE 80

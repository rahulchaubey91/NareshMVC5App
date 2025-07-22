# Use Microsoft base image with .NET Framework 4.8
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2022

WORKDIR /inetpub/wwwroot

# Copy build artifacts from published folder
COPY ./NareshMVC5App/ .

# Expose default IIS port
EXPOSE 80

# Use Windows IIS base image with .NET Framework 4.8
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2022

# Set working directory
WORKDIR /inetpub/wwwroot

# Copy published MVC5 app from Jenkins workspace into IIS root
COPY PublishedApp/ .

# Expose default HTTP port
EXPOSE 80

# IIS is already the entry point in the base image, no need to specify CMD

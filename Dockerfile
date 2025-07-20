# Use a base Windows image with IIS and .NET Framework 4.8
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8

# Set working directory
WORKDIR /inetpub/wwwroot

# Copy MVC5 web application files (pre-built) to IIS root
COPY ./PublishedApp/ .

# Expose default web port
EXPOSE 80

# Use the official image for .NET SDK 9.0 to build the app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Set the working directory
WORKDIR /src

# Copy the .csproj file and restore dependencies
COPY /CiCdDeployment.csproj ./CiCdDeployment/
RUN dotnet restore CiCdDeployment/CiCdDeployment.csproj

# Copy the rest of the files
COPY . .

# Publish the application to the /out folder
RUN dotnet publish /CiCdDeployment.csproj -c Release -o /out

# Use the official image for .NET 9.0 to run the app
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base

# Set the working directory in the runtime image
WORKDIR /app

# Copy the published app from the build stage
COPY --from=build /out .

# Expose the application port
EXPOSE 80

# Define the entry point to run the app
ENTRYPOINT ["dotnet", "CiCdDeployment.dll"]

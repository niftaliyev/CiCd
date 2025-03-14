# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Set the working directory inside the container
WORKDIR /src

# Copy the .csproj file and restore any dependencies (via dotnet restore)
COPY ["CiCdDeployment/CiCdDeployment.csproj", "CiCdDeployment/"]
RUN dotnet restore "CiCdDeployment/CiCdDeployment.csproj"

# Copy the rest of the project files
COPY . .

# Build the application in Release mode
RUN dotnet build "CiCdDeployment/CiCdDeployment.csproj" -c Release -o /app/build

# Publish the application to the /app/publish folder
RUN dotnet publish "CiCdDeployment/CiCdDeployment.csproj" -c Release -o /app/publish

# Use the official .NET runtime image for the final image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final

# Set the working directory inside the container
WORKDIR /app

# Copy the published files from the build container
COPY --from=build /app/publish .

# Expose the port the app will run on
EXPOSE 80

# Define the entry point for the container (the application to run)
ENTRYPOINT ["dotnet", "CiCdDeployment.dll"]

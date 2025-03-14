# Base image to run the app in production or debugging mode
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy the .csproj file to the working directory (/src)
COPY ["CiCdDeployment.csproj", "./"]  # Ensure it's copied correctly to /src

# Restore the dependencies for the project
RUN dotnet restore "CiCdDeployment.csproj"

# Copy the rest of the application code
COPY . .

WORKDIR "/src"  # This should be the root folder where .csproj is now present
RUN dotnet build "CiCdDeployment.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "CiCdDeployment.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final image to run the app in production or regular mode
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .  # Copy the published files
ENTRYPOINT ["dotnet", "CiCdDeployment.dll"]

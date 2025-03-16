FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app
EXPOSE 80
EXPOSE 443
COPY *.csproj ./CiCdDeployment
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o out
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./CiCdDeployment
EXPOSE 8085
ENTRYPOINT ["dotnet", "CiCdDeployment.dll"]

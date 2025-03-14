FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app
EXPOSE 80
EXPOSE 443
COPY *.csproj ./
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o out
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./
EXPOSE 80
ENTRYPOINT ["dotnet", "CiCdDeployment.dll"]

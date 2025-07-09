FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["src/BGPruebaDotNetPrueba/BGPruebaDotNetPrueba.csproj", "src/BGPruebaDotNetPrueba/"]
RUN dotnet restore "src/BGPruebaDotNetPrueba/BGPruebaDotNetPrueba.csproj"
COPY . .
WORKDIR "/src/src/BGPruebaDotNetPrueba"
RUN dotnet build "BGPruebaDotNetPrueba.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "BGPruebaDotNetPrueba.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BGPruebaDotNetPrueba.dll"]

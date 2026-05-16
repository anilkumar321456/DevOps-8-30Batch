#See https://aka.ms/customizecontainer

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# -------------------------------------------------
# COPY PROJECT FILES (FIXED PATHS WITH src/)
# -------------------------------------------------
COPY ["src/Services/Account/Account.API/Account.API.csproj", "Services/Account/Account.API/"]
COPY ["src/Services/Account/Account.Application/Account.Application.csproj", "Services/Account/Account.Application/"]
COPY ["src/Services/Account/Account.Domain/Account.Domain.csproj", "Services/Account/Account.Domain/"]
COPY ["src/Services/Account/Account.Infrastructure/Account.Infrastructure.csproj", "Services/Account/Account.Infrastructure/"]
COPY ["src/BuildingBlocks/Common.Logging/Common.Logging.csproj", "BuildingBlocks/Common.Logging/"]

# -------------------------------------------------
# ❌ EventBus.Messages DOES NOT EXIST in repo → removed
# COPY ["src/BuildingBlocks/EventBus.Messages/EventBus.Messages.csproj", "BuildingBlocks/EventBus.Messages/"]

# -------------------------------------------------
# RESTORE (FIXED)
# -------------------------------------------------
RUN dotnet restore "Services/Account/Account.API/Account.API.csproj"

# -------------------------------------------------
# COPY FULL SOURCE
# -------------------------------------------------
COPY src/ .

# -------------------------------------------------
# BUILD
# -------------------------------------------------
WORKDIR "/src/Services/Account/Account.API"

RUN dotnet build "Account.API.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/build

# -------------------------------------------------
# PUBLISH
# -------------------------------------------------
FROM build AS publish

ARG BUILD_CONFIGURATION=Release

WORKDIR "/src/Services/Account/Account.API"

RUN dotnet publish "Account.API.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/publish \
    /p:UseAppHost=false

# -------------------------------------------------
# FINAL IMAGE
# -------------------------------------------------
FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Account.API.dll"]

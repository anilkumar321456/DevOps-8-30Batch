#See https://aka.ms/customizecontainer

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# -------------------------------------------------
# COPY PROJECT FILES (FIXED WITH src/)
# -------------------------------------------------
COPY ["src/Services/Transaction/Transaction.API/Transaction.API.csproj", "Services/Transaction/Transaction.API/"]
COPY ["src/BuildingBlocks/Common.Logging/Common.Logging.csproj", "BuildingBlocks/Common.Logging/"]

# ❌ REMOVE THIS (NOT IN YOUR REPO)
# COPY ["src/BuildingBlocks/EventBus.Messages/EventBus.Messages.csproj", "BuildingBlocks/EventBus.Messages/"]

# -------------------------------------------------
# RESTORE
# -------------------------------------------------
RUN dotnet restore "Services/Transaction/Transaction.API/Transaction.API.csproj"

# -------------------------------------------------
# COPY FULL SOURCE
# -------------------------------------------------
COPY src/ .

# -------------------------------------------------
# BUILD
# -------------------------------------------------
WORKDIR "/src/Services/Transaction/Transaction.API"

RUN dotnet build "Transaction.API.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/build

# -------------------------------------------------
# PUBLISH
# -------------------------------------------------
FROM build AS publish

ARG BUILD_CONFIGURATION=Release

WORKDIR "/src/Services/Transaction/Transaction.API"

RUN dotnet publish "Transaction.API.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/publish \
    /p:UseAppHost=false

# -------------------------------------------------
# FINAL IMAGE
# -------------------------------------------------
FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Transaction.API.dll"]

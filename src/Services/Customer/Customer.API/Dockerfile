#See https://aka.ms/customizecontainer to learn how to customize your debug container

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# -------------------------------------------------
# COPY PROJECT FILES (FIXED with src/)
# -------------------------------------------------
COPY ["src/Services/Customer/Customer.API/Customer.API.csproj", "Services/Customer/Customer.API/"]
COPY ["src/Services/Customer/Customer.Application/Customer.Application.csproj", "Services/Customer/Customer.Application/"]
COPY ["src/Services/Customer/Customer.Domain/Customer.Domain.csproj", "Services/Customer/Customer.Domain/"]
COPY ["src/Services/Customer/Customer.Infrastructure/Customer.Infrastructure.csproj", "Services/Customer/Customer.Infrastructure/"]
COPY ["src/BuildingBlocks/Common.Logging/Common.Logging.csproj", "BuildingBlocks/Common.Logging/"]

# -------------------------------------------------
# RESTORE (FIXED PATH)
# -------------------------------------------------
RUN dotnet restore "Services/Customer/Customer.API/Customer.API.csproj"

# -------------------------------------------------
# COPY FULL SOURCE
# -------------------------------------------------
COPY src/ .

# -------------------------------------------------
# BUILD
# -------------------------------------------------
WORKDIR "/src/Services/Customer/Customer.API"

RUN dotnet build "Customer.API.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/build

# -------------------------------------------------
# PUBLISH
# -------------------------------------------------
FROM build AS publish

ARG BUILD_CONFIGURATION=Release

WORKDIR "/src/Services/Customer/Customer.API"

RUN dotnet publish "Customer.API.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/publish \
    /p:UseAppHost=false

# -------------------------------------------------
# FINAL RUNTIME IMAGE
# -------------------------------------------------
FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Customer.API.dll"]

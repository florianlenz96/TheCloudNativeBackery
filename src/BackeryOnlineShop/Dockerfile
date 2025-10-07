# Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy just the project file(s) first for restore caching
COPY src/BackeryOnlineShop/BackeryOnlineShop/BackeryOnlineShop.csproj ./BackeryOnlineShop/
RUN dotnet restore ./BackeryOnlineShop/BackeryOnlineShop.csproj

# Now copy the rest
COPY src/BackeryOnlineShop/. .
WORKDIR /src/BackeryOnlineShop
RUN dotnet publish BackeryOnlineShop/BackeryOnlineShop.csproj -c Release -o /app/publish --no-restore

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# ASP.NET images default to 8080 inside containers
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Ensure the DLL name matches your project output
ENTRYPOINT ["dotnet", "BackeryOnlineShop.dll"]

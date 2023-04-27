FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5140

ENV ASPNETCORE_URLS=http://+:5140

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["mrweeks.csproj", "./"]
RUN dotnet restore "mrweeks.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "mrweeks.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "mrweeks.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "mrweeks.dll"]

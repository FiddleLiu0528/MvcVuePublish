#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["CoreMvcVuePractice/CoreMvcVuePractice.csproj", "CoreMvcVuePractice/"]
RUN dotnet restore "CoreMvcVuePractice/CoreMvcVuePractice.csproj"
COPY . .
WORKDIR "/src/CoreMvcVuePractice"
RUN dotnet build "CoreMvcVuePractice.csproj" -c Release -o /app/build

RUN apt-get update -y
RUN apt-get install npm -y

FROM build AS publish
RUN dotnet publish "CoreMvcVuePractice.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CoreMvcVuePractice.dll"]

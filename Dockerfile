# create the build instance 
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src                                                                    
COPY ./src ./
# restore solution
RUN dotnet restore sampleappdotnetcore.sln

# build project   
RUN dotnet build sampleappdotnetcore.csproj -c Release

# Publish project
FROM build AS publish
WORKDIR /src
RUN dotnet publish sampleappdotnetcore.csproj -c Release -o /app/publish

FROM base As final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","sampleappdotnetcore.dll"]
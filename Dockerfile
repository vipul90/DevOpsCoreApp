FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime 
WORKDIR /app
COPY DevopsAppPublish/app/publish .
ENTRYPOINT ["dotnet", "DevopsApp.dll"]
EXPOSE 90
EXPOSE 444
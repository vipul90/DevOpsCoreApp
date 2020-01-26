FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app
COPY Binaries/app/publish .
ENTRYPOINT ["dotnet", "CoreApplication.dll"]
EXPOSE 80
EXPOSE 443
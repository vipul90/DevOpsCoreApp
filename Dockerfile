FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build-env
WORKDIR /app
COPY Binaries/app/publish .
ENTRYPOINT ["dotnet", "CoreApplication.dll"]
EXPOSE 90
EXPOSE 444
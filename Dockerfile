FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
WORKDIR /app
COPY Binaries/app/publish .
ENTRYPOINT ["dotnet", "CoreApplication.dll"]
EXPOSE 80
EXPOSE 443
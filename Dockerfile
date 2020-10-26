FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["TodoApi.csproj", "TodoApi/"]
RUN dotnet restore "TodoApi/TodoApi.csproj"
COPY . ./TodoApi
WORKDIR "/src/TodoApi"
RUN dotnet build "TodoApi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TodoApi.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
#ENTRYPOINT ["dotnet", "TodoApi.dll"]
## If I use ENTRYPOINT I cannot do the following:
## $ docker run -it --rm <image-name:image-tag> bash
CMD ["dotnet", "TodoApi.dll"]
## If I use CMD I CAN do the following:
## $ docker run -it --rm <image-name> bash

## to run ise -d and -p port mapping like below:
## $ docker run -d -p 8088:80 --name todoapp <image-name:image-tag>
## to debug because we use CMD, get into the running container and check
## $ docker exec -it todoapp bash
## we can also check logs
## $ docker logs todoapp
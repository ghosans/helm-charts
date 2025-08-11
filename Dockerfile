FROM artifactory.manulife.ca/endorsed-docker/ets-dotnet:8-sdk-1.0.0 as builder
USER 0
WORKDIR /app
# Copy everything
COPY . ./
# Build and publish a release
RUN dotnet restore --disable-parallel
RUN dotnet publish --no-restore <app-name> -c Release -o out
# Build runtime image
FROM artifactory.manulife.ca/endorsed-docker/ets-dotnet:8-sdk-1.0.0
WORKDIR /app
USER 0
RUN chmod 777 /app
COPY --from=builder --chown=dotnet:dotnet /app/out .
USER 1000
EXPOSE 5000
ENTRYPOINT dotnet <app-name>.dll --launch-profile "IIS Express"

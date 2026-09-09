FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter gen-l10n
RUN flutter build web \
    --dart-define=API_BASE_URL=http://localhost:8000 \
    --dart-define=MESH_GATEWAY_API_KEY=change_this_mesh_gateway_key \
    --dart-define=ENVIRONMENT=development

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
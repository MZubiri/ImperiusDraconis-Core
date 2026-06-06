FROM node:22-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . ./
RUN npm run build -- --configuration production

FROM nginx:alpine AS final

RUN apk add --no-cache gettext

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/imperiusdraconis-web/browser /usr/share/nginx/html
RUN mkdir -p /usr/share/nginx/html/assets/config
COPY src/assets/config/runtime-config.template.json /usr/share/nginx/html/assets/config/runtime-config.template.json
COPY docker-entrypoint.d/40-runtime-config.sh /docker-entrypoint.d/40-runtime-config.sh
RUN chmod +x /docker-entrypoint.d/40-runtime-config.sh

EXPOSE 80

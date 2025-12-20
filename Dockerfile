# syntax=docker/dockerfile:1

ARG NODE_VERSION=24-trixie
ARG DEVCONTAINER_VERSION=24-trixie

FROM node:${NODE_VERSION} AS base
ENV APP_ENV=production
ENV APP_PORT=8080
ENV NODE_ENV=production
WORKDIR /workspaces

FROM base AS development_deps
COPY ./package.json ./
RUN npm run npm:install:development

FROM base AS production_deps
COPY ./package.json ./
RUN npm run npm:install:production

FROM development_deps AS build
COPY ./ ./
RUN npm run build

FROM base AS runtime
COPY --from=production_deps /workspaces/package.json ./
COPY --from=production_deps /workspaces/package-lock.json ./
COPY --from=production_deps /workspaces/node_modules ./node_modules
COPY --from=build /workspaces/dist ./dist
COPY --from=build /workspaces/static ./static
COPY --from=build /workspaces/views ./views
CMD ["node", "./dist/index.js"]

FROM mcr.microsoft.com/devcontainers/typescript-node:${DEVCONTAINER_VERSION} AS devcontainer

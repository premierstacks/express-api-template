# syntax=docker/dockerfile:1

ARG NODE_VERSION=24

FROM node:${NODE_VERSION} as base

FROM base AS development_deps
ENV NODE_ENV=production
WORKDIR /app
COPY ./package.json ./package-lock.json ./
RUN npm run npm:ci:development

FROM development_deps AS build
COPY ./ ./
RUN npm run build

FROM base AS production_deps
ENV NODE_ENV=production
WORKDIR /app
COPY ./package.json ./package-lock.json ./
RUN npm run npm:ci:production

FROM base AS server
ENV NODE_ENV=production
ENV PORT=8080
WORKDIR /app
USER node
COPY --from=production_deps --chown=node:node /app/package.json ./
COPY --from=production_deps --chown=node:node /app/package-lock.json ./
COPY --from=production_deps --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/dist ./dist
COPY --from=build --chown=node:node /app/static ./static
COPY --from=build --chown=node:node /app/views ./views
CMD ["node", "./dist/index.js"]

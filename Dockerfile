# syntax=docker/dockerfile:1

ARG NODE_VERSION=24

FROM node:${NODE_VERSION} as base
ENV NODE_ENV=production
ENV PORT=8080
WORKDIR /app

FROM base AS development_deps
COPY ./package.json ./package-lock.json ./
RUN npm run npm:install

FROM development_deps AS build
COPY ./ ./
RUN npm run build

FROM development_deps AS production_deps
RUN npm run npm:prune

FROM base AS server
USER node
COPY --from=production_deps --chown=node:node /app/package.json ./
COPY --from=production_deps --chown=node:node /app/package-lock.json ./
COPY --from=production_deps --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/dist ./dist
COPY --from=build --chown=node:node /app/static ./static
COPY --from=build --chown=node:node /app/views ./views
CMD ["node", "./dist/index.js"]

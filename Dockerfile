FROM node:20-alpine AS build

RUN apk add --update --no-cache make gcc g++ python3 linux-headers udev tzdata

WORKDIR /app
RUN echo "Current working directory is: $(pwd)"

COPY package*.json ./
COPY defaultConfig.json config.json
RUN npm ci

RUN ls

RUN echo "Current working directory is: $(pwd)"

COPY . .
RUN npm run build
RUN npm ci --omit=dev

# Work-around for outdated cpp bindings is to rebuild them on the device
WORKDIR /app/node_modules/@serialport/bindings-cpp
RUN echo "Current working directory is: $(pwd)"
RUN npm run rebuild

WORKDIR /app
RUN echo "Current working directory is: $(pwd)"

FROM node:20-alpine AS prod

RUN apk add --update --no-cache git
RUN mkdir /app && chown node:node /app

# Add group with GID 46 (matches /dev/ttyUSB0 group on host) and add node user to it
RUN addgroup -g 46 usbaccess && \
    addgroup node usbaccess

# Optional: Confirm user and group setup at build time
RUN id node

WORKDIR /app

COPY --chown=node:node --from=build /app .

USER node

ENV NODE_ENV=production

EXPOSE 5150

ENTRYPOINT ["node", "dist/app.js"]

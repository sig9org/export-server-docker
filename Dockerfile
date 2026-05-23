FROM node:26-bookworm-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/jgraph/draw-image-export2.git .

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN npm install --omit=dev && npm cache clean --force


FROM node:26-bookworm-slim

WORKDIR /app

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    NODE_ENV=production \
    LANG=ja_JP.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    fonts-ipafont-gothic \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app /app

USER node

EXPOSE 8000

CMD ["node", "export.js"]

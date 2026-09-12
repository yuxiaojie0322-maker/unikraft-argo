FROM node:alpine3.22

WORKDIR /tmp

RUN apk update && apk upgrade && \
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash ca-certificates procps

# 预先在镜像构建阶段下载稳定版 Xray 和 cloudflared，实现 0 秒冷启动并彻底脱离第三方个人外链依赖
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"; \
        CF_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-arm64-v8a.zip"; \
        CF_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"; \
    else \
        XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"; \
        CF_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"; \
    fi && \
    curl -fsSL "$XRAY_URL" -o /tmp/xray.zip && \
    unzip -q /tmp/xray.zip xray -d /usr/local/bin/ && \
    mv /usr/local/bin/xray /usr/local/bin/xray-core && \
    chmod +x /usr/local/bin/xray-core && \
    rm -f /tmp/xray.zip && \
    curl -fsSL "$CF_URL" -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

COPY index.js index.html package.json ./

RUN chmod +x index.js && npm install

EXPOSE 3000/tcp

CMD ["node", "index.js"]

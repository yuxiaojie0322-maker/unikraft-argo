# Unikraft Cloud Argo 多协议部署 (VMess / VLESS / Trojan)

本项目支持将 **Xray + Cloudflare Argo Tunnel** 一键部署到 Unikraft Cloud 极速微内核环境，支持在 `fra`、`was`、`dal`、`sin`、`sfo` 5 大全球数据中心并发运行。

## 🌟 特性

- **支持多种协议**：默认同时生成 **VMess-WS**、**VLESS-WS**、**Trojan-WS** 节点。
- **Argo 隧道穿透**：通过 Cloudflare Argo Tunnel 建立长连接，流量全程加密，无惧 GFW 封锁。
- **自带 Web 订阅管理**：访问实例生成的官方域名（或 `https://域名/sub`）即可实时获取所有节点链接与 Base64 订阅。
- **支持固定专属域名**：配合 Cloudflare Zero Trust Tunnel Token，可绑定自己的专属固定域名（如 `argo.blibli.kdns.fr`）。

---

## 🚀 部署方式

### 方式一：GitHub Actions 一键运行（推荐）

1. 进入仓库的 **Actions** 标签页，点击左侧的 **`unikraft-argo-deploy`** 流水线。
2. 点击右侧的 **Run workflow**：
   - **操作类型**：选择 `deploy`。
   - **部署区域**：选择 `all`（一次性部署 5 大机房）或单个机房。
   - **固定 Argo 域名**：填入绑定的域名（如 `argo.blibli.kdns.fr`，不填则自动使用免费临时隧道）。
   - **Argo Token**：填入 Cloudflare Zero Trust 申请的 Tunnel Token。
   - **UUID**：默认已预填 `694949f5-54c3-4113-b3c9-2d2518f770f4`。
3. 点击 **Run workflow** 运行即可！

---

## 🔑 如何获取 Cloudflare Argo Tunnel Token？

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com/)。
2. 左侧菜单进入 **Zero Trust** -> **Networks (网络)** -> **Tunnels (隧道)**。
3. 点击 **Create a tunnel (创建隧道)**，选择 **Cloudflared**，输入隧道名称（如 `unikraft-argo`），点击保存。
4. 在页面命令中复制 `--token` 后面的字符串（形如 `eyJhIjoi...`），这串就是 `ARGO_TOKEN`。
5. 在 **Public Hostnames (公共主机名)** 页面：
   - **Subdomain**：例如 `argo`
   - **Domain**：选择你的域名（如 `blibli.kdns.fr`）
   - **Service**：选择 `HTTP`，URL 填 `localhost:3000`（或 `localhost:8001`）。
6. 保存即可完成固定隧道的配置！

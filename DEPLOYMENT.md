# DEPLOYMENT.md — 部署架构与运维

> **当前生产环境(2026-06-06 起)**:DNSPod → **腾讯云轻量应用服务器(广州,119.29.119.124)** → Nginx 静态直出。
> HTTPS 用 Let's Encrypt(acme.sh + DNSPod API DNS-01,cron 自动续期)。已完成 ICP 备案:**粤ICP备2026072152号**。
> 旧的 Vercel 软接入方案已**降级为灾备**(代码仍同步到 GitHub,DNS 平时不指向它,出问题可切回)。
> 迁移全过程见 `CONTEXT.md` 的 2026-06-06 日志。

生产访问入口:
- `https://www.backtap.cn` — 网站本体
- `https://backtap.cn` — 301 跳转到 `https://www.backtap.cn`
- `https://backtap-website.vercel.app` — Vercel 灾备入口(备用)

---

## 当前架构

```
用户浏览器
    ↓
DNSPod(域名解析,腾讯云资产)
    ↓
腾讯云轻量应用服务器(广州,119.29.119.124)
    ↓
Nginx(80 → 301 跳 https;443 ssl http2)
    ↓
静态文件直出  /var/www/backtap-website
```

### 服务器信息

| 项目 | 值 |
|---|---|
| 提供商 | 腾讯云轻量应用服务器(广州) |
| 公网 IP | `119.29.119.124` |
| 实例 ID | `lhins-asfe6mul` |
| 系统 | CentOS 7.6,root |
| 登录方式 | 腾讯云控制台 OrcaTerm 网页终端 +「执行命令」(TAT 免密) |
| 站点根目录 | `/var/www/backtap-website` |
| Web 服务 | Nginx 1.20.1 |
| 安全组 | 控制台「防火墙」放行 TCP **80/443**(`firewalld` 未运行,`SELinux=Disabled`) |

> ⚠️ 本地未配置免密 SSH,无法直接 SSH 进服务器。所有服务器操作走**腾讯云控制台**(OrcaTerm 网页终端或「执行命令」TAT)。

### DNS 配置(DNSPod,已生效)

| 主机记录 | 类型 | 记录值 | record_id |
|---|---|---|---|
| `@` | A | `119.29.119.124` | 2299967360 |
| `www` | A | `119.29.119.124` | 2299967533 |

> 历史:迁移前 `@` 指向 Vercel `76.76.21.21`、`www` 为 CNAME `cname.vercel-dns.com`。如需切回 Vercel 灾备,把这两条改回即可。

### Nginx 配置

- 配置文件:`/etc/nginx/conf.d/backtap.conf`
- 80 端口:`301` 跳转到 https
- 443 端口:`ssl http2`,`server_name backtap.cn www.backtap.cn`,`root` 指向 `/var/www/backtap-website`

### HTTPS

- `acme.sh`(v3.1.3)+ DNSPod API(`dns_dp`,`DP_Id=631126`)走 **DNS-01** 验证签发 Let's Encrypt 证书(`backtap.cn` + `www`,90 天有效期)。
- 证书安装在 `/etc/nginx/ssl/`,`acme.sh --install-cert` 已设 `reloadcmd`。
- **cron 自动续期**,无需手工维护。

---

## 内容更新流程

**核心:改完代码 → `git push` 到 GitHub `main` → 让服务器拉取最新代码并替换站点目录。**

### 第 1、2 步(本地)

```bash
# 改完 HTML / 图片 / 视频
git add .
git commit -m "改了什么"
git push origin main
```

### 第 3 步(服务器拉取并上线)

服务器上有更新脚本 `/root/update-site.sh`,逻辑:`curl` 从 GitHub codeload 拉最新 `main` 的 tarball → 原子替换 `/var/www/backtap-website` → 旧版本备份到 `/var/www/backtap-website.old`。

在**腾讯云控制台**执行(「执行命令」TAT 或 OrcaTerm 网页终端任选其一):

```bash
bash /root/update-site.sh
```

跑完后 Nginx 直接直出新文件,即时生效。

> ℹ️ **关于"自动部署"**:据称服务器上可能配置了自动拉取流程(如 cron 定时跑 `update-site.sh`),`git push` 后无需手动到控制台执行。但该机制**未记录在仓库或 `CONTEXT.md`,也无法从本地验证**(仓库无 GitHub Actions;日志里唯一的 cron 是 HTTPS 证书续期,不是内容更新)。
>
> **自查方法**:在控制台跑 `crontab -l`,看是否有定时调用 `update-site.sh` 的条目。
> - 若有 → 说明确实是自动的,`git push` 后等待对应间隔即可生效,把上面的"第 3 步"改成"等 cron 自动触发"。
> - 若没有 → 自动流程不存在,仍需手动跑第 3 步。
>
> 在确认之前,**以手动跑 `update-site.sh` 为准**,这是 2026-06-06 验证过的可靠方式。

### 回滚

```bash
rm -rf /var/www/backtap-website && mv /var/www/backtap-website.old /var/www/backtap-website
```

---

## 微信域名验证文件(勿误删)

根目录 `c8f7f2da7d285bb6826d4a7996ace6ec.txt`(微信域名归属验证,内容 40 字节)。

- 该文件已纳入 git 仓库,`update-site.sh` 替换站点目录时会一并带上。
- 历史上服务器那份曾是手动写入,现仓库已有同名文件,正常更新流程不会丢失。
- 若哪天微信复检且较真要求 http 直出 `200`(不跟随 301),在 nginx 80 端口 server 块加:
  `location = /c8f7f2da7d285bb6826d4a7996ace6ec.txt { root /var/www/backtap-website; }`

---

## 灾备:Vercel(已降级保留)

- 代码仍 `push` 到 GitHub `arise130315/backtap-website`(`main`),Vercel 项目仍连着仓库,会继续自动构建 `backtap-website.vercel.app`。
- DNS 平时**不指向** Vercel。生产出问题时,把 DNSPod 的 `@`/`www` 记录改回 Vercel(`76.76.21.21` / `cname.vercel-dns.com`)即可临时切回。
- `vercel.json` 保留 `outputDirectory: "."`(静态零构建,Application Preset = Other)。

---

## 备案信息

- ICP 备案号:**粤ICP备2026072152号**(个人 / 纯静态展示页面)。
- 三个 HTML 的 footer 已挂备案号链接。
- 备案绑定资源:腾讯云轻量应用服务器(就是当前这台 119.29.119.124)。

---

## 现有 COS 资产(暂未启用)

桶 `backtap-website-1310488725`(广州地域)含完整网站文件 + 静态托管已开启,作为**未来切腾讯云 CDN 加速国内访问**的预置资产保留。如果将来访问量大、要加速国内访问,可走「备案已完成 → 腾讯云 CDN + COS」路径。

---

## 文件清单(对外服务)

```
backtap.cn/  (= /var/www/backtap-website/)
├── index.html              首页
├── privacy.html            隐私政策
├── tutorial.html           使用教程
├── c8f7f2da...ace6ec.txt   微信域名验证文件
└── public/
    ├── fonts/              字体(AlibabaPuHuiTi 等)
    ├── images/             图片(logo, img1, img2 等)
    └── videos/             演示视频(mp4)
```

---

**当前会话进度记录在 `CONTEXT.md`,每次会话结束都会更新。**

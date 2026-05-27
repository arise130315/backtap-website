# CONTEXT.md — iOS快捷翻译官网

> 项目当前状态。**每次会话结束前更新这份文件**,把这次做了什么、卡在哪、下次接着做什么写清楚。
> 详细的每日改动可以选择性记到 `daily/[日期].md`。

---

## 当前进度

**🎉 网站已上线运行**,生产环境:
- `https://backtap.cn`(主域,307 跳转到 www)
- `https://www.backtap.cn`(规范域)
- `https://backtap-website.vercel.app`(Vercel 默认子域)

**架构**:DNSPod → Vercel,见 `DEPLOYMENT.md`。**走"软接入"路径,未走 ICP 备案**。

## 正在做什么

无新工作。运维进入"内容更新即上线"模式:`git push` 自动触发 Vercel 部署,30-60 秒生效。

## 未解决的问题 / 卡点

- **软接入合规风险**:`.cn` 解析到境外属灰色,小概率被工信部要求整改。监控点是 DNSPod 后台收到通知。**应对**:被要求时启动 ICP 备案(资产已就绪,见 `DEPLOYMENT.md` 备用路径)。
- **国内访问首屏 2-5 秒**:Vercel 没大陆节点。**当前可接受**,如未来访问量起来后觉得慢,走 ICP 备案 → 切腾讯云 CDN(文件已躺在 COS 里)。
- ~~`public/images/logo2.png` 1.1MB 偏大~~ **已压(2026-05-27 续):logo2/img1/img2 + 3 个大视频统一压缩,public/ 从 23MB → 8.3MB**。
- Tailwind 走 `cdn.tailwindcss.com`,Vercel 站点国内访问也尚可,不阻塞。

## 下一步打算

**计划中:把"软接入"升级到"正规 ICP 备案"(路径 A:试用 + 续费 + 备案)**。

### 当前进展

- ✅ 腾讯云轻量应用服务器**新用户 1 个月免费试用已开通**(2核2G3M / CentOS 7.6 / 广州)
- ⏳ 等试用期内决定续费(预计 7-14 天后)

### 时间表

| 阶段 | 用户做什么 |
|---|---|
| **现在 - 试用期(1 个月内)** | 可选:登录服务器看看体验;不登录也行,**纯作为备案资源占位** |
| **试用期内续费(关键!)** | 用「1 年立享 3.5 折」优惠续费 **1 年套餐**,满足备案 ≥3 月有效期要求。**不续费会自动停机或释放,备案前必须续费** |
| **续费后立刻发起备案** | 进腾讯云备案系统(https://console.cloud.tencent.com/beian) → 「新增备案」→ 云资源选**「轻量应用服务器」+ 刚续费的实例**(之前卡在这里,因为 COS 不接受) |
| **备案审核 2-3 周** | 等。可能接管局回访电话,照实答("个人开发者作品/纯静态展示/不收集用户信息") |
| **备案号下发** | 通知 Claude → 改 3 个 HTML footer 加备案号链接;可选:DNS A 记录从 `76.76.21.21`(Vercel)切到腾讯云 CDN(国内速度大幅提升) |

### 备案表填写要点(下次会话直接抄)

- **主办单位性质**:个人
- **备案区域**:广东省 / 珠海市 / 香洲区(身份证地址)
- **网站名称**:**快捷识屏**(品牌名,**不要带"翻译/AI/工具"等敏感词**)
- **应用服务类型**:网站/域名
- **域名**:backtap.cn
- **云资源**:轻量应用服务器 → 选实例
- **网站内容描述**:"本网站为个人开发者作品 iOS 工具应用'快捷识屏'的官方介绍页面,展示应用功能、使用教程及下载入口。网站为纯静态展示页面,不提供用户注册、评论、内容发布等交互功能,不收集用户个人信息。网站负责人为独立开发者本人,自有著作权。"

### 启动信号

下次会话说"**开始备案**"或"**轻量服务器要续费了**",Claude 按上面清单逐步引导。

### 关于服务器未来用途(已和用户对齐) **决策已变更**

> **变更原因**:用户实际国内访问 Vercel 太慢,改用国内服务器作为官网主源。

**最终架构(备案通过后)**:

```
                  backtap.cn / www
                         │
        ┌────────────────┴────────────────┐
        │                                  │
   主流量(95%)                       灾备(5%)
        │                                  │
   轻量服务器(广州)                  Vercel
   ├─ Nginx 跑静态站                 └─ 留着,DNS 平时不指,出问题切回
   ├─ HTML / CSS / 字体
   ├─ 视频(可选搬 COS)
   ├─ 备案号挂 footer
   └─ HTTPS(Let's Encrypt 或腾讯云免费证书)
```

**关键原则**:
- 服务器**作为 backtap.cn 主源站**,因为国内访问 Vercel 跨境延迟太大
- **Vercel 不删**,作为灾备(代码继续 push GitHub,Vercel 自动同步),服务器挂了 DNS 切回去 5 分钟恢复
- 3M 带宽约束:对小流量个人站够用,如果将来用户量起来,升级带宽包或加腾讯云 CDN
- iOS app 后端 API 用 `api.backtap.cn` 子域(还是这台服务器,以后做)

**备案通过后的迁移步骤(到时候 Claude 陪做)**:

1. SSH 登录服务器(腾讯云控制台一键登录)
2. `yum install nginx` 装 Nginx
3. `rsync ~/Desktop/iOS_SnapTranslate_website/ user@ip:/var/www/` 上传文件
4. 配 nginx.conf(Claude 写好,用户复制粘贴)
5. Let's Encrypt 签 HTTPS 证书 + cron 自动续期
6. DNSPod 改 A 记录:`@` 和 `www` 从 `76.76.21.21` 改成服务器公网 IP
7. footer 加备案号链接

预计 30 分钟-1 小时完成。

**iOS app 后端 API 启动信号**:用户说"开始做 iOS app 后端" → Claude 帮装 Node.js/Python + MySQL + 写第一版 API,跑在同一台服务器上,通过 `api.backtap.cn` 子域对外服务。

---

## 历史备份(原下一步打算)

之前也提过这条路径,内容已被上面替代:

### 为什么要做

当前 `backtap.cn` 软接入 Vercel 属合规灰色,长期不稳。备案后:
- 完全合法,不怕工信部抽查
- 备案号可以放 footer 增加可信度
- 备案完成后可选切换到腾讯云 CDN+COS,国内访问速度大幅提升
- COS 桶 `backtap-website-1310488725` 文件齐全,备案通过后 10 分钟就能切

### 备案准备清单(下次会话直接照做)

| 步骤 | 备注 |
|---|---|
| 1. 买**腾讯云轻量应用服务器**(必须的备案资源,COS 不算) | 1核2G 中国大陆 1 年 ≈ ¥99-128。买完闲置不用,纯过路费 |
| 2. 进腾讯云备案系统:https://console.cloud.tencent.com/beian | 点「新增备案」 |
| 3. 填表(主体信息已实名,会自动带入) | 网站信息**严格按 DEPLOYMENT.md 第 4.2 节模板**,不要带"翻译/AI"敏感词 |
| 4. 云资源选**「轻量应用服务器」+ 刚买的实例** | 上次卡在这里——COS 不能选 |
| 5. 腾讯云 App 人脸核验 | 手机扫码做 |
| 6. 提交后等审核:**腾讯云初审 1-2 工作日 → 管局终审 7-20 工作日** | 中间可能接管局回访电话 |
| 7. 备案号下发后,改 3 个 HTML 的 footer 加备案号链接 | 工信部要求,Claude 可以帮做 |
| 8. (可选)备案通过后把 DNS A 记录从 `76.76.21.21` 改成腾讯云 CDN | 提升国内访问速度,文件早已在 COS 上躺着 |

### 启动信号

用户在下次会话说"开始备案"即可,Claude 按上面清单逐步引导。当前**不阻塞**任何工作,网站正常运行中。

---

## 会话日志(倒序,最新在上)

> 每次会话结束前在最上方插一条:
>
> ```
> ### YYYY-MM-DD (Claude Code / Codex)
> - 做了什么
> - 关键改动文件
> - 留给下次的尾巴
> ```

### 2026-05-27 (续 5) (Claude Code) - 视频 poster + preload 调整
- 用户反馈国内访问慢、视频看不见。诊断后确认:
  - 视频文件本身没问题(Range / faststart / 编码全过)
  - 真正瓶颈是 Vercel 跨境网络(只有备案 → 切腾讯云 CDN 能根治)
  - 加剧"看不见"感受的两个因素:① video 标签 `preload="metadata"` 滚到才开始下载;② 没有 poster 占位,加载前是黑/透明
- 改动:
  - ffmpeg 提取两个视频首帧 → cwebp 转 WebP(quality 75):
    - `public/images/poster_快捷翻译.webp` 37K
    - `public/images/poster_快捷分析.webp` 40K
  - index.html 第 335 / 352 行两个 video 标签:
    - `preload="metadata"` → `preload="auto"`(加速开始下载视频)
    - 新增 `poster="public/images/poster_..."`(加载前显示静态首帧,不再空白)
- 效果:首次访问时即便视频还没加载完,用户也能立刻看到一张静态图,**视觉上不再"什么都没"**;同时视频在后台并行下载,用户滚到时多半已就绪。
- public/ 增加 ~76K(两张 poster),从 1.9M → ~2.0M。不影响整体瘦身成果。

### 2026-05-27 (续 4) (Claude Code) - 图片 WebP 化 + logo 降分辨率
- 用户决策:图片转 WebP + logo 降到 512×512。
- 工具:`brew install webp`(新装,得 cwebp 1.6.0);ffmpeg 不带 libwebp 编译选项,转 WebP 用 cwebp 不用 ffmpeg。
- 改动:
  - **logo2.png 降到 512×512 + 重量化**:用 sips 缩到 512(覆盖)后,因为 sips 重新编码丢了 pngquant 的 256 色板,文件反而从 82K 涨到 184K,**再用 pngquant quality 70-90 量化一次**回到 32K。最终给 `<link rel="icon"|apple-touch-icon>` 用。
  - **3 张 PNG 转 WebP**(cwebp -q 80 -m 6):
    - logo2.png 32K → logo2.webp 15K(-53%)
    - img1.png 66K → img1.webp 39K(-42%)
    - img2.png 28K → img2.webp 24K(-12%,img2 本身简单图,WebP 优势小)
  - **HTML 引用切换**(用 Edit replace_all):3 个 HTML 里所有 `<img src="public/images/logo2.png">` 改为 `logo2.webp`(5 处);tutorial.html 里 `img1.png/img2.png` 改为 `.webp`(2 处);**保留 `<link rel="icon"|apple-touch-icon>` 指向 logo2.png** 给老浏览器 / RSS / 桌面快捷方式兼容。
  - **删除 img1.png 和 img2.png**(已不被任何 HTML 引用);logo2.png 保留(favicon 用)
- 关键改动文件:
  - `public/images/logo2.png`(从 1024×1024 → 512×512,重新量化,82K → 32K)
  - `public/images/logo2.webp`(新增,15K)
  - `public/images/img1.webp` / `img2.webp`(新增,共 63K)
  - `public/images/img1.png` / `img2.png`(删除)
  - `index.html` / `privacy.html` / `tutorial.html`(5+1+1 处 img src 改 webp)
- **最终 public/ = 1.9MB**(从最初 23MB,累计省 92%)
- 留给下次的尾巴:
  - WebP 兼容性:Chrome/Firefox/Safari 14+/Edge 全部支持,Safari < 14 用户(2020 之前的 Mac/iOS)会看不到 logo 和教程图。如果担心,可以加 `<picture>` fallback 标签,但目前不做。
  - PuHuiTi 字体 984KB 仍是最大单文件(占 1.9MB 的一半),如果还想再瘦,子集化是最有效手段(可压到 80-150KB)

### 2026-05-27 (续 3) (Claude Code) - 字体瘦身:删 Inter + PuHuiTi TTF→WOFF2
- 用户决策:
  - Inter 字体太冗余,改用系统字体兜底(macOS/iOS 走 -apple-system + PingFang SC,Windows 走 Microsoft YaHei)
  - 阿里巴巴普惠体保留,但 TTF → WOFF2 减体积
- 改动:
  - 3 个 HTML 的 `tailwind.config.fontFamily.sans` 数组**去除 "Inter"**,保留剩余系统字体栈
  - 3 个 HTML 删除 Inter @font-face 整块
  - index.html / privacy.html 的 PuHuiTi @font-face 的 `src` 从 `.ttf` `format("truetype")` 改为 `.woff2` `format("woff2")`(tutorial.html 不用 PuHuiTi,无需改)
  - 用 `woff2_compress` 工具(brew install woff2)将 PuHuiTi TTF 转 WOFF2:1.9MB → 984KB(无损,Brotli 内压)
  - 删除 `public/fonts/InterVariable.woff2`(344KB)
  - 删除 `public/fonts/AlibabaPuHuiTi-2-105-Heavy.ttf`(1.9MB)
- **最终 public/ 大小:2.0MB**(从最初 23MB,累计省 91%)
- 关键改动文件:
  - `public/fonts/AlibabaPuHuiTi-2-105-Heavy.woff2`(新增,984K)
  - `public/fonts/AlibabaPuHuiTi-2-105-Heavy.ttf`(删除)
  - `public/fonts/InterVariable.woff2`(删除)
  - `index.html` / `privacy.html` / `tutorial.html`(3 处 Edit:sans 去 Inter、删 Inter @font-face、PuHuiTi src 换 woff2)
- 留给下次的尾巴:
  - 用户在浏览器验证字体效果:正文应跟之前差不多(因为之前 Inter 也是字体栈第一位,但实际多数中文场景早就走 PingFang/PuHuiTi),英文部分会变成系统默认 sans-serif
  - 如果用户觉得英文字体也想要专门的视觉,可以选 WOFF2 子集版的 Inter 或者保留少数字重(只 400/600 两个) → 减体积 80%

### 2026-05-27 (续 2) (Claude Code) - 媒体二次压缩 + 清理无引用视频
- 用户要求进一步压缩。
- 删除两个无 HTML 引用的视频:`教程.mp4`(3.0MB)、`效果展示.mp4`(1.1MB),立省 4.1MB。
- 视频降分辨率 + 重压:1108×1864 → 720×1212(CRF 28 不变),手机演示视频在网页上显示尺寸约 300-400px,720px 源完全够。
  - 快捷分析.mp4 904KB → 496KB(-48%)
  - 快捷翻译.mp4 788KB → 480KB(-43%)
- PNG 再压:
  - logo2.png 84KB → 84KB(**pngquant 量化到极限,quality 50-70 已无效**。如要再小,只能降分辨率,1024→512 可省一半,但当前未做)
  - img1.png 140KB → 68KB(从 1920px 降到 1280px + quality 50-70)
  - img2.png 60KB → 28KB(同上)
- 最终:**public/ 8.3MB → 3.4MB**(累计从最初 23MB 减少 85%)
- commit:`(下一条)`
- 留给下次的尾巴:
  - 用户验证视觉(720px 视频 + 1280px 图)是否能接受
  - 不接受 → 视频回 1108px / 图回 1920px(用 git checkout 单文件即可)
  - logo2.png 如果还想继续压,降到 512×512

### 2026-05-27 (续) (Claude Code) - 媒体压缩
- 用户反馈国内访问慢、图片/视频加载慢,做媒体资源压缩。
- 根本原因(已和用户讲清楚):Vercel 没大陆节点,跨境 RTT 是结构性瓶颈,**只有走 ICP 备案 + 国内 CDN 才能根治**。今天做的是次要原因(资源体积)的优化。
- **压缩成果**:public/ 从 23MB → 8.3MB(省 64%)
  - logo2.png 1.1MB → 84KB(pngquant quality 70-90,保持 1024×1024)
  - img1.png 1.3MB → 140KB(sips 缩放 3854→1920px + pngquant)
  - img2.png 535KB → 60KB(同上)
  - 快捷分析.mp4 6.6MB → 904KB(libx264 CRF 28 + faststart + 去音轨,原码率 11Mbps 严重过高)
  - 快捷翻译.mp4 6.5MB → 788KB(原码率 8.7Mbps)
  - 教程.mp4 4.0MB → 3.0MB(原码率 2.2Mbps 本来就合理,压幅有限)
  - 效果展示.mp4 不动(原本就 0.9Mbps)
- 所有 MP4 加了 `-movflags +faststart`,moov atom 前置 → 视频边下边播。
- 关键工具:ffmpeg 8.1.1(已装)、pngquant(brew 装的)、sips(macOS 自带)
- 关键改动文件:`public/images/*.png` 3 个、`public/videos/*.mp4` 3 个
- commit:`f0a8836 Compress media: public/ 23MB -> 8.3MB (-64%)`(已 push,Vercel 自动重新部署中)
- 留给下次的尾巴:
  - 用户在浏览器看一下视觉质量是否能接受(CRF 28 是行业常用网页视频参数,肉眼几乎无差,但用户是设计师,以他眼睛为准)
  - 如果觉得质量损失大 → 用 CRF 23 重压(体积稍大,质量更好)
  - 真正解决"国内访问慢"还是要走备案 → 腾讯云 CDN

### 2026-05-27 (Claude Code)
- **网站上线**:走 Vercel + DNSPod 软接入路径,放弃 ICP 备案。
- 期间方案多次调整,最终决策路径:
  1. 一开始计划:腾讯云 COS+CDN + 备案 backtap.cn(指南 v1)
  2. 中途切到:腾讯云 COS 桶建好、12 个文件上传完成、Content-Type 修正,但发起备案时发现腾讯云**不接受 COS 作为备案资源**,只接受云服务器/轻量服务器/备案授权码,意味着备案至少多花 ¥99/年。
  3. 用户决策:放弃备案,走软接入 + Vercel 路径。
- **Vercel 部署**:
  - 创建 Vercel 项目 `backtap-website`,关联 GitHub `arise130315/SnapTranslate_website`,main 分支。
  - 首次部署 404,原因:Vercel 在 "Other" preset 下检测到 `public/` 目录就当作输出目录。修复:加 `vercel.json` 显式 `outputDirectory: "."`,push 后 Vercel 自动重新部署成功。
  - Vercel 默认子域 `backtap-website.vercel.app` 上线。
- **域名绑定**:
  - Vercel Settings → Domains 添加 `backtap.cn` + 勾选「Redirect backtap.cn → www.backtap.cn」。
  - DNSPod 控制台配置两条记录:`@ A 76.76.21.21`、`www CNAME cname.vercel-dns.com`。
  - DNS 全球生效后 Vercel 自动签 Let's Encrypt 证书,HSTS 开启。
- **关键改动文件**:
  - 新增 `vercel.json`(3 行,显式声明 outputDirectory)
  - 重写 `DEPLOYMENT.md` 为 Vercel 软接入方案,把原备案方案降级为"备用路径"
  - 更新 `CONTEXT.md` 反映最终架构
- **遗留资产**:
  - 腾讯云 COS 桶 `backtap-website-1310488725`(广州)和里面 12 个文件保留,作为"未来想正规备案时的预置资产"。每月几分钱存储费,不删除以保留备案选项。
  - 腾讯云轻量服务器没买(本来要为备案买,放弃备案后不需要)。
- **本次 commit(已 push 到 GitHub)**:
  - `1beec7b` Add mobile menu + smooth scroll, fix footer links, add privacy page
  - `4ab5e04` Self-host Inter font, remove Google Fonts dependency
  - `79ecaed` Add aliyun OSS+CDN deployment guide (老版本指南)
  - `0cb7b33` Switch deployment guide from aliyun to tencent cloud (中间版本)
  - `4ff7eec` Add vercel.json to fix 404 on root deploy
  - 即将 commit:DEPLOYMENT.md 重写为 Vercel 方案 + CONTEXT.md 更新
- **留给下次的尾巴**:
  - 🎯 **用户已决定后续把"软接入"升级到"正规 ICP 备案"**(详细清单见上方「下一步打算」段落),但不急,以后说"开始备案"再做
  - 后续优化可做:压缩 logo2.png(1.1MB → ~100KB)、Tailwind 预编译为本地 CSS
  - 内容更新只需 `git push`,Vercel 自动部署

### 2026-05-26 (Claude Code)
- 推进官网上线准备工作,完成阶段 1 全部本地化处理,准备好部署指南。
- 提交 3 个 commit(已 push 到 GitHub):
  - `1beec7b` Add mobile menu + smooth scroll, fix footer links, add privacy page —— 收尾上次会话遗留的未提交改动:移动端汉堡菜单、平滑滚动 `scroll-behavior: smooth` + `scroll-padding-top: 80px`、页脚锚点链接修复、`privacy.html` 新增。
  - `4ab5e04` Self-host Inter font, remove Google Fonts dependency —— 三个页面统一移除 Google Fonts 引用,新增本地 Inter @font-face(Variable 字体,352KB)。原因:Google Fonts 国内被墙。
  - `79ecaed` Add aliyun OSS+CDN deployment guide —— 首版 DEPLOYMENT.md(阿里云方案)+ 更新 CONTEXT.md。
- 后续(同日)切换到腾讯云方案:用户告知已在腾讯云购买 backtap.cn,重写 DEPLOYMENT.md 为腾讯云方案。
- 本地验证:三个页面 + 字体文件全部 HTTP 200,无 Google Fonts 残留。

### 2026-05-25 (Codex)
- 删除测试页产物:按用户要求删除 `weekend-cafe.html`,未应用浏览器批注中的颜色、透明度、边框修改,因为目标测试页已删除。
- 关键改动文件:删除 `weekend-cafe.html`;更新 `CONTEXT.md`。
- 根据浏览器批注更新 `weekend-cafe.html`:将首屏标题改为"111";未改动其它页面区域。
- 验证 `weekend-cafe.html`:本地静态服务打开页面,确认标题为"周末咖啡地图"、首屏文案正常、共有 3 张卡片;点击"安静"筛选后仅显示"窗边一号桌"1 张卡片。
- 更新 `weekend-cafe.html`:将首屏和三张卡片的远程图片改为内嵌视觉图;同步调整测试指标文案。
- 新增 `weekend-cafe.html`:创建"周末咖啡地图"单页测试网站,包含首屏大图、店铺卡片、筛选按钮、半日路线、测试指标和页脚;选择独立文件是为了不覆盖已有 `index.html` 改动。
- 留给下次的尾巴:如果要让这个测试站成为默认入口,需要再确认是否替换 `index.html`。

# CONTEXT.md — iOS快捷翻译官网

> 项目当前状态。**每次会话结束前更新这份文件**,把这次做了什么、卡在哪、下次接着做什么写清楚。
> 详细的每日改动可以选择性记到 `daily/[日期].md`。

---

## 当前进度

官网已完成"国内上线前的本地化改造":自托管 Inter 字体、移除 Google Fonts、收尾上次会话遗留的移动端菜单/滚动优化。代码已 push 到 GitHub。

**部署方案已切换为腾讯云**(因为用户在腾讯云购买了域名 `backtap.cn`)。完整操作指南在 [DEPLOYMENT.md](DEPLOYMENT.md)。

**域名 `backtap.cn` 当前状态**:已购买,正在「命名审核」(CNNIC 对 `.cn` 域名名称的合规审核,1-5 工作日)。

## 正在做什么

等用户在腾讯云完成:
1. 命名审核通过(等)
2. 域名实名认证(命名审核通过后用户提交)
3. 开 COS + 上传文件(可以在备案前做)
4. 发起 ICP 备案(审核 2-3 周)

期间代码侧无新工作。

## 未解决的问题 / 卡点

- **`.cn` 命名审核 + 实名认证 + ICP 备案**全流程约 2-4 周,这段时间国内访问 `backtap.cn` 不通。备案审核前可用 COS 临时访问节点(`backtap-website-xxx.cos-website.ap-guangzhou.myqcloud.com`)预览。
- `public/images/logo2.png` 体积 1.1MB 偏大,后续 CDN 上线后建议压缩(用 tinypng),不阻塞上线。
- Tailwind 仍走 `cdn.tailwindcss.com`,国内访问尚可。如果上线后发现首屏卡顿,需要预编译为本地 CSS。当前不阻塞。
- 视频文件 `public/videos/*.mp4` 体积未压,上线后看 CDN 流量再决定要不要压。

## 下一步打算

1. **用户**:等 `backtap.cn` 命名审核通过 → 实名认证。
2. **用户(可提前做)**:开 COS 存储桶(参照 `DEPLOYMENT.md` 第 3 章),把网站文件传上去。Claude 可以帮配 coscli 一键同步。
3. **用户**:发起 ICP 备案(参照 `DEPLOYMENT.md` 第 4 章,网站信息直接抄 4.2 模板)。
4. **备案通过后**:绑定域名 + 开 CDN + HTTPS + 加备案号(`DEPLOYMENT.md` 第 5 章)。

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

### 2026-05-26 (Claude Code)
- 推进官网上线准备工作,完成阶段 1 全部本地化处理,准备好部署指南。
- 提交 3 个 commit(已 push 到 GitHub `arise130315/SnapTranslate_website`):
  - `1beec7b` Add mobile menu + smooth scroll, fix footer links, add privacy page —— 收尾上次会话遗留的未提交改动:移动端汉堡菜单、平滑滚动 `scroll-behavior: smooth` + `scroll-padding-top: 80px`、页脚锚点链接修复(privacy.html / mailto)、`privacy.html` 新增。
  - `4ab5e04` Self-host Inter font, remove Google Fonts dependency —— 三个页面统一移除 `fonts.googleapis.com` 的 preconnect 和 stylesheet 引用,在 `<style>` 内新增 Inter @font-face 指向本地 `public/fonts/InterVariable.woff2`(Variable 字体,一个文件覆盖 100-900 全部字重,352KB)。原因:Google Fonts 国内被墙,会让首屏卡 5-10 秒等超时。
  - `79ecaed` Add aliyun OSS+CDN deployment guide —— 首版 `DEPLOYMENT.md`(阿里云方案)+ 更新 `CONTEXT.md`。
- **方案切换**:用户告知已在腾讯云购买域名 `backtap.cn`,当前命名审核中。**重写 `DEPLOYMENT.md` 为腾讯云方案**(COS 替代 OSS、腾讯云 CDN、备案系统、DNSPod)。原因:备案接入商必须与域名服务商一致,否则需要走域名转入流程,非常折腾。
- 关键改动文件:
  - `index.html` / `privacy.html` / `tutorial.html`:`<head>` 区域删除 3 行 Google Fonts 引用,`<style>` 块顶部新增 Inter @font-face(11 行)
  - 新增 `public/fonts/InterVariable.woff2`(352KB)
  - `DEPLOYMENT.md`:从阿里云方案完全改写为腾讯云方案,覆盖账号 → 域名状态(命名审核/实名)→ COS → 备案 → CNAME/CDN/HTTPS/备案号全流程,含网站信息填写模板
  - `CONTEXT.md`:重写当前状态、卡点、下一步
- 本地验证:`python3 -m http.server 8766` 起静态服务,三个页面 + 两个字体文件 + logo 全部 HTTP 200,无 Google Fonts 残留。
- 留给下次的尾巴:
  - 用户命名审核通过 + 实名通过后,通知 Claude → 帮装 coscli + 配 SecretKey + 一键同步整个项目到 COS
  - 备案通过后,告知 Claude 备案号 → 改 3 个 HTML 的 footer 加备案号链接
  - 后续优化(非阻塞):压缩 `logo2.png`(1.1MB → ~100KB)、Tailwind 预编译为本地 CSS、视频压制

### 2026-05-25 (Codex)
- 删除测试页产物:按用户要求删除 `weekend-cafe.html`,未应用浏览器批注中的颜色、透明度、边框修改,因为目标测试页已删除。
- 关键改动文件:删除 `weekend-cafe.html`;更新 `CONTEXT.md` 第 8 行起的当前状态、正在做什么、卡点、下一步。
- 根据浏览器批注更新 `weekend-cafe.html`:将首屏标题从"给一个周末,安排三杯好咖啡。"改为"111",对应文件第 466 行附近;未改动其它页面区域。
- 验证 `weekend-cafe.html`:通过本地静态服务打开页面,确认标题为"周末咖啡地图"、首屏文案正常、共有 3 张卡片;点击"安静"筛选后仅显示"窗边一号桌"1 张卡片。
- 更新 `weekend-cafe.html`:将首屏和三张卡片的远程图片改为内嵌视觉图,避免本地打开时受网络影响;同步调整测试指标文案。
- 新增 `weekend-cafe.html`:创建"周末咖啡地图"单页测试网站,包含首屏大图、店铺卡片、筛选按钮、半日路线、测试指标和页脚;选择独立文件是为了不覆盖已有 `index.html` 改动。
- 关键改动文件:`weekend-cafe.html` 第 1 行起新增完整静态页面,并在样式和卡片图片处改为内嵌视觉图;`CONTEXT.md` 第 8 行起更新当前状态、卡点、下一步,并在会话日志记录本次改动。
- 留给下次的尾巴:如果要让这个测试站成为默认入口,需要再确认是否替换 `index.html`。

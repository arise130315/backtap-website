# CONTEXT.md — iOS快捷翻译官网

> 项目当前状态。**每次会话结束前更新这份文件**,把这次做了什么、卡在哪、下次接着做什么写清楚。
> 详细的每日改动可以选择性记到 `daily/[日期].md`。

---

## 当前进度

官网已经完成"国内上线前的本地化改造":自托管 Inter 字体、移除 Google Fonts、提交了上次会话遗留的移动端菜单/滚动优化。代码层面已经具备"传到 OSS 就能跑"的状态。

部署方案选定:**阿里云 OSS + CDN + `.cn`/`.com.cn` 域名 + ICP 备案**。完整操作指南已写入 `DEPLOYMENT.md`。

## 正在做什么

等用户去阿里云完成:
1. 注册阿里云账号 + 个人实名认证
2. 购买 `.cn` 或 `.com.cn` 域名
3. 发起 ICP 备案(审核期约 2-3 周)

期间代码侧无新工作。

## 未解决的问题 / 卡点

- **ICP 备案需 2-3 周**,这段时间国内域名不可用。备案审核前可以先开通 OSS、用 OSS 默认域名(`*.oss-cn-hangzhou.aliyuncs.com` 之类)预览站点。
- `public/images/logo2.png` 体积 1.1MB 偏大,后续 CDN 上线后建议压缩,但不影响功能,不阻塞上线。
- Tailwind 仍走 `cdn.tailwindcss.com`,目前国内访问尚可。如果上线后发现首屏卡顿,需要把 Tailwind 预编译为本地 CSS。当前不阻塞。

## 下一步打算

1. **用户**:照着 `DEPLOYMENT.md` 第 2-3 章,在阿里云买域名 + 个人实名 + 发起 ICP 备案。
2. **备案审核期间(2-3 周)**:可参照 `DEPLOYMENT.md` 第 4 章,先开通 OSS、上传文件、用 OSS 默认域名预览。
3. **备案通过后**:照 `DEPLOYMENT.md` 第 5 章绑定域名、开 CDN + 免费 HTTPS 证书,正式上线。

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
- 提交两个 commit:
  - `1beec7b` Add mobile menu + smooth scroll, fix footer links, add privacy page —— 把上次会话遗留的未提交改动收尾:移动端汉堡菜单、平滑滚动 `scroll-behavior: smooth` + `scroll-padding-top: 80px`、页脚锚点链接修复(privacy.html / mailto)、`privacy.html` 新增。
  - `4ab5e04` Self-host Inter font, remove Google Fonts dependency —— 三个页面统一移除 `fonts.googleapis.com` 的 preconnect 和 stylesheet 引用,在 `<style>` 内新增 Inter @font-face 指向本地 `public/fonts/InterVariable.woff2`(Variable 字体,一个文件覆盖 100-900 全部字重,352KB)。原因:Google Fonts 国内被墙,会让首屏卡 5-10 秒等超时。
- 关键改动文件:
  - `index.html` / `privacy.html` / `tutorial.html`:`<head>` 区域删除 3 行 Google Fonts 引用,`<style>` 块顶部新增 Inter @font-face(11 行)
  - 新增 `public/fonts/InterVariable.woff2`(352KB)
  - 新增 `DEPLOYMENT.md`:完整阿里云 OSS + CDN 部署指南,含买域名/实名/备案/上传文件/绑定域名/开 CDN 每一步操作清单 + 备案资料填写模板
  - 重写 `CONTEXT.md` 当前状态、卡点、下一步
- 本地验证:`python3 -m http.server 8766` 起静态服务,三个页面 + 两个字体文件 + logo 全部 HTTP 200,无 Google Fonts 残留。
- 留给下次的尾巴:
  - 用户买完域名 + 发起备案后,把域名告诉 Claude,可以帮看备案进展、准备 OSS 配置。
  - 备案通过后,可以用 `ossutil` 命令行批量上传文件到 OSS,无需在控制台手动拖。
  - 后续优化(非阻塞):压缩 logo2.png(1.1MB → 几十 KB)、Tailwind 预编译为本地 CSS。

### 2026-05-25 (Codex)
- 删除测试页产物:按用户要求删除 `weekend-cafe.html`,未应用浏览器批注中的颜色、透明度、边框修改,因为目标测试页已删除。
- 关键改动文件:删除 `weekend-cafe.html`;更新 `CONTEXT.md` 第 8 行起的当前状态、正在做什么、卡点、下一步。
- 根据浏览器批注更新 `weekend-cafe.html`:将首屏标题从"给一个周末,安排三杯好咖啡。"改为"111",对应文件第 466 行附近;未改动其它页面区域。
- 验证 `weekend-cafe.html`:通过本地静态服务打开页面,确认标题为"周末咖啡地图"、首屏文案正常、共有 3 张卡片;点击"安静"筛选后仅显示"窗边一号桌"1 张卡片。
- 更新 `weekend-cafe.html`:将首屏和三张卡片的远程图片改为内嵌视觉图,避免本地打开时受网络影响;同步调整测试指标文案。
- 新增 `weekend-cafe.html`:创建"周末咖啡地图"单页测试网站,包含首屏大图、店铺卡片、筛选按钮、半日路线、测试指标和页脚;选择独立文件是为了不覆盖已有 `index.html` 改动。
- 关键改动文件:`weekend-cafe.html` 第 1 行起新增完整静态页面,并在样式和卡片图片处改为内嵌视觉图;`CONTEXT.md` 第 8 行起更新当前状态、卡点、下一步,并在会话日志记录本次改动。
- 留给下次的尾巴:如果要让这个测试站成为默认入口,需要再确认是否替换 `index.html`。

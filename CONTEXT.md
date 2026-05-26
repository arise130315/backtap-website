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
- `public/images/logo2.png` 1.1MB 偏大,后续可用 tinypng 压到 100KB 内。
- Tailwind 走 `cdn.tailwindcss.com`,Vercel 站点国内访问也尚可,不阻塞。

## 下一步打算

无明确下一步。日常按需更新内容即可。

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
  - 如果访问量起来后想上备案 → 买腾讯云轻量服务器(¥99-120/年)→ 走 DEPLOYMENT.md 备用路径
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

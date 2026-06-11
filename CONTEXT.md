# CONTEXT.md — iOS快捷翻译官网

> 项目当前状态。**每次会话结束前更新这份文件**,把这次做了什么、卡在哪、下次接着做什么写清楚。
> 详细的每日改动可以选择性记到 `daily/[日期].md`。

---

## 当前进度

**🎉 网站已上线运行(2026-06-06 起已切腾讯云服务器,备案合规闭环完成)**,生产环境:
- `https://backtap.cn` / `https://www.backtap.cn`(均走服务器 + HTTPS)
- `https://backtap-website.vercel.app`(Vercel 默认子域,**已降级为灾备**)

**架构(2026-06-06 起)**:DNSPod → **腾讯云轻量服务器(广州,公网 119.29.119.124,实例 lhins-asfe6mul,CentOS 7.6)**。Nginx 1.20.1 跑静态站(root `/var/www/backtap-website`),HTTPS 用 Let's Encrypt(acme.sh + DNSPod API `dns_dp` 自动续期),备案号挂三页 footer。**ICP 备案:粤ICP备2026072152号**。Vercel 保留作灾备(平时 DNS 不指,出问题把 `@` 改回 `76.76.21.21`、`www` 改回 CNAME `cname.vercel-dns.com` 即恢复)。详见 `DEPLOYMENT.md` 与下方 2026-06-06 日志。

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

### 备案进度(实时更新)

- ✅ **2026-05-26**:轻量服务器试用版开通 → 续费 1 年(¥168,到期 2027-06-27)
- ✅ **2026-05-26 23:42**:**ICP 备案已提交**!订单号 3017798*** ,状态「腾讯云审核中」
- 已勾「公安联网备案同步」 → 备案通过后自动生成公安备案数据码,免去手动填一遍
- ⏳ 等腾讯云 1-2 工作日内电话核身(010-5610-3419/8024/8028/3415/8023 已加通讯录),接电话答"个人开发者作品/纯静态展示/不收集用户信息"
- ⏳ 工信部短信核验(24 小时内)
- ⏳ 管局终审 1-20 工作日

下次会话可以问 Claude:"备案进度怎么样?"——根据时间判断当前应该到哪一步。

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
3. `rsync ~/Desktop/backtap-website/ user@ip:/var/www/` 上传文件
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

### 2026-06-11 (Claude Code) - 窄屏下功能卡片背景收缩到与视频同尺寸
- **需求**:窄屏(<768px)下「快捷翻译/快捷分析」两张卡片的彩色背景块是全宽 600px 高,而视频只有约 320×540,两侧留大片空底色;要求窄屏下背景尺寸与 video 完全一致。
- **改动**:`index.html` 两处:
  - `<style>` 内 `.phone-mockup`(约 L129-145):基础样式改为固定 `height: 540px`(= 原 600px 卡片的 90%,视频视觉尺寸不变),video 加 `max-width: 100%` 防超窄屏溢出;新增 `@media (min-width: 768px)` 恢复 `height: 90%`。
  - 两张卡片背景 div(现 L317、L334):`h-[600px]` 改为 `w-fit max-w-full mx-auto h-auto overflow-hidden` + `md:w-auto md:mx-0 md:h-[600px]`。窄屏卡片收缩到正好包住视频并水平居中,`overflow-hidden` 让视频直角被卡片 32px 圆角裁掉;≥768px 布局与改前完全一致。
- **顺手新增**:`.claude/launch.json`(本地预览配置,`npx http-server . -p 4173`;注意必须显式传 `.`,否则 http-server 默认优先服务 `./public` 子目录)。要不要进 git 由用户定。
- **验证**:本地起 http-server 用预览面板实测三档宽度——375px 和 700px 下卡片 320.8×540 与 video 尺寸完全一致且水平居中;1280px 下卡片 596×600、视频 540 高居中,与改前一致。
- **留给下次的尾巴**:还没提交/部署。上线流程:`git push` 后到服务器跑 `bash /root/update-site.sh`(非 Vercel 自动)。

### 2026-06-07 (Claude Code) - 首页常见问题新增 2 张卡片
- **需求**:FAQ 区原有 4 张卡片,用户要求再加 2 张(对比常规翻译 app、核心能力补充)。
- **改动**:`index.html` FAQ 区(原 L360-363 第 4 张卡片后)插入两张卡片,结构、class、`data-i18n` 风格与现有完全一致:
  - `faq.q5`「它和市面常规的手机翻译 app 有什么不一样？」/ `faq.a5`(常规需进 app 输入内容/图片,快捷翻译可在任意场景敲背面跨端识屏)
  - `faq.q6`「除了翻译外它还有哪些核心能力？」/ `faq.a6`(还支持快捷识图分析、敏感信息打码)
- **说明**:`data-i18n` 属性目前没有任何脚本消费(index.html 两段 script 只管导航/滚动揭示/移动端菜单,无 i18n 逻辑),页面直接显示标签内中文。新卡片照旧带 `data-i18n` 仅为与现有风格统一,不影响显示。两列网格(`md:grid-cols-2`)自动排成第 3 行。
- **留给下次的尾巴**:还没部署。按既有流程 `git push` 后到服务器跑 `bash /root/update-site.sh` 才会上线(非 Vercel 自动)。

### 2026-06-07 (Claude Code) - 解除微信打开 backtap.cn 的"无法确认安全性"拦截
- **问题**:微信内打开 backtap.cn 弹「将要访问 / 无法确认该网页的安全性」拦截页。原因是**新域名未被微信安全库收录**,跟网站内容/备案无关。
- **解法**:走微信「申请恢复访问 → 部署验证文件」做**域名归属验证**,在网站根目录放微信指定的 TXT:
  - 文件名 `c8f7f2da7d285bb6826d4a7996ace6ec.txt`,内容 `b5ec32bdea6e0f70b6096765307d910d911e9c31`(40 位,精确匹配,无尾随换行)。
- **放哪(关键)**:backtap.cn 现解析到腾讯云服务器(119.29.119.124),文件必须放**服务器根目录** `/var/www/backtap-website/`,不是 Vercel/仓库。用户在腾讯云网页终端粘贴单行命令写入(`printf '%s' '...' > ...txt && chmod 644`)。本地 Mac 没配免密 SSH,进不去,所以走控制台终端。
- **验证(本地 curl 加 `--noproxy '*'`)**:HTTPS `200`、content-length 40、内容一字不差 ✅;HTTP 按既有规则 `301` 跳 HTTPS,跟随跳转可取得内容。用户回微信点「已部署,开始验证」→ **通过,拦截解除**。
- **仓库同步**:同名文件加到仓库根目录一份(Vercel 灾备也有)。⚠️ 服务器那份是**手动写入、非 git 跟踪**,以后若重新部署/覆盖服务器目录需留意别丢失这个文件。
- **留给下次的尾巴**:若哪天微信复检且较真要求 http 直出 `200`(不跟随 301),在 nginx 80 端口 server 块加一行 `location = /c8f7f2da7d285bb6826d4a7996ace6ec.txt { root /var/www/backtap-website; }` 即可;本次没做(已验证通过,无必要)。

### 2026-06-06 (Claude Code) - 备案通过 → 挂备案号 → 切腾讯云服务器上线(合规闭环完成)
- **里程碑**:backtap.cn 域名 ICP 备案审核通过,备案号 **粤ICP备2026072152号**。
- **挂备案号**(工信部硬性要求:footer 展示备案号文字 + 超链接到工信部系统 `https://beian.miit.gov.cn/`):
  - `index.html`(footer 第 445 区块):版权号外包一层 flex,把备案号链接和「© 2026…」放同一组左对齐,「一款极简的识屏工具」仍右对齐。
  - `privacy.html`(L139)、`tutorial.html`(L91):居中版权行后用 `ml-2` 接备案号链接。
  - 三处统一写法:`<a href="https://beian.miit.gov.cn/" target="_blank" rel="noopener noreferrer" class="hover:text-ink-900 transition-colors">粤ICP备2026072152号</a>`,沿用现有 footer 链接风格,无新增 CSS。
- **部署**:`git push` → Vercel 自动部署。当前 backtap.cn 的 DNS 仍指向 Vercel(76.76.21.21),所以备案号 30-60 秒后即时在 backtap.cn 生效。
- **顺带提交**:上次 05-28 改名会话遗留未提交的文档同步(AGENTS.md / DEPLOYMENT.md / CONTEXT.md 里旧路径 `SnapTranslate_website` → `backtap-website`),内容正确,本次一并提交。
- **未纳入提交**:工作区里 `CONTEXT_副本.md`(疑似用户手动备份)留在原地,不进仓库。
- **✅ 合规闭环已完成(同日继续,用户选择立刻切)**:把主源从 Vercel 迁到备案绑定的腾讯云轻量服务器。全过程:
  - **服务器**:腾讯云轻量(广州),公网 IP **119.29.119.124**,实例 `lhins-asfe6mul`,CentOS 7.6,root,网页终端 OrcaTerm + TAT 免密登录。`SELinux=Disabled`、`firewalld` 未运行(只靠控制台防火墙)。
  - **环境**:`yum install -y nginx git`(走腾讯云内网镜像,CentOS7 EOL 无影响) → nginx 1.20.1。控制台「防火墙」放行 TCP **80/443**。
  - **代码**:GitHub `git clone` 弱网屡断(RPC failed / early EOF,含浅克隆也失败)。最终用 `curl -L codeload.github.com/arise130315/backtap-website/tar.gz/refs/heads/main` 下载 tarball 成功 → 解压到 `/var/www/backtap-website`(`--strip-components=1`)。
  - **Nginx 配置**:`/etc/nginx/conf.d/backtap.conf`(80 → 301 跳 https;443 ssl http2;`server_name backtap.cn www.backtap.cn`;root 指向站点目录)。用 `printf` 单行写避免网页终端多行粘连坑。
  - **HTTPS**:`acme.sh`(gitee 镜像装,v3.1.3)+ DNSPod API(`dns_dp`,DP_Id=631126)DNS-01 验证 → 签 Let's Encrypt 证书(backtap.cn + www,90天)。证书装 `/etc/nginx/ssl/`,`--install-cert` 已设 `reloadcmd`,**cron 自动续期**。
  - **DNS 切换**:用 DNSPod API `Record.Modify` 把 `@` 的 A `76.76.21.21`→`119.29.119.124`(record_id 2299967360)、`www` 的 CNAME→A `119.29.119.124`(record_id 2299967533)。权威即时生效,公共 DNS 传播中。
  - **验证**:`https://backtap.cn` + `www` 均 HTTP/2 200、备案号在、80 强制跳 https、证书 Let's Encrypt 有效。(本地 Mac 验证时注意系统代理会忽略 `--resolve`,需加 `--noproxy '*'`。)
- **留给下次的尾巴**:
  - ✅ **更新网站流程已建立**(2026-06-06 验证通过):服务器有 `/root/update-site.sh`(`curl` 拉 codeload tarball + 原子替换 + 旧版备份到 `.old`)。**日常更新三步**:① 本地改代码 → ② `git push` → ③ 服务器跑 `bash /root/update-site.sh`(腾讯云控制台「执行命令」或 OrcaTerm 网页终端均可)。回滚:`rm -rf /var/www/backtap-website && mv /var/www/backtap-website.old /var/www/backtap-website`。
  - 🔑 **DNSPod token 安全**:DP_Id=631126 + Token 已在本次对话明文出现,且存进服务器 `~/.acme.sh/account.conf`(供自动续期)。如要轮换需同步更新 acme.sh,否则续期失败。**当前未轮换。**
  - **Vercel 灾备**:保留;代码仍可 push GitHub(Vercel 自动同步)。服务器挂了把 DNS 改回 Vercel 即恢复(见上方「当前进度」)。
  - 本地 `CONTEXT_副本.md` 仍未跟踪/未处理。
  - 本文件「正在做什么 / 下一步打算 / 备案进度」等旧段落记的是"计划备案 + 计划切服务器",现已全部落地,**下次可清理精简**。

### 2026-05-28 (Claude Code) - 仓库 + 本地目录改名为 backtap-website
- **背景**:统一品牌名,旧 `SnapTranslate_website` 跟域名 `backtap.cn` 不对应,改成 `backtap-website` 与产品域名一致。
- **执行三件套**:
  1. `gh repo rename` 把 GitHub 仓库 `arise130315/SnapTranslate_website` → `arise130315/backtap-website`(GitHub 自动保留旧 URL 的 301 重定向)。
  2. `git remote set-url origin` 更新本地 remote URL。
  3. `mv` 本地文件夹 `~/Desktop/iOS_SnapTranslate_website` → `~/Desktop/backtap-website`。
- **关联文档同步**:`AGENTS.md`(L7-8)、`CONTEXT.md`(L103、L259)、`DEPLOYMENT.md`(L17、L47)里的路径/URL 全部更新。全局配置 `~/.claude/CLAUDE.md`、`~/.codex/AGENTS.md`、`~/.shared-agent-memory/GLOBAL.md` 第 25 行的项目登记表也一并更新。
- **不动**:中文显示名「iOS快捷翻译官网」、AGENTS.md 标题、产品本身的展示文案保持不变(品牌外观不变,仅仓库工程标识改了)。
- **验证**:`gh repo view` 确认远端新名生效;`git ls-remote` 连通新 URL 成功;`grep -rn "SnapTranslate_website\|iOS_SnapTranslate_website"` 全局无残留。
- **留给下次的尾巴**:
  - **Vercel** 关联仓库通过 GitHub App 内部 ID 跟踪,理论上自动跟上重命名。建议下次有空登录 Vercel dashboard 看一眼 Settings → Git 那里显示的仓库名是不是已经变成 `backtap-website`;如果没变可以 Disconnect 再 Reconnect 一次。
  - 旧 GitHub URL(`...SnapTranslate_website`)会一直保留 301,任何残留在外部文档/书签的旧链接不会断,但建议看到就改。

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
  - 创建 Vercel 项目 `backtap-website`,关联 GitHub `arise130315/backtap-website`,main 分支。
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

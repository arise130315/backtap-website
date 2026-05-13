# 快捷翻译 SnapTranslate — 官方网站

iOS App「快捷翻译」的官方落地页。深色主题，单文件静态站，无需构建。

## 预览

直接双击 `index.html` 即可在浏览器中查看。

## 结构

```
index.html          # 首页（Hero + 视频）
tutorial.html       # 详细教程页（图文步骤）
public/
  images/
    logo.png        # 品牌 logo
    img1.png        # 教程图 1
    img2.png        # 教程图 2
  videos/
    教程.mp4         # 首屏循环演示视频
```

## 技术栈

- 原生 HTML + Tailwind CSS（CDN）
- Inter 字体（Google Fonts）
- 纯 CSS 动效 + 原生 JS 实现毛玻璃导航和中英切换

## 部署

任何静态托管平台均可：
- GitHub Pages：推送后在 Settings → Pages 选择 main 分支即可
- Vercel / Netlify：导入仓库一键部署

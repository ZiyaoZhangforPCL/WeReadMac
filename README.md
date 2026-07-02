# WeReadMac

一个基于 SwiftUI + WKWebView 的 macOS 微信读书桌面客户端 MVP。

当前阶段目标：阶段 1，先实现可用的微信读书网页版 macOS 原生外壳。

## 已实现功能

- SwiftUI macOS App
- WKWebView 加载微信读书网页版：`https://weread.qq.com/`
- 使用 `WKWebsiteDataStore.default()` 持久化 Cookie / 登录态
- 顶部工具栏：后退、前进、刷新、回首页
- macOS 菜单命令：
  - `⌘ [` 后退
  - `⌘ ]` 前进
  - `⌘ R` 刷新
  - `⌘ .` 停止加载
  - `⇧ ⌘ H` 回到微信读书首页
  - `⌘ +` 放大
  - `⌘ -` 缩小
  - `⌘ 0` 实际大小
- 设置窗口：启动页面、自定义 User-Agent
- 记忆窗口尺寸和位置

## 运行方式

### 使用 Swift Package Manager 运行

```bash
swift run WeReadMac
```

### 使用 Xcode 打开

当前项目是 Swift Package 形式。如果你安装了完整 Xcode，可以：

```bash
open Package.swift
```

然后在 Xcode 里选择 `WeReadMac` target 运行。

> 当前机器只有 Command Line Tools，没有完整 Xcode，所以已用 `swift build` 验证通过，但无法在这里执行 `xcodebuild` 的完整 App 打包流程。

## 项目结构

```text
.
├── Package.swift
├── README.md
└── Sources/WeReadMac
    ├── WeReadMacApp.swift
    ├── ContentView.swift
    ├── WindowAccessor.swift
    ├── Commands
    │   └── BrowserCommands.swift
    ├── Settings
    │   ├── AppSettings.swift
    │   └── SettingsView.swift
    └── WebView
        ├── BrowserViewModel.swift
        ├── String+Blank.swift
        ├── WebView.swift
        └── WebViewCoordinator.swift
```

## 下一阶段建议

阶段 2 可以继续做：

1. 替换正式 App 图标和 Bundle 信息
2. 改成标准 Xcode `.xcodeproj` 或 `.xcworkspace`
3. 增加 App Sandbox entitlement 配置
4. 做沉浸阅读模式
5. 增加状态栏图标
6. 增加打开/隐藏全局快捷键
7. 增加独立书架入口
8. 增加错误页和网络状态提示
9. 增加 notarization / dmg 打包脚本

## 合规边界

本项目仅封装官方微信读书网页版，不逆向私有接口，不绕过登录、会员、DRM 或版权保护。

## 标准 macOS App 工程

本项目现在同时包含：

- `Package.swift`：早期 Swift Package MVP，可继续用 `swift run WeReadMac` 快速验证逻辑。
- `WeReadMac.xcodeproj`：标准 macOS App 工程，用于 Xcode 调试、签名和正式打包。

### Bundle ID

当前 Bundle Identifier：

```text
com.zhangzy.WeReadMac
```

如需修改，在 Xcode 中打开 target `WeReadMac` 的 Signing & Capabilities，修改 Bundle Identifier；或直接修改：

```text
WeReadMac.xcodeproj/project.pbxproj
```

搜索：

```text
PRODUCT_BUNDLE_IDENTIFIER = com.zhangzy.WeReadMac;
```

### Sandbox 权限

权限文件：

```text
WeReadMac/WeReadMac.entitlements
```

当前已启用：

- App Sandbox
- Outgoing Network Connections / Client

对应配置：

```xml
<key>com.apple.security.app-sandbox</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
```

### App 图标

图标资源位于：

```text
WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset
```

当前是生成的占位图标，后续可以替换成正式设计稿。

### 用 Xcode 打开

```bash
open WeReadMac.xcodeproj
```

然后选择 scheme `WeReadMac` 运行。

> 当前环境只有 Command Line Tools，没有完整 Xcode，因此本机无法执行 `xcodebuild -project ...`。你本机安装完整 Xcode 后即可使用。

### Release 构建

```bash
./scripts/build_release.sh
```

产物：

```text
dist/WeReadMac.app
```

### 生成 DMG

先执行 Release 构建，然后：

```bash
./scripts/make_dmg.sh
```

产物：

```text
dist/WeReadMac.dmg
```

### 开发者签名和公证

正式对外分发前建议：

1. 加入 Apple Developer Team
2. 使用 Developer ID Application 证书签名
3. Hardened Runtime 保持开启
4. 使用 `notarytool` 公证
5. 对 DMG 做 stapler

示例流程后续可补充为 `scripts/notarize.sh`。

## 辅助脚本

### 项目校验

```bash
./scripts/check_project.sh
```

会检查：

- 关键工程文件是否存在
- `Info.plist` / entitlements / ExportOptions 是否合法
- Xcode 工程关键配置是否存在
- AppIcon 是否包含 10 个 PNG
- SwiftPM 是否仍可编译

### 修改 Bundle ID

```bash
./scripts/set_bundle_id.sh com.example.WeReadMac
```

该脚本会修改：

```text
WeReadMac.xcodeproj/project.pbxproj
```

中的：

```text
PRODUCT_BUNDLE_IDENTIFIER
```

### 无完整 Xcode 环境下生成临时 .app

当前环境只有 Command Line Tools 时，可以用 SwiftPM 产物组装临时 App：

```bash
./scripts/package_spm_app.sh
```

产物：

```text
dist/WeReadMac.app
```

打开：

```bash
open dist/WeReadMac.app
```

注意：这个脚本主要用于本地验证，不替代正式 Xcode Archive。正式发布仍建议使用完整 Xcode 的 Release 构建、Developer ID 签名和 notarization。

### 公证模板

```bash
APPLE_ID="you@example.com" \
TEAM_ID="ABCDE12345" \
APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx" \
./scripts/notarize.sh dist/WeReadMac.dmg
```

该脚本会调用：

```bash
xcrun notarytool submit ... --wait
xcrun stapler staple ...
```

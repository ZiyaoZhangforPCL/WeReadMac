import SwiftUI

struct BrowserCommands: Commands {
    @ObservedObject var browser: BrowserViewModel

    var body: some Commands {
        CommandMenu("浏览") {
            Button("后退") { browser.goBack() }
                .keyboardShortcut("[", modifiers: [.command])
                .disabled(!browser.canGoBack)

            Button("前进") { browser.goForward() }
                .keyboardShortcut("]", modifiers: [.command])
                .disabled(!browser.canGoForward)

            Button("刷新") { browser.reload() }
                .keyboardShortcut("r", modifiers: [.command])

            Button("停止加载") { browser.stopLoading() }
                .keyboardShortcut(".", modifiers: [.command])
                .disabled(!browser.isLoading)

            Divider()

            Button("回到微信读书首页") { browser.goHome() }
                .keyboardShortcut("h", modifiers: [.command, .shift])
        }

        CommandMenu("显示") {
            Button("放大") { browser.zoomIn() }
                .keyboardShortcut("+", modifiers: [.command])

            Button("缩小") { browser.zoomOut() }
                .keyboardShortcut("-", modifiers: [.command])

            Button("实际大小") { browser.resetZoom() }
                .keyboardShortcut("0", modifiers: [.command])
        }
    }
}

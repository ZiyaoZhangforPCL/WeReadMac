import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var browser: BrowserViewModel
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        VStack(spacing: 0) {
            ToolbarView()
            Divider()
            ZStack(alignment: .top) {
                WebView(viewModel: browser, settings: settings)

                if browser.isLoading {
                    ProgressView(value: browser.estimatedProgress)
                        .progressViewStyle(.linear)
                        .frame(height: 2)
                        .transition(.opacity)
                }
            }
        }
    }
}

struct ToolbarView: View {
    @EnvironmentObject private var browser: BrowserViewModel

    var body: some View {
        HStack(spacing: 8) {
            Button {
                browser.goBack()
            } label: {
                Image(systemName: "chevron.left")
            }
            .help("后退")
            .disabled(!browser.canGoBack)

            Button {
                browser.goForward()
            } label: {
                Image(systemName: "chevron.right")
            }
            .help("前进")
            .disabled(!browser.canGoForward)

            Button {
                browser.reload()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .help("刷新")

            Button {
                browser.goHome()
            } label: {
                Image(systemName: "house")
            }
            .help("回到微信读书首页")

            Divider()
                .frame(height: 18)

            Text(browser.pageTitle.isEmpty ? "微信读书" : browser.pageTitle)
                .lineLimit(1)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            Spacer()
        }
        .buttonStyle(.borderless)
        .padding(.horizontal, 12)
        .frame(height: 38)
    }
}

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    @ObservedObject var viewModel: BrowserViewModel
    @ObservedObject var settings: AppSettings

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(viewModel: viewModel)
    }

    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.allowsAirPlayForMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = settings.userAgentOverride.nilIfBlank

        viewModel.attach(webView)
        viewModel.loadHomeIfNeeded()
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        viewModel.attach(webView)
        let userAgent = settings.userAgentOverride.nilIfBlank
        if webView.customUserAgent != userAgent {
            webView.customUserAgent = userAgent
        }
    }
}

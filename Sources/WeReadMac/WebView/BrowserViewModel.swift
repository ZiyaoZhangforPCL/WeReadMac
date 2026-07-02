import Foundation
import WebKit

@MainActor
final class BrowserViewModel: ObservableObject {
    static let homeURL = URL(string: "https://weread.qq.com/")!

    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var isLoading = false
    @Published var estimatedProgress = 0.0
    @Published var pageTitle = ""
    @Published var currentURL: URL? = BrowserViewModel.homeURL

    weak var webView: WKWebView?

    func attach(_ webView: WKWebView) {
        guard self.webView !== webView else { return }
        self.webView = webView
        updateState(from: webView)
    }

    func loadHomeIfNeeded() {
        guard let webView else { return }
        if webView.url == nil {
            webView.load(URLRequest(url: Self.homeURL))
        }
    }

    func goHome() { webView?.load(URLRequest(url: Self.homeURL)) }
    func goBack() { webView?.goBack() }
    func goForward() { webView?.goForward() }
    func reload() { webView?.reload() }
    func stopLoading() { webView?.stopLoading() }

    func zoomIn() {
        guard let webView else { return }
        webView.pageZoom = min(webView.pageZoom + 0.1, 2.0)
    }

    func zoomOut() {
        guard let webView else { return }
        webView.pageZoom = max(webView.pageZoom - 0.1, 0.6)
    }

    func resetZoom() { webView?.pageZoom = 1.0 }

    func updateState(from webView: WKWebView) {
        canGoBack = webView.canGoBack
        canGoForward = webView.canGoForward
        isLoading = webView.isLoading
        estimatedProgress = webView.estimatedProgress
        pageTitle = webView.title ?? ""
        currentURL = webView.url
    }
}

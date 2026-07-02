import Foundation

@MainActor
final class AppSettings: ObservableObject {
    @Published var launchURLString: String {
        didSet { UserDefaults.standard.set(launchURLString, forKey: Keys.launchURLString) }
    }

    @Published var userAgentOverride: String {
        didSet { UserDefaults.standard.set(userAgentOverride, forKey: Keys.userAgentOverride) }
    }

    @Published var windowWidth: Double {
        didSet { UserDefaults.standard.set(windowWidth, forKey: Keys.windowWidth) }
    }

    @Published var windowHeight: Double {
        didSet { UserDefaults.standard.set(windowHeight, forKey: Keys.windowHeight) }
    }

    @Published var windowX: Double {
        didSet { UserDefaults.standard.set(windowX, forKey: Keys.windowX) }
    }

    @Published var windowY: Double {
        didSet { UserDefaults.standard.set(windowY, forKey: Keys.windowY) }
    }

    enum Keys {
        static let launchURLString = "launchURLString"
        static let userAgentOverride = "userAgentOverride"
        static let windowWidth = "windowWidth"
        static let windowHeight = "windowHeight"
        static let windowX = "windowX"
        static let windowY = "windowY"
    }

    init() {
        let defaults = UserDefaults.standard
        self.launchURLString = defaults.string(forKey: Keys.launchURLString) ?? "https://weread.qq.com/"
        self.userAgentOverride = defaults.string(forKey: Keys.userAgentOverride) ?? ""

        let storedWidth = defaults.double(forKey: Keys.windowWidth)
        let storedHeight = defaults.double(forKey: Keys.windowHeight)
        let storedX = defaults.double(forKey: Keys.windowX)
        let storedY = defaults.double(forKey: Keys.windowY)

        self.windowWidth = storedWidth > 0 ? storedWidth : 1100
        self.windowHeight = storedHeight > 0 ? storedHeight : 760
        self.windowX = storedX
        self.windowY = storedY
    }
}

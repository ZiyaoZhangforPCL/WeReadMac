import SwiftUI

@main
struct WeReadMacApp: App {
    @StateObject private var browser = BrowserViewModel()
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(browser)
                .environmentObject(settings)
                .frame(minWidth: 900, minHeight: 640)
                .background(WindowAccessor(settings: settings))
        }
        .commands {
            BrowserCommands(browser: browser)
        }

        Settings {
            SettingsView()
                .environmentObject(settings)
                .frame(width: 440)
                .padding()
        }
    }
}

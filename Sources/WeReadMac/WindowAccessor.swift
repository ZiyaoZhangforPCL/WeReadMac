import SwiftUI
import AppKit

struct WindowAccessor: NSViewRepresentable {
    @ObservedObject var settings: AppSettings

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            context.coordinator.configure(window)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(settings: settings)
    }

    @MainActor
    final class Coordinator: NSObject, NSWindowDelegate {
        private let settings: AppSettings

        init(settings: AppSettings) {
            self.settings = settings
        }

        @MainActor
        func configure(_ window: NSWindow) {
            window.title = "微信读书"
            window.titleVisibility = .visible
            window.tabbingMode = .preferred
            window.delegate = self

            let savedSize = NSSize(width: settings.windowWidth, height: settings.windowHeight)
            var frame = window.frame
            frame.size = savedSize

            if settings.windowX != 0 || settings.windowY != 0 {
                frame.origin = NSPoint(x: settings.windowX, y: settings.windowY)
                window.setFrame(frame, display: true)
            } else {
                window.setContentSize(savedSize)
                window.center()
            }
        }

        func windowDidResize(_ notification: Notification) {
            saveFrame(notification)
        }

        func windowDidMove(_ notification: Notification) {
            saveFrame(notification)
        }

        private func saveFrame(_ notification: Notification) {
            guard let window = notification.object as? NSWindow else { return }
            settings.windowWidth = window.frame.width
            settings.windowHeight = window.frame.height
            settings.windowX = window.frame.origin.x
            settings.windowY = window.frame.origin.y
        }
    }
}

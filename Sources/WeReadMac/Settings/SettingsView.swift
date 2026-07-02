import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        Form {
            Section("启动") {
                TextField("启动页面", text: $settings.launchURLString)
                    .textFieldStyle(.roundedBorder)
                Text("默认建议保持 https://weread.qq.com/")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("高级") {
                TextField("自定义 User-Agent，可留空", text: $settings.userAgentOverride, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...4)
                Text("大多数情况下无需设置。若网页版识别异常，再尝试覆盖。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

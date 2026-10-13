import SwiftUI

struct MenuContent: View {
    @ObservedObject var controller: SleepController
    @AppStorage(AppUpdater.checksAutomaticallyKey) private var checksForUpdatesAutomatically = true

    var body: some View {
        Toggle("Keep Awake (When Lid Is Open)", isOn: Binding(
            get: { controller.keepAwake },
            set: { controller.setKeepAwake($0) }
        ))

        Picker("When Lid Is Closed", selection: Binding(
            get: { controller.lidMenuChoice },
            set: { controller.setLidMenuChoice($0) }
        )) {
            Text("Off").tag(LidMenuChoice.off)
            Text("Keep Awake but Lock the Screen").tag(LidMenuChoice.lock)
            Text("Keep Awake and Keep Screen Unlocked").tag(LidMenuChoice.keepUnlocked)
        }
        .pickerStyle(.inline)

        Divider()

        Toggle("Auto-off at 20% Battery", isOn: Binding(
            get: { controller.autoOff },
            set: { controller.setAutoOff($0) }
        ))

        Toggle("Launch at Login", isOn: Binding(
            get: { controller.launchAtLogin },
            set: { controller.setLaunchAtLogin($0) }
        ))

        Divider()

        Text(controller.statusText)

        Divider()

        Text(versionLine)

        Toggle("Check for updates automatically", isOn: $checksForUpdatesAutomatically)

        Button("Check for Updates…") {
            AppUpdater.check(manual: true)
        }

        SettingsLink { Text("Settings…") }.keyboardShortcut(",")

        Button("Quit Amped") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }

    private var versionLine: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
        return version.hasSuffix("-local") ? "Amped \(version) — LOCAL BUILD" : "Amped \(version)"
    }
}

import SwiftUI

struct SleepSettings: View {
    @ObservedObject var controller: SleepController

    var body: some View {
        Form {
            Section {
                Toggle("Keep awake (when lid is open)", isOn: Binding(
                    get: { controller.keepAwake },
                    set: { controller.setKeepAwake($0) }
                ))
            } footer: {
                Text("Stops your Mac from sleeping when idle while the lid is open. Always off when Amped starts, and released when it quits.")
            }

            Section {
                Picker("When lid is closed", selection: Binding(
                    get: { controller.lidMenuChoice },
                    set: { controller.setLidMenuChoice($0) }
                )) {
                    Text("Off").tag(LidMenuChoice.off)
                    Text("Keep awake but lock the screen").tag(LidMenuChoice.lock)
                    Text("Keep awake and keep screen unlocked").tag(LidMenuChoice.keepUnlocked)
                }
                .pickerStyle(.radioGroup)
            } footer: {
                Text("Off lets the Mac sleep when you close the lid. Keep awake but lock the screen keeps it running, then locks and turns the display off unless an external display is connected. Keep awake and keep screen unlocked keeps it running with the desktop available and the built-in backlight off, so anyone who opens the lid can use the Mac without a password. Keeping it running changes a system power setting, needs Amped’s helper or an administrator password, and Amped turns it back off when it quits.")
            }

            Section {
                Toggle("Auto-off at 20% battery", isOn: Binding(
                    get: { controller.autoOff },
                    set: { controller.setAutoOff($0) }
                ))
            } footer: {
                Text("Turns off keep awake and lid-closed mode when your Mac is on battery power at 20% or less, so it can still sleep before the battery runs out.")
            }
        }
        .formStyle(.grouped)
        .frame(height: 520)
    }
}

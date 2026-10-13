import SwiftUI

struct MenuBarLabel: View {
    @ObservedObject var controller: SleepController

    // MenuBarExtra drops .symbolRenderingMode; a hierarchical NSImage configuration survives.
    private static let dimmedPills = NSImage(systemSymbolName: "pills.fill", accessibilityDescription: nil)!
        .withSymbolConfiguration(.preferringHierarchical())!

    var body: some View {
        if controller.lidClosed && !controller.keepAwake && controller.lidCloseAction == .lock {
            Image(nsImage: Self.dimmedPills)
        } else {
            Image(systemName: controller.menuBarSymbolName)
        }
    }
}

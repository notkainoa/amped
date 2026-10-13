import CoreGraphics
import Darwin

// DisplayServices is private, and the public IOKit brightness calls fail on Apple Silicon.
// Loaded from the logged-in app so the panel can go dark while the desktop keeps drawing.
final class Backlight {
    private typealias GetFn = @convention(c) (CGDirectDisplayID, UnsafeMutablePointer<Float>) -> Int32
    private typealias SetFn = @convention(c) (CGDirectDisplayID, Float) -> Int32

    private var saved: Float?
    private let getBrightness: GetFn?
    private let setBrightness: SetFn?

    init() {
        let path = "/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices"
        guard let handle = dlopen(path, RTLD_LAZY) else {
            getBrightness = nil
            setBrightness = nil
            return
        }
        getBrightness = dlsym(handle, "DisplayServicesGetBrightness").map { unsafeBitCast($0, to: GetFn.self) }
        setBrightness = dlsym(handle, "DisplayServicesSetBrightness").map { unsafeBitCast($0, to: SetFn.self) }
    }

    func dimBuiltin() {
        guard saved == nil, let display = builtinDisplay(), let getBrightness, let setBrightness else { return }
        var current: Float = -1
        _ = getBrightness(display, &current)
        guard (0...1).contains(current) else { return }
        guard setBrightness(display, 0) == 0 else { return }
        saved = current
    }

    func restore() {
        guard let saved, let display = builtinDisplay(), let setBrightness else {
            self.saved = nil
            return
        }
        _ = setBrightness(display, saved)
        self.saved = nil
    }

    private func builtinDisplay() -> CGDirectDisplayID? {
        var count: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &count)
        guard count > 0 else { return nil }
        var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
        CGGetActiveDisplayList(count, &displays, &count)
        return displays.prefix(Int(count)).first { CGDisplayIsBuiltin($0) != 0 }
    }
}

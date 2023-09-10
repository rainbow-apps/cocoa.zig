const std = @import("std");
const cocoa = @import("main.zig");

pub fn main() !void {
    var window = cocoa.NSWindow.alloc();
    window = window.autorelease();
    defer window.deinit();
    const mask: cocoa.NSWindow.StyleMask = .{
        .titled = true,
        .closable = true,
        .resizable = true,
        .miniaturizable = true,
        .fullscreen = false,
        .fullsize_content_view = true,
    };
    window.initWithContentRect(
        cocoa.NSRect.make(100, 100, 300, 300),
        mask,
        .Buffered,
        false,
    );
    window.setIsVisible(true);
    const s = struct {
        const NSApp = cocoa.NSApplication.sharedApplication();
        pub fn wait_and_quit() void {
            std.time.sleep(std.time.ns_per_s);
            NSApp.terminate(null);
        }
    };
    const t = try std.Thread.spawn(.{}, s.wait_and_quit, .{});
    t.detach();
    s.NSApp.run();
}

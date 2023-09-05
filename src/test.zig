const std = @import("std");
const cocoa = @import("main.zig");

pub fn main() !void {
    var window = cocoa.NSWindow.alloc();
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
    var NSApp = cocoa.NSApplication.sharedApplication();
    NSApp.run();
}

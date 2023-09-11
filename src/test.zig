const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");

pub fn main() !void {
    var window = cocoa.NSWindow.alloc();
    window = window.autorelease();
    const mask: cocoa.NSWindow.StyleMask = .{
        .titled = true,
        .closable = true,
        .resizable = true,
        .miniaturizable = true,
        .fullscreen = false,
        .fullsize_content_view = true,
    };
    window = window.initWithContentRect(
        cocoa.NSRect.make(100, 100, 1200, 1000),
        mask,
        .Buffered,
        false,
    );
    webview_setup(window);
    const NSApp = cocoa.NSApplication.sharedApplication();
    const s = struct {
        pub fn wait_and_quit() void {
            std.time.sleep(30 * std.time.ns_per_s);
            cocoa.NSApplication.sharedApplication().terminate(null);
        }
    };
    const t = try std.Thread.spawn(.{}, s.wait_and_quit, .{});
    t.detach();
    NSApp.run();
}

fn webview_setup(window: cocoa.NSWindow) void {
    var webview = cocoa.WKWebView.new().initWithFrame(cocoa.NSRect.make(100, 100, 1000, 900));
    var urlstring: [:0]const u8 = "https://www.google.com/";
    var string = cocoa.NSString.alloc().initWithCStringEncoding(urlstring, .ASCII).?;
    const str_desc = string.getDescription();
    std.debug.print("{s}\n", .{str_desc.UTF8String()});
    var url = cocoa.NSURL.alloc().initWithString(string).?;
    const request = cocoa.NSURLRequest.requestWithURL(url);
    window.setContentView(cocoa.NSView.fromObject(webview.object));
    _ = webview.loadRequest(request);
    window.setIsVisible(true);
}

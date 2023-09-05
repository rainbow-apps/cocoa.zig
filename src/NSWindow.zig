const std = @import("std");
const cocoa = @import("main.zig");
const objc = @import("zig-objc");

const Window = @This();

object: objc.Object,

pub const StyleMask = packed struct {
    titled: bool,
    closable: bool,
    miniaturizable: bool,
    resizable: bool,
    utility_window: bool = false,
    _unused_1: bool = false,
    doc_modal_window: bool = false,
    nonactivating_panel: bool = false,
    _unused_2: u4 = 0,
    unified_title_and_toolbar: bool = false,
    hud_window: bool = false,
    fullscreen: bool,
    fullsize_content_view: bool,
    _padding: u48 = 0,

    comptime {
        std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
        std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
    }
};

pub const BackingStore = enum(u64) {
    Retained = 0,
    Nonretained = 1,
    Buffered = 2,
};

pub fn alloc() Window {
    var NSWindow = objc.Class("NSWindow").?;
    return .{
        .object = NSWindow.message(objc.Object, "alloc", .{}),
    };
}

pub fn initWithContentRect(
    self: Window,
    content: cocoa.NSRect,
    style: StyleMask,
    backing: BackingStore,
    deferred: bool,
) void {
    _ = self.object.message(objc.Object, "initWithContentRect", .{
        content,
        style,
        backing,
        if (deferred) @as(u8, 1) else @as(u8, 0),
    });
}

pub fn setIsVisible(self: Window, visible: bool) void {
    self.object.message(void, "setIsVisible", .{if (visible) @as(u8, 1) else @as(u8, 0)});
}

pub fn deinit(self: Window) void {
    self.object.message(void, "dealloc", .{});
}

test "init" {
    var window = alloc();
    defer window.deinit();
    const mask: StyleMask = .{
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
}

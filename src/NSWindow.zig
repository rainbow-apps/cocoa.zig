const std = @import("std");
const cocoa = @import("main.zig");
const objc = @import("zig-objc");
const object = @import("NSObject.zig");

pub const NSWindow = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSWindow").?;
    }

    pub usingnamespace object.NSObject(@This(), true);

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

    pub const CollectionBehavior = packed struct {
        can_join_all_spaces: bool,
        move_to_active_Space: bool,
        managed: bool,
        transient: bool,
        stationary: bool,
        participates_in_cycle: bool,
        ignores_cycle: bool,
        fullscreen_primary: bool,
        fullscreen_auxiliary: bool,
        fullscreen_none: bool,
        _unused: bool = false,
        fullscreen_allows_tiling: bool,
        fullscreen_disallows_tiling: bool,
        _unused_2: u3 = 0,
        behavior_primary: bool,
        behavior_auxiliary: bool,
        can_join_all_applications: bool,
        _padding: u46 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    pub const NumberListOptions = packed struct {
        all_applications: bool,
        _unused: u3 = 0,
        all_space: bool,
        _padding: u60 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    pub const OcclusionState = packed struct {
        _unused: bool = 0,
        visible: bool,
        _padding: u62 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    pub const BackingStore = enum(c_uint) {
        Retained = 0,
        Nonretained = 1,
        Buffered = 2,
    };

    pub const SharingType = enum(c_uint) {
        None = 0,
        ReadOnly = 1,
        ReadWrite = 2,
    };

    pub const AnimationBehavior = enum(c_int) {
        Default = 0,
        None = 2,
        DocumentWindow = 3,
        UtilityWindow = 4,
        AlertPanel = 5,
    };

    pub const SelectionDirection = enum(c_uint) {
        DirectSelection = 0,
        Next,
        Previous,
    };

    pub const Button = enum(c_uint) {
        CloseButton,
        MiniaturizeButton,
        ZoomButton,
        ToolbarButton,
        DocumentIconButton,
        DocumentVerionButton,
    };

    pub const TitleVisibility = enum(c_int) {
        Visible = 0,
        Hidden = 1,
    };

    pub const ToolbarStyle = enum(c_int) {
        Automatic,
        Expanded,
        Preference,
        Unified,
        UnifiedCompact,
    };

    pub const TabbingPreference = enum(c_int) {
        Manual,
        Always,
        InFullScreen,
    };

    pub const TabbingMode = enum(c_int) {
        Automatic,
        Preferred,
        Disallowed,
    };

    pub const TitlebarSeparatorStyle = enum(c_int) {
        Automatic,
        None,
        Line,
        Shadow,
    };

    pub fn deinit(self: NSWindow) void {
        self.object.message(void, "dealloc", .{});
    }

    pub fn initWithContentRect(
        self: *NSWindow,
        content: cocoa.NSRect,
        style: StyleMask,
        backing: BackingStore,
        deferred: bool,
    ) void {
        self.object = self.object.message(
            objc.Object,
            "initWithContentRect:styleMask:backing:defer:",
            .{
                content,
                style,
                backing,
                if (deferred) @as(u8, 1) else @as(u8, 0),
            },
        );
    }

    pub fn setIsVisible(self: NSWindow, visible: bool) void {
        self.object.message(void, "setIsVisible:", .{if (visible) @as(u8, 1) else @as(u8, 0)});
    }

    pub fn setContentView(self: NSWindow, contentView: cocoa.NSView) void {
        self.object.message(void, "setContentView:", .{&contentView.object});
    }

    pub fn fromObject(self: objc.Object) NSWindow {
        return .{
            .object = self,
        };
    }
};

test "init" {
    var window = NSWindow.alloc();
    defer window.deinit();
    const mask: NSWindow.StyleMask = .{
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
    const stop = struct {
        pub fn wait_and_quit() void {
            std.time.sleep(std.time.ns_per_s);
            const nsapp = cocoa.NSApplication.sharedApplication();
            nsapp.terminate(null);
        }
    };
    const t = try std.Thread.spawn(.{}, stop.wait_and_quit, .{});
    t.detach();
    NSApp.run();
}

const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");
const object = @import("NSObject.zig");

pub const NSAutoresizingMaskOptions = packed struct {
    min_xmargin: bool = false,
    width_sizable: bool = false,
    max_xmargin: bool = false,
    min_ymargin: bool = false,
    height_sizable: bool = false,
    max_ymargin: bool = false,
    _padding: u58 = 0,

    comptime {
        std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
        std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
    }
};

pub const NSBorderType = enum(u64) {
    NoBorder = 0,
    LineBorder = 1,
    BezelBorder = 2,
    GrooveBorder = 3,
};

pub const NSView = struct {
    pub const LayerContentsRedrawPolicy = enum(c_long) {
        Never = 0,
        OnSetNeedsDisplay = 1,
        DuringViewResize = 2,
        BeforeViewResize = 3,
        Crossfade = 4,
    };

    pub const LayerContentsPlacement = enum(c_long) {
        ScaleAxesIndependently = 0,
        ScaleProportionallyToFit = 1,
        ScaleProportionallyToFill = 2,
        Center = 3,
        Top = 4,
        TopRight = 5,
        Right = 6,
        BottomRight = 7,
        Bottom = 8,
        BottomLeft = 9,
        Left = 10,
        TopLeft = 11,
    };

    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSView").?;
    }

    pub fn fromObject(self: objc.Object) @This() {
        return .{
            .object = self,
        };
    }

    pub usingnamespace extends(@This(), true);

    pub fn extends(comptime T: type, comptime should_assert: bool) type {
        comptime if (should_assert) {
            object.assert_structure(T);
        };
        return struct {
            pub usingnamespace object.NSObject(T, false);
            pub fn initWithFrame(self: T, frame: cocoa.NSRect) T {
                return T.fromObject(self.object.message(objc.Object, "initWithFrame:", .{frame}));
            }

            pub fn initWithCoder(self: T, coder: cocoa.NSCoder) ?T {
                const ret = self.object.message(?objc.c.id, "initWithCoder:", .{coder.object.value});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn getWindow(self: T) ?cocoa.NSWindow {
                const ret = self.object.getProperty(?objc.c.id, "window");
                return cocoa.NSWindow.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn getSuperview(self: T) ?NSView {
                const ret = self.object.getProperty(?objc.c.id, "superview");
                return NSView.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn isDescendantOf(self: T, other: NSView) bool {
                return if (self.object.message(u8, "isDescendantOf:", .{other}) == 1) true else false;
            }

            pub fn ancestorSharedWithView(self: T, other: NSView) ?NSView {
                const ret = self.object.message(?objc.c.id, "ancestorSharedWithView:", .{other.object.value});
                return NSView.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn opaqueAncestor(self: T) ?NSView {
                const ret = self.object.getProperty(?objc.c.id, "opaqueAncestor");
                return NSView.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn isHidden(self: T) bool {
                return if (self.object.message(u8, "isHidden", .{}) == 1) true else false;
            }

            pub fn isHiddenOrHasHiddenAncestor(self: T) bool {
                return if (self.object.message(u8, "isHiddenOrHasHiddenAncestor", .{}) == 1) true else false;
            }

            pub fn setHidden(self: T, val: bool) void {
                self.object.setProperty(u8, "hidden", .{val});
            }

            pub fn addSubview(self: T, other: NSView) void {
                self.object.message(void, "addSubview:", .{other.object.value});
            }
        };
    }
};

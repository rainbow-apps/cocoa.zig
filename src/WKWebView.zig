const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");
const object = @import("NSObject.zig");

pub const WKWebView = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("WKWebView").?;
    }
    pub fn fromObject(self: objc.Object) @This() {
        return .{
            .object = self,
        };
    }

    pub usingnamespace extends(@This(), true);

    pub fn extends(comptime T: type, comptime should_assert: bool) type {
        if (should_assert) {
            object.assert_structure(T);
        }
        return struct {
            pub usingnamespace cocoa.NSView.extends(T, false);

            pub fn initWithFrameConfiguration(self: T, frame: cocoa.NSRect, configuration: WKWebViewConfiguration) T {
                return T.fromObject(self.object.message(objc.Object, "initWithFrame:configuration:", .{ frame, configuration.object.value }));
            }

            pub fn loadRequest(self: T, request: cocoa.NSURLRequest) ?WKNavigation {
                const ret = self.object.message(?objc.c.id, "loadRequest:", .{request.object.value});
                return WKNavigation.fromObject(.{
                    .value = ret orelse return null,
                });
            }
        };
    }
};

pub const WKWebViewConfiguration = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("WKWebViewConfiguration").?;
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
            pub usingnamespace object.NSObject(@This(), false);
            pub usingnamespace object.NSSecureCoding(@This(), false);
            pub usingnamespace object.NSCopying(@This(), false);
        };
    }
};

pub const WKNavigation = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("WKNavigation").?;
    }
    pub fn fromObject(self: objc.Object) @This() {
        return .{
            .object = self,
        };
    }

    pub fn extends(comptime T: type, comptime should_assert: bool) type {
        comptime if (should_assert) {
            object.assert_structure(T);
        };
        return struct {
            pub usingnamespace object.NSObject(@This(), false);

            pub fn effectiveContentMode(self: T) WKContentMode {
                return @enumFromInt(self.object.getProperty(c_long, "effectiveContentMode"));
            }
        };
    }
};

pub const WKContentMode = enum(c_long) {
    Recommended,
    Mobile,
    Desktop,
};

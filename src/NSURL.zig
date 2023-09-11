const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");
const object = @import("NSObject.zig");

pub const NSURL = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSURL").?;
    }
    pub fn fromObject(self: objc.Object) NSURL {
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
            pub usingnamespace object.NSSecureCoding(T, false);
            pub usingnamespace object.NSCopying(T, false);
            pub usingnamespace object.NSObject(T, false);

            pub fn initWithString(self: T, string: cocoa.NSString) ?T {
                const ret = self.object.message(objc.c.id, "initWithString:", .{string.object.value});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }
            pub fn initWithStringRelativeToURL(self: T, string: cocoa.NSString, base: ?NSURL) ?T {
                const ret = self.object.message(objc.c.id, "initWithString:relativeToURL:", .{ string.object.value, if (base) |b| b.object.value else null });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn URLWithString(string: cocoa.NSString) ?T {
                const ret = T.class().message(objc.c.id, "URLWithString:", .{string.object.value});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn URLWithStringRelativeToURL(string: cocoa.NSString, base: ?NSURL) ?T {
                const ret = T.class().message(objc.c.id, "URLWithString:relativeToURL:", .{ string.object.value, if (base) |b| b.object.value else null });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }
        };
    }
};

pub const NSURLRequest = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSURLRequest").?;
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
            pub usingnamespace object.NSObject(T, false);
            pub usingnamespace object.NSSecureCoding(T, false);
            pub usingnamespace object.NSMutableCopying(T, false);
            pub usingnamespace object.NSCopying(T, false);

            pub fn requestWithURL(url: NSURL) T {
                return T.fromObject(T.class().message(objc.Object, "requestWithURL:", .{url.object.value}));
            }

            pub fn initWithURL(self: T, url: NSURL) T {
                return T.fromObject(self.object.message(objc.Object, "initWithURL:", .{url.object.value}));
            }

            pub fn URL(self: T) NSURL {
                return NSURL.fromObject(self.object.getProperty(objc.Object, "URL"));
            }
        };
    }
};

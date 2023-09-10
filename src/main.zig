const std = @import("std");

const objc = @import("zig-objc");
const object = @import("NSObject.zig");

pub const NSObject = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSObject").?;
    }

    pub fn fromObject(self: objc.Object) @This() {
        return .{
            .object = self,
        };
    }

    pub usingnamespace object.NSObject(@This(), true);
};

pub usingnamespace @import("NSString.zig");
pub usingnamespace @import("NSRange.zig");
pub usingnamespace @import("NSGeometry.zig");
pub usingnamespace @import("NSWindow.zig");
pub const NSApplication = @import("NSApplication.zig");
pub usingnamespace @import("NSCoder.zig");
pub usingnamespace @import("NSError.zig");
pub usingnamespace @import("NSURL.zig");

pub const NSComparisonResult = enum(c_int) {
    Ascending = -1,
    Same = 0,
    Descending = 1,
};

test {
    std.testing.refAllDecls(@This());
}

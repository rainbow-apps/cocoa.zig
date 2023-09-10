const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");
const object = @import("NSObject.zig");

pub const NSError = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSError").?;
    }
    pub fn fromObject(self: objc.Object) NSError {
        return .{
            .object = self,
        };
    }

    pub const Domain = cocoa.NSString;
    pub const UserInfoKey = cocoa.NSString;

    pub usingnamespace extends(@This(), true);

    pub fn extends(comptime T: type, comptime should_assert: bool) type {
        comptime if (should_assert) {
            object.assert_structure(T);
        };
        return struct {};
    }
};

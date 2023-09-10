const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");
const object = @import("NSObject.zig");

pub const NSApplication = @This();

object: objc.Object,
pub fn class() objc.Class {
    return objc.getClass("NSApplication").?;
}

pub fn fromObject(self: objc.Object) @This() {
    return .{
        .object = self,
    };
}

pub usingnamespace object.NSObject(NSApplication, true);

pub fn sharedApplication() NSApplication {
    return .{
        .object = objc.getClass("NSApplication").?.message(objc.Object, "sharedApplication", .{}),
    };
}

pub fn run(self: NSApplication) void {
    self.object.message(void, "run", .{});
}

pub fn terminate(self: NSApplication, sender: ?objc.Object) void {
    self.object.message(void, "terminate:", .{if (sender) |s| s.value else null});
}

const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");

pub const NSApplication = @This();

object: objc.Object,

pub fn sharedApplication() NSApplication {
    return .{
        .object = objc.Class("NSApplication").message(objc.Object, "sharedApplication", .{}),
    };
}

pub fn run(self: NSApplication) void {
    self.object.message(void, "run", .{});
}

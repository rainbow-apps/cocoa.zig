const std = @import("std");

// pub const c = @import("c.zig");
pub usingnamespace @import("NSGeometry.zig");
pub const NSWindow = @import("NSWindow.zig");
pub usingnamespace @import("NSApplication.zig");

test {
    std.testing.refAllDecls(@This());
}

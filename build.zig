const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zig_objc = b.dependency("zig_objc", .{
        .target = target,
        .optimize = optimize,
    });
    _ = b.addModule("cocoa", .{
        .source_file = .{ .path = "src/cocoa.zig" },
        .dependencies = &.{
            .{
                .name = "zig-objc",
                .module = zig_objc.module("objc"),
            },
        },
    });
}

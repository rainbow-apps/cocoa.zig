const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tests = b.addTest(.{
        .name = "cocoa-test",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    const zig_objc = b.dependency("zig_objc", .{
        .target = target,
        .optimize = optimize,
    });
    _ = b.addModule("cocoa", .{
        .source_file = .{ .path = "src/main.zig" },
        .dependencies = &.{
            .{
                .name = "zig-objc",
                .module = zig_objc.module("objc"),
            },
        },
    });

    tests.addModule("zig-objc", zig_objc.module("objc"));
    tests.linkSystemLibrary("objc");
    tests.linkFramework("Cocoa");
    b.installArtifact(tests);

    const test_step = b.step("test", "Run tests");
    const tests_run = b.addRunArtifact(tests);
    test_step.dependOn(&tests_run.step);

    const exe = b.addExecutable(.{
        .name = "example-window",
        .root_source_file = .{ .path = "src/test.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addModule("zig-objc", zig_objc.module("objc"));
    exe.linkSystemLibrary("objc");
    exe.linkFramework("Cocoa");
    b.installArtifact(exe);

    const example_step = b.step("example", "Run example");
    const example_run = b.addRunArtifact(exe);
    example_step.dependOn(&example_run.step);
}

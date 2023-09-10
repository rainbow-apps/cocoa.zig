const std = @import("std");
const objc = @import("zig-objc");
const object = @import("NSObject.zig");
const cocoa = @import("main.zig");

pub const NSMutableData = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSMutableData").?;
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
            pub usingnamespace NSData.extends(T, false);

            pub fn length(self: T) u64 {
                return self.object.getProperty(u64, "length");
            }

            pub fn mutableBytes(self: T) [*]u8 {
                return self.object.getProperty([*]u8, "mutableBytes");
            }

            pub fn appendBytes(self: T, bytes: []const u8) void {
                self.object.message(void, "appendBytes:length", .{ bytes.ptr, @as(u64, bytes.len) });
            }

            pub fn appendData(self: T, other: NSData) void {
                self.object.message(void, "appendData:", .{other.object.value});
            }

            pub fn increaseLengthBy(self: T, extra_length: u64) void {
                self.object.message(void, "increaseLengthBy:", .{extra_length});
            }

            pub fn replaceBytesInRangeWithBytes(self: T, range: cocoa.NSRange, bytes: []const u8) void {
                std.debug.assert(bytes.len >= range.length);
                self.object.message(void, "replaseBytesInRange:withBytes:", .{ range, bytes.ptr });
            }

            pub fn resetBytesInRange(self: T, range: cocoa.NSRange) void {
                self.object.message(void, "resetBytesInRange:", .{range});
            }

            pub fn setData(self: T, other: NSData) void {
                self.object.message(void, "setData:", .{other.object.value});
            }

            pub fn dataWithCapacity(capacity: u64) ?T {
                const ret = T.class().message(?objc.c.id, "dataWithCapacity:", .{capacity});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn dataWithLength(length: u64) ?T {
                const ret = T.class().message(?objc.c.id, "dataWithLength:", .{length});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn initWithCapacity(self: T, capacity: u64) ?T {
                const ret = self.object.message(?objc.c.id, "initWithCapacity:", .{capacity});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn initWithLength(self: T, length: u64) ?T {
                const ret = self.object.message(?objc.c.id, "initWithLength:", .{length});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn decompressUsingAlgorithmError(self: T, algorithm: NSData.CompressionAlgorithm, err: *cocoa.NSError) bool {
                const ret = self.object.message(u8, "decompressUsingAlgorithm:error:", .{ algorithm, &err.object.value });
                err.* = cocoa.NSError.fromObject(.{
                    .value = err.object.value,
                });
                return if (ret == 1) true else false;
            }

            pub fn compressUsingAlgorithmError(self: T, algorithm: NSData.CompressionAlgorithm, err: *cocoa.NSError) bool {
                const ret = self.object.message(u8, "compressUsingAlgorithm:error:", .{ algorithm, &err.object.value });
                err.* = cocoa.NSError.fromObject(.{
                    .value = err.object.value,
                });
                return if (ret == 1) true else false;
            }
        };
    }
};

pub const NSPurgeableData = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSPurgeableData").?;
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
            pub usingnamespace NSMutableData.extends(T, false);
            pub usingnamespace object.NSDiscardableContent(T, false);
        };
    }
};

pub const NSData = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSData").?;
    }
    pub fn fromObject(self: objc.Object) @This() {
        return .{
            .object = self,
        };
    }

    pub usingnamespace extends(@This(), true);

    pub const ReadingOptions = packed struct {
        mapped_if_safe: bool,
        uncached: bool,
        _unused: u1 = 0,
        mapped_always: bool,
        _padding: u61 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    pub const WritingOptions = enum(u64) {
        Atomic = 1,
        WithoutOverwriting = 2,
        ProtectionNome = 0x10000000,
        ProtectionComplete = 0x20000000,
        ProtectionCompleteUnlessOpen = 0x30000000,
        ProtectionCompleteUntilFirstUserAuthentication = 0x40000000,
        ProtectionMask = 0xf0000000,
    };

    pub const CompressionAlgorithm = enum(i64) {
        LZFSE = 0,
        LZ4,
        LZMA,
        Zlib,
    };

    pub const SearchOptions = packed struct {
        backwards: bool,
        anchored: bool,
        _padding: u62 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    pub const Base64EncodingOptions = packed struct {
        line_length_64_characters: bool,
        line_length_76_characters: bool, // at most one of the two should be active
        _unused: u2 = 0,
        end_line_with_carriage_return: bool = true,
        end_line_with_line_feed: bool = true,
        _padding: u59 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    pub const Base64DecodingOptions = packed struct {
        ignore_unknown_characters: bool,
        padding: u63 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    pub fn extends(comptime T: type, comptime should_assert: bool) type {
        comptime if (should_assert) {
            object.assert_structure(T);
        };
        return struct {
            pub usingnamespace object.NSObject(T, false);
            pub usingnamespace object.NSCopying(T, false);
            pub usingnamespace object.NSMutableCopying(T, false);
            pub usingnamespace object.NSSecureCoding(T, false);

            pub fn length(self: T) u64 {
                return self.object.getProperty(u64, "length");
            }

            pub fn bytes(self: T) ?[*]u8 {
                var ret = self.object.getProperty(?*anyopaque, "bytes");
                if (ret) |r| {
                    return @ptrCast(@alignCast(r));
                } else {
                    return null;
                }
            }

            pub fn getBytes(self: T, buffer: []u8) void {
                self.object.message(void, "getBytes:length:", .{ buffer.ptr, @as(u64, buffer.len) });
            }

            pub fn getBytesRange(self: T, buffer: []u8, range: cocoa.NSRange) void {
                std.debug.assert(buffer.len >= range.length);
                self.object.message(void, "getBytes:range:", .{ buffer.ptr, range });
            }

            pub fn isEqualToData(self: T, other: NSData) bool {
                return if (self.object.message(u8, "isEqualToData:", .{other.object.value}) == 1) true else false;
            }

            pub fn subdataWithRange(self: T, range: cocoa.NSRange) NSData {
                return NSData.fromObject(self.object.message(objc.Object, "subdataWithRange:", .{range}));
            }

            pub fn writeToFileAtomically(self: T, path: cocoa.NSString, atomically: bool) bool {
                const atom: u8 = if (atomically) 1 else 0;
                return if (self.object.message(u8, "writeToFile:atomically:", .{ path.object.value, atom }) == 1) true else false;
            }

            pub fn writeToURLAtomically(self: T, url: cocoa.NSURL, atomically: bool) bool {
                const atom: u8 = if (atomically) 1 else 0;
                return if (self.object.message(u8, "writeToURL:atomically:", .{ url.object.value, atom }) == 1) true else false;
            }

            // sigh, wasn't able to get this into a packed struct
            pub fn writeToFileOptionsError(self: T, path: cocoa.NSString, mask: u64, err: *cocoa.NSError) bool {
                const ret = self.object.message(u8, "writeToFile:options:error:", .{ path.object.value, mask, &err.object.value });
                err = cocoa.NSError.fromObject(.{ .value = err.object.value });
                return if (ret == 1) true else false;
            }

            pub fn writeToURLOptionsError(self: T, url: cocoa.NSURL, mask: u64, err: *cocoa.NSError) bool {
                const ret = self.object.message(u8, "writeToURL:options:error:", .{ url.object.value, mask, &err.object.value });
                err = cocoa.NSError.fromObject(.{ .value = err.object.value });
                return if (ret == 1) true else false;
            }

            pub fn rangeOfDataOptionsRange(haystack: T, needle: NSData, mask: SearchOptions, range: cocoa.NSRange) cocoa.NSRange {
                return haystack.object.message(cocoa.NSRange, "rangeOfData:options:range:", .{ needle.object.value, mask, range });
            }

            pub fn enumerateBytesRangeUsingBlock(
                self: T,
                block: *const fn (bytes: ?*anyopaque, range: cocoa.NSRange, stop: *u8) callconv(.C) void,
            ) void {
                self.object.message(void, "enumerateByteRangesUsingBlock:", .{block});
            }

            pub fn data() T {
                return T.fromObject(T.class().message(objc.Class, "data", .{}));
            }

            pub fn dataWithBytes(b: []const u8) T {
                return T.fromObject(T.class().message(objc.Class, "dataWithBytes:length:", .{ b.ptr, @as(u64, b.len) }));
            }

            pub fn dataWithBytesNoCopy(b: []u8) T {
                return T.fromObject(T.class().message(objc.Class, "dataWithBytesNoCopy:length:", .{ b.ptr, @as(u64, b.len) }));
            }

            pub fn dataWithBytesNoCopyFreeWhenDone(b: []u8, free_when_done: bool) T {
                const f: u8 = if (free_when_done) 1 else 0;
                return T.fromObject(T.class().message(objc.Class, "dataWithBytesNoCopy:length:freeWhenDone:", .{ b.ptr, @as(u64, b.len), f }));
            }

            pub fn dataWithContentsOfFileOptionsError(path: cocoa.NSString, options: ReadingOptions, err: *cocoa.NSError) ?T {
                const ret = T.class().message(?objc.c.id, "dataWithContentsOfFile:options:error:", .{ path.object.value, options, &err.object.value });
                err.* = cocoa.NSError.fromObject(.{ .value = err.object.value });
                if (ret) |r| {
                    return T.fromObject(.{ .value = r });
                } else {
                    return null;
                }
            }

            pub fn dataWithContentsOfURLOptionsError(url: cocoa.NSURL, options: ReadingOptions, err: *cocoa.NSError) ?T {
                const ret = T.class().message(?objc.c.id, "dataWithContentsOfURL:options:error:", .{ url.object.value, options, &err.object.value });
                err.* = cocoa.NSError.fromObject(.{ .value = err.object.value });
                if (ret) |r| {
                    return T.fromObject(.{ .value = r });
                } else {
                    return null;
                }
            }

            pub fn dataWithContentsOfFile(path: cocoa.NSString) ?T {
                return T.fromObject(.{
                    .value = T.class().message(?objc.c.id, "dataWithContentsOfFile:", .{path.object.value}) orelse return null,
                });
            }

            pub fn dataWithContentsOfURL(url: cocoa.NSURL) ?T {
                return T.fromObject(.{
                    .value = T.class().message(?objc.c.id, "dataWithContentsOfURL:", .{url.object.value}) orelse return null,
                });
            }

            pub fn initWithBytes(self: T, b: ?[]const u8) T {
                if (b) |byte| {
                    return T.fromObject(self.object.message(objc.Object, "initWithBytes:length:", .{ byte.ptr, @as(u64, byte.len) }));
                } else {
                    return T.fromObject(self.object.message(objc.Object, "initWithBytes:length:", .{ null, 0 }));
                }
            }

            pub fn initWithBytesNoCopy(self: T, b: []u8) T {
                return T.fromObject(self.object.message(objc.Object, "initWithBytesNoCopy:length:", .{ b.ptr, @as(u64, b.len) }));
            }

            pub fn initWithBytesNoCopyFreeWhenDone(self: T, b: []u8, free_when_done: bool) T {
                const f: u8 = if (free_when_done) 1 else 0;
                return T.fromObject(self.object.message(objc.Object, "initWithBytesNoCopy:length:freeWhenDone:", .{ b.ptr, @as(u64, b.len), f }));
            }

            pub fn initWithBytesNoCopyDeallocator(
                self: T,
                b: []u8,
                deallocator: *const fn (b: ?*anyopaque, length: u64) callconv(.C) void,
            ) T {
                return T.fromObject(self.object.message(objc.Object, "initWithBytesNoCopy:length:deallocator:", .{ b.ptr, @as(u64, b.len), deallocator }));
            }

            pub fn initWithContentsOfFileOptionsError(self: T, path: cocoa.NSString, options: ReadingOptions, err: *cocoa.NSError) ?T {
                const ret = self.object.message(?objc.c.id, "initWithContentsOfFile:options:error:", .{ path.object.value, options, &err.object.value });
                err.* = cocoa.NSError.fromObject(.{ .value = err.object.value });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn initWithContentsOfURLOptionsError(self: T, url: cocoa.NSURL, options: ReadingOptions, err: *cocoa.NSError) ?T {
                const ret = self.object.message(?objc.c.id, "initWithContentsOfURL:options:error:", .{ url.object.value, options, &err.object.value });
                err.* = cocoa.NSError.fromObject(.{ .value = err.object.value });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn initWithContentsOfFile(self: T, path: cocoa.NSString) ?T {
                const ret = self.object.message(?objc.c.id, "initWithContentsOfFile:", .{path.object.value});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn initWithContentsOfURL(self: T, url: cocoa.NSURL) ?T {
                const ret = self.object.message(?objc.c.id, "initWithContentsOfURL:", .{url.object.value});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn initWithData(self: T, other: cocoa.NSData) T {
                return T.fromObject(self.object.message(objc.Object, "initWithData:", .{other.object.value}));
            }

            pub fn dataWithData(other: cocoa.NSData) T {
                return T.fromObject(T.class().message(objc.Object, "dataWithData:", .{other.object.value}));
            }

            pub fn initWithBase64EncodedStringOptions(self: T, str: cocoa.NSString, options: Base64DecodingOptions) ?T {
                const ret = self.object.message(?objc.c.id, "initWithBas64EncodedString:options:", .{ str.object.value, options });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn base64EncodedStringWithOptions(self: T, options: Base64EncodingOptions) cocoa.NSString {
                return cocoa.NSString.fromObject(self.object.message(objc.Object, "base64EncodedStringWithOptions:", .{options}));
            }

            pub fn initWithBase64EncodedDataOptions(self: T, base_64_data: NSData, options: Base64DecodingOptions) ?T {
                const ret = self.object.message(?objc.c.id, "initWithBase64EncodedData:options:", .{ base_64_data.object.value, options });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn base64EncodedDataWithOptions(self: T, options: Base64EncodingOptions) NSData {
                return NSData.fromObject(self.object.message(objc.Object, "base64EncodedDataWithOptions:", .{options}));
            }

            pub fn decompressedDataUsingAlgorithmError(self: T, algorithm: CompressionAlgorithm, err: *cocoa.NSError) ?T {
                const ret = self.object.message(?objc.c.id, "decompressedDataUsingAlgorithm:error:", .{ @intFromEnum(algorithm), &err.object.value });
                err.* = cocoa.NSError.fromObject(.{
                    .value = err.object.value,
                });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn compressedDataUsingAlgorithmError(self: T, algorithm: CompressionAlgorithm, err: *cocoa.NSError) ?T {
                const ret = self.object.message(?objc.c.id, "compressedDataUsingAlgorithm:error:", .{ @intFromEnum(algorithm), &err.object.value });
                err.* = cocoa.NSError.fromObject(.{
                    .value = err.object.value,
                });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }
        };
    }
};

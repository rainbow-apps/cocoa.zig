const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");
const object = @import("NSObject.zig");

pub const NSString = struct {
    pub const Encoding = enum(c_ulong) {
        ASCII = 1,
        NEXTSTEP = 2,
        JapaneseEUC = 3,
        UTF8 = 4,
        Latin1 = 5,
        Symbol = 6,
        NonLossyASCII = 7,
        ShiftJIS = 8,
        ISOLatin2 = 9,
        Unicode = 10,
        WindowsCP1251 = 11,
        WindowsCP1252 = 12,
        WindowsCP1253 = 13,
        WindowsCP1254 = 14,
        WindowsCP1250 = 15,
        ISO2022JP = 21,
        MacOSRoman = 30,
    };

    pub const CompareOptions = packed struct {
        case_insensitive: bool,
        literal: bool,
        backwards: bool,
        anchored: bool,
        _unused: u2 = 0,
        numeric: bool,
        diacritic_insensitive: bool,
        width_insensitive: bool,
        forced_ordering: bool,
        regular_expression: bool, // can only be set with case_insensitive and anchored.
        _padding: u53 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    pub const ConversionOptions = packed struct {
        allow_lossy: bool,
        external_representation: bool,
        _padding: u62 = 0,

        comptime {
            std.debug.assert(@sizeOf(@This()) == @sizeOf(u64));
            std.debug.assert(@bitSizeOf(@This()) == @bitSizeOf(u64));
        }
    };

    object: objc.Object,

    pub fn class() objc.Class {
        return objc.getClass("NSString").?;
    }
    pub fn fromObject(self: objc.Object) NSString {
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
            pub usingnamespace object.NSObject(T, false);
            pub usingnamespace object.NSCopying(T, false);
            pub usingnamespace object.NSMutableCopying(T, false);
            pub usingnamespace object.NSSecureCoding(T, false);
            pub fn length(self: T) usize {
                return @intCast(self.object.getProperty(c_ulong, "length"));
            }

            pub fn characterAtIndex(self: T, index: usize) u16 {
                return self.object.message(u16, "characterAtIndex:", .{@as(u64, index)});
            }

            pub fn initWithCoder(self: T, coder: cocoa.NSCoder) objc.Object {
                return self.object.message(objc.Object, "initWithCoder:", .{&coder.object.value});
            }

            pub fn substringFromIndex(self: T, from: usize) NSString {
                return .{
                    .object = self.object.message(objc.Object, "substringFromIndex:", .{from}),
                };
            }

            pub fn substringToIndex(self: T, to: usize) NSString {
                return .{
                    .object = self.object.message(objc.Object, "substringToIndex:", .{to}),
                };
            }

            pub fn substringWithRange(self: T, range: cocoa.NSRange) NSString {
                return .{
                    .object = self.object.message(objc.Object, "substringWithRange", .{range}),
                };
            }

            pub fn getCharacters(self: T, buffer: []u16, range: cocoa.NSRange) void {
                std.debug.assert(buffer.len >= range.length);
                self.object.message(void, "getCharacters:range:", .{ buffer.ptr, range });
            }

            pub fn compare(self: T, other: NSString) cocoa.NSComparisonResult {
                const ret = self.object.message(c_long, "compare:", .{other.object.value});
                return @enumFromInt(ret);
            }

            pub fn compareOptions(self: T, other: NSString, mask: CompareOptions) cocoa.NSComparisonResult {
                const ret = self.object.message(c_long, "compare:options:", .{ other.object.value, mask });
                return @enumFromInt(ret);
            }

            pub fn compareOptionsRange(
                self: T,
                other: NSString,
                mask: CompareOptions,
                range: cocoa.NSRange,
            ) cocoa.NSComparisonResult {
                const ret = self.object.message(c_long, "compare:options:range:", .{ other.object.value, mask, range });
                return @enumFromInt(ret);
            }

            pub fn compareOptionsRangeLocale(
                self: T,
                other: NSString,
                mask: CompareOptions,
                range: cocoa.NSRange,
                locale: objc.Object,
            ) cocoa.NSComparisonResult {
                const ret = self.object.message(c_long, "compare:options:range:locale:", .{
                    other.object.value,
                    mask,
                    range,
                    locale.value,
                });
                return @enumFromInt(ret);
            }

            pub fn caseInsensitiveCompare(self: T, other: NSString) cocoa.NSComparisonResult {
                const ret = self.object.message(c_long, "caseInsensitiveCompare:", .{other.object.value});
                return @enumFromInt(ret);
            }

            pub fn localizedCompare(self: T, other: NSString) cocoa.NSComparisonResult {
                const ret = self.object.message(c_long, "localizedCompare:", .{other.object.value});
                return @enumFromInt(ret);
            }

            pub fn localizedCaseInsensitiveCompare(self: T, other: NSString) cocoa.NSComparisonResult {
                const ret = self.object.message(c_long, "localizedCaseInsensitiveCompare:", .{other.object.value});
                return @enumFromInt(ret);
            }

            pub fn localizedStandardCompare(self: T, other: NSString) cocoa.NSComparisonResult {
                const ret = self.object.message(c_long, "localizedStandardCompare:", .{other.object.value});
                return @enumFromInt(ret);
            }

            pub fn isEqualToString(self: T, other: NSString) bool {
                return if (self.object.message(u8, "isEqualToString:", .{other.object.value}) == 1) true else false;
            }

            pub fn hasPrefix(self: T, prefix: NSString) bool {
                return if (self.object.message(u8, "hasPrefix:", .{prefix.object.value}) == 1) true else false;
            }

            pub fn hasSuffix(self: T, suffix: NSString) bool {
                return if (self.object.message(u8, "hasSuffix:", .{suffix.object.value}) == 1) true else false;
            }

            pub fn containsString(self: T, other: NSString) bool {
                return if (self.object.message(u8, "containsString:", .{other.object.value}) == 1) true else false;
            }

            pub fn localizedCaseInsensitiveContainsString(self: T, other: NSString) bool {
                return if (self.object.message(u8, "localizedCaseInsensitiveContainsString:", .{other.object.value}) == 1) true else false;
            }

            pub fn localizedStandardContainsString(self: T, other: NSString) bool {
                return if (self.object.message(u8, "localizedStandardContainsString:", .{other.object.value}) == 1) true else false;
            }

            pub fn localizedStandardRangeOfString(self: T, other: NSString) cocoa.NSRange {
                return self.object.message(cocoa.NSRange, "localizedStandardRangeOfString:", .{other.object.value});
            }

            pub fn rangeOfString(self: T, other: NSString) cocoa.NSRange {
                return self.object.message(cocoa.NSRange, "rangeOfString:", .{other.object.value});
            }

            pub fn rangeOfComposedCharacterSequenceAtIndex(self: T, index: usize) cocoa.NSRange {
                return @intCast(self.object.message(c_ulong, "rangeOfComposedCharacterSequenceAtIndex:", .{index}));
            }

            pub fn rangeOfComposedCharacterSequencesForRange(self: T, range: cocoa.NSRange) cocoa.NSRange {
                return self.object.message(cocoa.NSRange, "rangeOfComposedCharacterSequencesForRange:", .{range});
            }

            pub fn stringByAppendingString(self: T, other: NSString) NSString {
                return fromObject(self.object.message(objc.Object, "stringByAppendingString:", .{other.object.value}));
            }

            pub fn doubleValue(self: T) f64 {
                return @floatCast(self.object.getProperty(c_longdouble, "doubleValue"));
            }

            pub fn floatValue(self: T) f32 {
                return self.object.getProperty(f32, "floatValue");
            }

            pub fn intValue(self: T) i32 {
                return @intCast(self.object.getProperty(c_int, "intValue"));
            }

            pub fn integerValue(self: T) i64 {
                return @intCast(self.object.getProperty(c_long, "integerValue"));
            }

            pub fn longlongValue(self: T) c_longlong {
                return self.object.getProperty(c_longlong, "longlongValue");
            }

            pub fn boolValue(self: T) bool {
                return if (self.object.getProperty(u8, "boolValue") == 1) true else false;
            }

            pub fn uppercaseString(self: T) NSString {
                return fromObject(.{
                    .value = self.object.getProperty(objc.c.id, "uppercaseString"),
                });
            }

            pub fn lowercaseString(self: T) NSString {
                return fromObject(.{
                    .value = self.object.getProperty(objc.c.id, "lowercaseString"),
                });
            }

            pub fn capitalizedString(self: T) NSString {
                return fromObject(.{
                    .value = self.object.getProperty(objc.c.id, "capitalizedString"),
                });
            }

            pub fn localizedUppercaseString(self: T) NSString {
                return fromObject(.{
                    .value = self.object.getProperty(objc.c.id, "localizedUppercaseString"),
                });
            }

            pub fn localizedLowercaseString(self: T) NSString {
                return fromObject(.{
                    .value = self.object.getProperty(objc.c.id, "localizedLowercaseString"),
                });
            }

            pub fn localizedCapitalizedString(self: T) NSString {
                return fromObject(.{
                    .value = self.object.getProperty(objc.c.id, "localizedCapitalizedString"),
                });
            }

            pub fn getLineStartEndContentsEndForRange(self: T, start: ?*u64, lineEnd: ?*u64, contentsEnd: ?*u64, range: cocoa.NSRange) void {
                self.object.message(void, "getLineStart:end:contentsEnd:forRange:", .{ start, lineEnd, contentsEnd, range });
            }

            pub fn getParagraphStartEndContentsEndForRange(self: T, start: ?*u64, lineEnd: ?*u64, contentsEnd: ?*u64, range: cocoa.NSRange) void {
                self.object.message(void, "getParagraphStart:end:contentsEnd:forRange:", .{ start, lineEnd, contentsEnd, range });
            }

            pub fn UTF8String(self: T) []const u8 {
                return std.mem.sliceTo(self.object.getProperty([*c]const u8, "UTF8String"), 0);
            }

            pub fn initWithCStringEncoding(self: T, cstring: [:0]const u8, encoding: Encoding) ?T {
                const ret = self.object.message(objc.c.id, "initWithCString:encoding:", .{ cstring.ptr, @intFromEnum(encoding) });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn stringWithCStringEncoding(cstring: [:0]const u8, encoding: Encoding) ?T {
                const ret = T.class().message(objc.c.id, "stringWithCString:encoding:", .{ cstring.ptr, @intFromEnum(encoding) });
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn initWithUTF8String(self: T, cstring: [:0]const u8) ?T {
                const ret = self.object.message(objc.c.id, "initWithUTF8String:", .{cstring.ptr});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }

            pub fn stringWithUTF8String(cstring: [:0]const u8) ?T {
                const ret = T.class().message(objc.c.id, "stringWithUTF8String:", .{cstring.ptr});
                return T.fromObject(.{
                    .value = ret orelse return null,
                });
            }
        };
    }

    pub fn rangeFromString(self: NSString) cocoa.NSRange {
        return NSRangeFromString(&self.object.value);
    }
};

extern "C" fn NSRangeFromString(aString: [*c]objc.c.id) cocoa.NSRange;

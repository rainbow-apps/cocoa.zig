const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");

pub fn NSDiscardableContent(comptime T: type, comptime should_assert: bool) type {
    comptime if (should_assert) {
        assert_structure(T);
    };
    return struct {
        pub fn beginContentAccess(self: T) bool {
            return if (self.object.message(u8, "beginContentAccess", .{}) == 1) true else false;
        }

        pub fn endContentAccess(self: T) void {
            self.object.message(void, "endContentAccess", .{});
        }

        pub fn discardContentIfPossible(self: T) void {
            self.object.message(void, "discardContentIfPossible", .{});
        }

        pub fn isContentDiscarded(self: T) bool {
            return if (self.object.message(u8, "isContentDiscarded", .{}) == 1) true else false;
        }
    };
}

pub fn NSCopying(comptime T: type, comptime should_assert: bool) type {
    comptime if (should_assert) {
        assert_structure(T);
    };
    return struct {
        /// should be called copyWithZone, but Zones are ignored, so we don't use them.
        pub fn copy(self: T) T {
            return T.fromObject(.{
                .value = self.object.message(objc.c.id, "copyWithZone:", .{null}),
            });
        }
    };
}

pub fn NSMutableCopying(comptime T: type, comptime should_assert: bool) type {
    comptime if (should_assert) {
        assert_structure(T);
    };
    return struct {
        /// should be called mutableCopyWithZone, but Zones are ignored, so we don't use them.
        pub fn mutableCopy(self: T) T {
            return T.fromObject(.{
                .value = self.object.message(objc.c.id, "mutableCopyWithZone:", .{null}),
            });
        }
    };
}

pub fn NSCoding(comptime T: type, comptime should_assert: bool) type {
    comptime if (should_assert) {
        assert_structure(T);
    };
    return struct {
        pub fn encodeWithCoder(self: T, coder: cocoa.NSCoder) void {
            self.object.message(void, "encodeWithCoder:", .{coder.object.value});
        }

        pub fn initWithCoder(self: T, coder: cocoa.NSCoder) ?T {
            return T.fromObject(.{
                .value = self.object.message(?objc.c.id, "initWithCoder:", .{coder.object.value}) orelse return null,
            });
        }
    };
}

pub fn NSSecureCoding(comptime T: type, comptime should_assert: bool) type {
    comptime if (should_assert) {
        assert_structure(T);
    };
    return struct {
        pub usingnamespace NSCoding(T, false);
        pub fn supportsSecureCoding() bool {
            return if (T.class().message(u8, "supportsSecureCoding", .{}) == 1) true else false;
        }
    };
}

pub fn NSObjectProtocol(comptime T: type, comptime should_assert: bool) type {
    comptime if (should_assert) {
        assert_structure(T);
    };
    return struct {
        pub fn isEqual(self: T, id: objc.Object) bool {
            return if (self.object.message(u8, "isEqual:", .{id.value}) == 1) true else false;
        }

        pub fn hash(self: T) u64 {
            return self.object.getProperty(u64, "hash");
        }

        pub fn superclass(self: T) objc.Class {
            return .{
                .value = self.object.getProperty(objc.c.Class, "superclass"),
            };
        }

        pub fn performSelector(self: T, sel: [:0]const u8) objc.c.id {
            return self.object.message(objc.c.id, "performSelector:", .{objc.sel(sel).value});
        }

        pub fn performSelectorWithObject(
            self: T,
            sel: [:0]const u8,
            object: objc.Object,
        ) objc.c.id {
            return self.object.message(objc.c.id, "performSelector:withObject:", .{ objc.sel(sel).value, object.value });
        }

        pub fn performSelectorWithObjectWithObject(self: T, sel: [:0]const u8, object1: objc.Object, object2: objc.Object) objc.c.id {
            return self.object.message(objc.c.id, "performSelector:", .{ objc.sel(sel).value, object1.value, object2.value });
        }

        pub fn isProxy(self: T) bool {
            return if (self.object.message(u8, "isProxy", .{}) == 1) true else false;
        }

        pub fn isKindOfClass(self: T, class: objc.Class) bool {
            return if (self.object.message(u8, "isKindOfClass:", .{class}) == 1) true else false;
        }

        pub fn isMemberOfClass(self: T, class: objc.Class) bool {
            return if (self.object.message(u8, "isMemberOfClass:", .{class}) == 1) true else false;
        }

        pub fn conformsToProtocol(self: T, protocol: objc.Protocol) bool {
            return if (self.object.message(u8, "conformsToProtocol:", .{protocol.value}) == 1) true else false;
        }

        pub fn respondsToSelector(self: T, sel: objc.Sel) bool {
            return if (self.object.message(u8, "respondsToSelector:", .{sel.value}) == 1) true else false;
        }

        pub fn respondsToMessage(self: T, message: [:0]const u8) bool {
            return respondsToSelector(self, objc.sel(message));
        }

        pub fn retain(self: T) T {
            return T.fromObject(.{
                .value = self.object.message(objc.Object, "retain", .{}),
            });
        }

        pub fn release(self: T) void {
            self.object.message(void, "release", .{});
        }

        pub fn autorelease(self: T) T {
            return T.fromObject(self.object.message(objc.Object, "autorelease", .{}));
        }

        pub fn retainCount(self: T) usize {
            return self.object.message(usize, "retainCount", .{});
        }

        pub fn getDescription(self: T) cocoa.NSString {
            const ret = self.object.getProperty(objc.c.id, "description");
            return cocoa.NSString.fromObject(.{ .value = ret });
        }
    };
}

pub fn NSObject(comptime T: type, comptime should_assert: bool) type {
    comptime if (should_assert) {
        assert_structure(T);
    };
    return struct {
        pub usingnamespace NSObjectProtocol(T, false);
        pub fn load() void {
            T.class().message(void, "load", .{});
        }

        pub fn initialize() void {
            T.class().message(void, "initialize", .{});
        }

        pub fn init(self: T) T {
            return T.fromObject(self.object.message(objc.Object, "init", .{}));
        }

        pub fn new() T {
            return T.fromObject(T.class().message(objc.Object, "new", .{}));
        }

        pub fn alloc() T {
            return T.fromObject(T.class().message(objc.Object, "alloc", .{}));
        }

        pub fn dealloc(self: T) void {
            self.object.message(void, "dealloc", .{});
        }

        pub fn instancesRespondToSelector(sel: objc.Sel) bool {
            return if (T.class().message(u8, "instancesRespondToSelector:", .{sel.value}) == 1) true else false;
        }

        pub fn instancesRespondToMessage(message: [:0]const u8) bool {
            return instancesRespondToSelector(objc.sel(message));
        }

        pub fn conformsToProtocol(protocol: objc.Protocol) bool {
            return if (T.class().message(u8, "conformsToProtocol:", .{protocol.value}) == 1) true else false;
        }

        pub fn isSubclassOfClass(class: objc.Class) bool {
            return if (T.class().message(u8, "isSubclassOfClass:", .{class.value}) == 1) true else false;
        }

        pub fn hash() u64 {
            return T.class().message(u64, "hash", .{});
        }

        pub fn superclass() objc.Class {
            return .{
                .value = T.class().message(objc.c.Class, "superclass", .{}),
            };
        }

        pub fn description() cocoa.NSString {
            const ret = T.class().message(objc.Object, "description", .{});
            return cocoa.NSString.fromObject(ret);
        }

        pub fn debugDescription() cocoa.NSString {
            const ret = T.class().message(objc.Object, "debugDescription", .{});
            return cocoa.NSString.fromObject(ret);
        }

        pub fn version() i64 {
            return @intCast(T.class().message(c_long, "version", .{}));
        }

        pub fn setVersion(aVersion: i64) void {
            T.class().message(void, "setVersion:", .{@as(c_long, aVersion)});
        }

        pub fn classForCoder(self: T) objc.Class {
            return .{
                .value = self.object.getProperty(objc.c.Class, "classForCoder"),
            };
        }

        pub fn replacementObjectForCoder(self: T, coder: cocoa.NSCoder) ?T {
            return T.fromObject(.{
                .value = self.object.message(?objc.c.id, "replacementObjectForCoder:", .{coder.object.value}) orelse return null,
            });
        }

        /// replaces receiver!
        pub fn awakeAfterUsingCoder(self: T, coder: cocoa.NSCoder) ?T {
            return T.fromObject(.{
                .value = self.object.message(?objc.c.id, "awakeAfterUsingCoder:", .{coder.object.value}) orelse return null,
            });
        }

        pub fn autoContentAccesssingProxy(self: T) T {
            return T.fromObject(.{
                .value = self.object.getProperty(objc.c.id, "autoContentAccessingProxy"),
            });
        }

        /// Given that an error alert has been presented document-modally to the user,
        /// and the user has chosen one of the error's recovery options,
        /// attempt recovery from the error, and send the selected message
        /// to the specified delegate.
        /// The option index is an index into the error's array of localized recovery options.
        /// The method selected by didRecoverSelector must have the same signature as:
        ///
        ///  - (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo;
        /// The value passed for didRecover must be YES
        /// if error recovery was completely successful, NO otherwise.
        pub fn attemptRecoveryFromError(self: T, err: cocoa.NSError, option_index: u64, delegate: objc.c.id, did_recover_sel: ?objc.Sel, context_info: ?*anyopaque) void {
            self.object.message(
                void,
                "attemptRecoveryFromError:optionIndex:delegate:didRecoverSelector:contextInfo:",
                .{
                    err.object.value,
                    option_index,
                    delegate,
                    if (did_recover_sel) |s| s.value else null,
                    context_info,
                },
            );
        }

        pub fn attemptRecoveryFromErrorOptionIndex(self: T, err: cocoa.NSError, option_index: u64) bool {
            return if (self.object.message(u8, "attemptRecoveryFromError:optionIndex:", .{
                err, option_index,
            }) == 1) true else false;
        }
    };
}

pub fn assert_structure(comptime T: type) void {
    std.debug.assert(assert: {
        switch (@typeInfo(T)) {
            .Struct => |S| {
                for (S.fields) |field| {
                    if (std.mem.eql(u8, field.name, "object")) {
                        break :assert if (field.type == objc.Object) true else false;
                    }
                }
                break :assert false;
            },
            else => break :assert false,
        }
    });
    std.debug.assert(assert: {
        switch (@typeInfo(T)) {
            .Struct => |S| {
                for (S.decls) |decl| {
                    if (std.mem.eql(u8, decl.name, "class")) break :assert true;
                }
                break :assert false;
            },
            else => break :assert false,
        }
    });
    std.debug.assert(assert: {
        switch (@typeInfo(T)) {
            .Struct => |S| {
                for (S.decls) |decl| {
                    if (std.mem.eql(u8, decl.name, "fromObject")) break :assert true;
                }
                break :assert false;
            },
            else => break :assert false,
        }
    });
}

test "alloc, init, deinit" {
    cocoa.NSObject.load();
    cocoa.NSObject.initialize();
    var obj = cocoa.NSObject.alloc().init();
    defer obj.dealloc();
    var obj2 = cocoa.NSObject.new().init();
    defer obj2.dealloc();
}

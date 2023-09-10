const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");
const object = @import("NSObject.zig");

pub const NSCoder = struct {
    object: objc.Object,
    pub fn class() objc.Class {
        return objc.getClass("NSCoder").?;
    }

    pub fn fromObject(self: objc.Object) @This() {
        return .{
            .object = self,
        };
    }

    pub usingnamespace extends(@This(), true);
};

pub fn extends(comptime T: type, comptime should_assert: bool) type {
    comptime if (should_assert) {
        object.assert_structure(T);
    };
    return struct {
        pub usingnamespace object.NSObject(@This(), false);
        pub fn encodeValueOfObjCTypeAt(self: T, t: [:0]const u8, addr: ?*anyopaque) void {
            self.object.message(void, "encodeValueOfObjCType:at:", .{ t.ptr, addr });
        }

        pub fn encodeDataObject(self: T, data: cocoa.NSData) void {
            self.object.message(void, "encodeDataObject:", .{data.object.value});
        }

        pub fn decodeDataObject(self: T) ?cocoa.NSData {
            return cocoa.NSData.fromObject(.{
                .value = self.object.message(?objc.c.id, "decodeDataObject", .{}) orelse return null,
            });
        }

        pub fn decodeValueOfObjCTypeAtSize(self: T, t: [:0]const u8, data: *anyopaque, size: usize) void {
            self.object.message(void, "decodeValueOfObjCType:at:size:", .{ t.ptr, data, @as(u64, size) });
        }

        pub fn versionForClassName(self: T, name: cocoa.NSString) i64 {
            return @intCast(self.object.message(c_long, "versionForClassName:", .{name.object.value}));
        }

        pub fn encodeObject(self: T, obj: ?objc.Object) void {
            if (obj) |o| {
                self.object.message(void, "encodeObject:", .{o.value});
            } else {
                self.object.message(void, "encodeObject:", .{null});
            }
        }

        pub fn encodeRootObject(self: T, root: objc.Object) void {
            self.object.message(void, "encodeRootObject:", .{root.value});
        }

        pub fn encodeBycopyObject(self: T, obj: ?objc.Object) void {
            if (obj) |o| {
                self.object.message(void, "encodeBycopyObject:", .{o.value});
            } else {
                self.object.message(void, "encodeBycopyObject:", .{null});
            }
        }

        pub fn encodeByrefObject(self: T, obj: ?objc.Object) void {
            if (obj) |o| {
                self.object.message(void, "encodeByrefObject:", .{o.value});
            } else {
                self.object.message(void, "encodeByrefObject:", .{null});
            }
        }

        pub fn encodeConditionalObject(self: T, obj: ?objc.Object) void {
            if (obj) |o| {
                self.object.message(void, "encodeConditionalObject:", .{o.value});
            } else {
                self.object.message(void, "encodeConditionalObject:", .{null});
            }
        }

        // I'm not sure if this approach to varargs works...
        pub fn encodeValuesOfObjCTypes(self: T, t: [:0]const u8, args: anytype) void {
            self.object.message(void, "encodeValuesOfObjCTypes:", .{t.ptr} ++ args);
        }

        pub fn encodeArrayOfObjCTypeCountAt(self: T, t: [:0]const u8, count: usize, arr: ?*anyopaque) void {
            self.object.message(void, "encodeArrayOfObjCType:count:at:", .{ t.ptr, @as(u64, count), arr });
        }

        pub fn encodeBytes(self: T, bytes: []const u8) void {
            self.object.message(void, "encodeBytes:length:", .{ bytes.ptr, @as(u64, bytes.len) });
        }

        pub fn decodeObject(self: T) ?objc.Object {
            return .{
                .value = self.object.message(?objc.c.id, "decodeObject", .{}) orelse return null,
            };
        }

        pub fn decodeTopLevelObjectAndReturnError(self: T, err: *cocoa.NSError) ?objc.Object {
            const ret = self.object.message(?objc.c.id, "decodeTopLevelObjectAndReturnError:", .{&err.object.value});
            err.object = cocoa.NSError.fromObject(.{
                .value = err.object.value,
            });
            return .{
                .value = ret orelse return null,
            };
        }

        pub fn decodeValuesOfObjCTypes(self: T, t: [:0]const u8, args: anytype) void {
            self.object.message(void, "decodeValuesOfObjCTypes:", .{t.ptr} ++ args);
        }

        pub fn decodeArrayOfObjcTypeCountAt(self: T, t: [:0]const u8, count: usize, at: *anyopaque) void {
            self.object.message(void, "decodeArrayOfObjCType:count:at:", .{ t.ptr, @as(u64, count), at });
        }

        /// corresponds to decodeBytesWithReturnedLength
        pub fn decodeBytes(self: T) ?[]u8 {
            var length: u64 = undefined;
            var got = self.object.message(?*anyopaque, "decodeBytesWithReturnedLength:", .{&length});
            if (got) |p| {
                var ptr: [*]u8 = @ptrCast(@alignCast(p));
                return ptr[0..@intCast(length)];
            } else {
                return null;
            }
        }

        pub fn encodePropertyList(self: T, aList: objc.c.id) void {
            self.object.message(void, "encodePropertyList:", .{aList});
        }

        pub fn decodePropertyList(self: T) ?objc.c.id {
            return self.object.message(?objc.c.id, "decodePropertyList", .{});
        }

        pub fn systemVersion(self: T) u64 {
            return @intCast(self.object.getProperty(c_uint, "systemVersion"));
        }

        pub fn allowsKeyedCoding(self: T) bool {
            return if (self.object.getProperty(u8, "allowsKeyedCoding") == 1) true else false;
        }

        pub fn encodeObjectForKey(self: T, obj: ?objc.Object, key: cocoa.NSString) void {
            if (obj) |o| {
                self.object.message(void, "encodeObject:forKey:", .{ o.value, key.object.value });
            } else {
                self.object.message(void, "encodeObject:forKey:", .{ null, key.object.value });
            }
        }

        pub fn encodeConditionalObjectForKey(self: T, obj: ?objc.Object, key: cocoa.NSString) void {
            if (obj) |o| {
                self.object.message(void, "encodeConditionalObject:forKey:", .{ o.value, key.object.value });
            } else {
                self.object.message(void, "encodeConditionalObject:forKey:", .{ null, key.object.value });
            }
        }

        pub fn encodeBoolForKey(self: T, b: bool, key: cocoa.NSString) void {
            self.object.message(void, "encodeBool:forKey:", .{ if (b) @as(u8, 1) else @as(u8, 0), key.object.value });
        }

        pub fn encodeIntForKey(self: T, i: c_int, key: cocoa.NSString) void {
            self.object.message(void, "encodeInt:forKey:", .{ i, key.object.value });
        }

        pub fn encodeInt32ForKey(self: T, i: i32, key: cocoa.NSString) void {
            self.object.message(void, "encodeInt32:forKey:", .{ i, key.object.value });
        }

        pub fn encodeInt64ForKey(self: T, i: i64, key: cocoa.NSString) void {
            self.object.message(void, "encodeInt64:forKey:", .{ i, key.object.value });
        }

        pub fn encodeFloatForKey(self: T, f: f32, key: cocoa.NSString) void {
            self.object.message(void, "encodeFloat:forKey:", .{ f, key.object.value });
        }

        pub fn encodeDoubleForKey(self: T, f: f64, key: cocoa.NSString) void {
            self.object.message(void, "encodeDouble:forKey:", .{ f, key.object.value });
        }

        /// corresponds to encodeBytes:length:forKey:
        pub fn encodeBytesForKey(self: T, bytes: []const u8, key: cocoa.NSString) void {
            self.object.message(void, "encodeBytes:length:forKey:", .{ bytes.ptr, @as(u64, bytes.len), key.object.value });
        }

        pub fn containsValueForKey(self: T, key: cocoa.NSString) bool {
            return if (self.object.message(u8, "containsValueForKey:", .{key.object.value}) == 1) true else false;
        }

        pub fn decodeObjectForKey(self: T, key: cocoa.NSString) ?objc.Object {
            return .{
                .value = self.object.message(?objc.c.id, "decodeObjectForKey:", .{key.object.value}) orelse return null,
            };
        }

        pub fn decodeTopLevelObjectForKeyError(self: T, key: cocoa.NSString, err: *cocoa.NSError) ?objc.Object {
            const ret = self.object.message(?objc.c.id, "decodeTopLevelObjectForKey:error:", .{ key.object.value, &err.object.value });
            err.object = cocoa.NSError.fromObject(.{
                .value = err.object.value,
            });
            return .{
                .value = ret orelse return null,
            };
        }

        pub fn decodeBoolForKey(self: T, key: cocoa.NSString) bool {
            return if (self.object.message(u8, "decodeBoolForKey:", .{key.object.value}) == 1) true else false;
        }

        pub fn decodeIntForKey(self: T, key: cocoa.NSString) c_int {
            return self.object.message(c_int, "decodeIntForKey:", .{key.object.value});
        }

        pub fn decodeInt32ForKey(self: T, key: cocoa.NSString) i32 {
            return self.object.message(i32, "decodeInt32ForKey:", .{key.object.value});
        }

        pub fn decodeInt64ForKey(self: T, key: cocoa.NSString) i64 {
            return self.object.message(i64, "decodeIntForKey:", .{key.object.value});
        }

        pub fn decodeFloatForKey(self: T, key: cocoa.NSString) f32 {
            return self.object.message(f32, "decodeFloatForKey:", .{key.object.value});
        }

        pub fn decodeDoubleForKey(self: T, key: cocoa.NSString) f64 {
            return self.object.message(f64, "decodeDoubleForKey:", .{key.object.value});
        }

        /// corresponds to decodeBytesForKey:returnedLength:
        pub fn decodeBytesForKey(self: T, key: cocoa.NSString) ?[]const u8 {
            var length: u64 = undefined;
            var got = self.object.message(?[*c]const u8, "decodeBytesForKey:returnedLength:", .{ key.object.value, &length });
            if (got) |g| {
                return g[0..@intCast(length)];
            } else {
                return null;
            }
        }

        pub fn encodeIntegerForKey(self: T, value: i64, key: cocoa.NSString) void {
            self.object.message(void, "encodeInteger:forKey:", .{ value, key.object.value });
        }

        pub fn decodeIntegerForKey(self: T, key: cocoa.NSString) i64 {
            self.object.message(i64, "decodeIntegerForKey:", .{key.object.value});
        }

        pub fn requiresSecureCoding(self: T) bool {
            return if (self.object.getProperty(u8, "requiresSecureCoding") == 1) true else false;
        }

        /// Specify what the expected class of the allocated object is.
        /// If the coder responds YES to -requiresSecureCoding,
        /// then an exception will be thrown if the class to be decoded
        /// does not implement NSSecureCoding or is not isKindOfClass: of the argument.
        /// If the coder responds NO to -requiresSecureCoding,
        /// then the class argument is ignored and no check of the class
        /// of the decoded object is performed, exactly as if decodeObjectForKey: had been called.
        pub fn decodeObjectOfClassForKey(self: T, aClass: objc.Class, key: cocoa.NSString) ?objc.Object {
            return .{
                .value = self.object.message(?objc.c.id, "decodeObjectOfClass:forKey:", .{ aClass.value, key.object.value }) orelse return null,
            };
        }

        pub fn decodeTopLevelObjectOfClassForKey(self: T, aClass: objc.Class, key: cocoa.NSString) ?objc.Object {
            return .{
                .value = self.object.message(?objc.c.id, "decodeTopLevelObjectOfClass:forKey:", .{ aClass.value, key.object.value }) orelse return null,
            };
        }

        // /**
        //  Decodes the \c NSArray object for the given  \c key, which should be an \c NSArray<cls>, containing the given non-collection class (no nested arrays or arrays of dictionaries, etc) from the coder.
        //
        //  Requires \c NSSecureCoding otherwise an exception is thrown and sets the \c decodingFailurePolicy to \c NSDecodingFailurePolicySetErrorAndReturn.
        //
        //  Returns \c nil if the object for \c key is not of the expected types, or cannot be decoded, and sets the \c error on the decoder.
        //  */
        // - (nullable NSArray *)decodeArrayOfObjectsOfClass:(Class)cls forKey:(NSString *)key API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)) NS_REFINED_FOR_SWIFT;
        //
        // /**
        //   Decodes the \c NSDictionary object for the given \c key, which should be an \c NSDictionary<keyCls,objectCls> , with keys of type given in \c keyCls and objects of the given non-collection class \c objectCls (no nested dictionaries or other dictionaries contained in the dictionary, etc) from the coder.
        //
        //  Requires \c NSSecureCoding otherwise an exception is thrown and sets the \c decodingFailurePolicy to \c NSDecodingFailurePolicySetErrorAndReturn.
        //
        //  Returns \c nil if the object for \c key is not of the expected types, or cannot be decoded, and sets the \c error on the decoder.
        //  */
        // - (nullable NSDictionary *)decodeDictionaryWithKeysOfClass:(Class)keyCls objectsOfClass:(Class)objectCls forKey:(NSString *)key API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)) NS_REFINED_FOR_SWIFT;

        // The class of the object may be any class in the provided NSSet, or a subclass of any class in the set. Otherwise, the behavior is the same as -decodeObjectOfClass:forKey:.
        // - (nullable id)decodeObjectOfClasses:(nullable NSSet<Class> *)classes forKey:(NSString *)key API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0)) NS_REFINED_FOR_SWIFT;
        // - (nullable id)decodeTopLevelObjectOfClasses:(nullable NSSet<Class> *)classes forKey:(NSString *)key error:(NSError **)error API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) NS_SWIFT_UNAVAILABLE("Use 'decodeObject(of:, forKey:)' instead");

        // /**
        //  Decodes the \c NSArray object for the given \c key, which should be an \c NSArray, containing the given non-collection classes (no nested arrays or arrays of dictionaries, etc) from the coder.
        //
        //  Requires \c NSSecureCoding otherwise an exception is thrown and sets the \c decodingFailurePolicy to \c NSDecodingFailurePolicySetErrorAndReturn.
        //
        //  Returns \c nil if the object for \c key is not of the expected types, or cannot be decoded, and sets the \c error on the decoder.
        //  */
        // - (nullable NSArray *)decodeArrayOfObjectsOfClasses:(NSSet<Class> *)classes forKey:(NSString *)key API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)) NS_REFINED_FOR_SWIFT;

        //    /// Decodes the NSDictionary object for the given key,
        //    /// which should be an NSDictionary, with keys of the types given in keyClasses
        //        /// and objects of the given non-collection classes in objectClasses
        //        /// (no nested dictionaries or other dictionaries contained in the dictionary, etc)
        //        /// from the given coder.

        //        /// Requires NSSecureCoding otherwise an exception is thrown
        //        /// and sets the decodingFailurePolicy to
        //        /// NSDecodingFailurePolicySetErrorAndReturn.

        //        /// Returns null if the object for key is not of the expected types,
        //    /// or cannot be decoded, and sets the error on the decoder.
        //        pub fn decodeDictionaryWithKeysOfClassesObjectsOfClassesForKey(self: T, classes: cocoa.NSSet(objc.Class), objects: coco.NSSet(objc.Class), key: cocoa.NSString) {}

        /// Calls decodeObjectOfClasses:forKey: with a set allowing only property list types.
        pub fn decodePropertyListForKey(self: T, key: cocoa.NSString) ?objc.Object {
            return .{
                .value = self.object.message(?objc.c.id, "decodePropertyListForKey:", .{key.object.value}) orelse return null,
            };
        }

        /// Get the current set of allowed classes.
        pub fn allowedClasses(self: T) ?cocoa.NSSet(objc.Class) {
            const ret = self.object.getProperty(?objc.c.id, "allowedClasses");
            if (ret) |r| {
                return cocoa.NSSet(objc.Class).fromObject(.{
                    .value = r,
                });
            } else {
                return null;
            }
        }
        /// Signals to this coder that the decode has failed.
        /// Sets an error on this NSCoder once per TopLevel decode;
        /// calling it repeatedly will have no effect until the call stack unwinds
        /// to one of the TopLevel decode entry-points.
        /// This method is only meaningful to call for decodes.
        /// Typically, you would want to call this method in your -initWithCoder: implementation
        /// when you detect situations like:
        /// - lack of secure coding
        /// - corruption of your data
        /// - domain validation failures
        /// After calling -failWithError: within your -initWithCoder: implementation,
        /// you should clean up and return nil as early as possible.
        /// Once an error has been signaled to a decoder, it remains set until it has handed off
        /// to the first TopLevel decode invocation above it.  For example, consider the following call graph:
        /// A    -decodeTopLevelObjectForKey:error:
        /// B        -initWithCoder:
        /// C            -decodeObjectForKey:
        /// D                -initWithCoder:
        /// E                    -decodeObjectForKey:
        /// F                        -failWithError:
        ///
        /// In this case the error provided in stack-frame F will be returned
        /// via the outError in stack-frame A.
        /// Furthermore the result object from decodeTopLevelObjectForKey:error: will be nil,
        /// regardless of the result of stack-frame B.
        ///
        /// NSCoder implementations support two mechanisms for the stack-unwinding from F to A:
        /// - forced (NSException based)
        /// - particpatory (error based)
        ///
        /// The kind of unwinding you get is determined by the decodingFailurePolicy property
        /// of this NSCoder (which defaults to NSDecodingFailurePolicyRaiseException to match historical behavior).
        pub fn failWithError(self: T, err: cocoa.NSError) void {
            self.object.message(void, "failWithError:", .{err.object.value});
        }

        /// defaults to .RaiseException
        pub fn decodinFailurePolicy(self: T) NSDecodingFailurePolicy {
            return @enumFromInt(self.object.getProperty(c_int, "decodingFailurePolicy"));
        }

        /// The current error (if there is one) for the current TopLevel decode.
        /// For .RaiseException, this will always be null.
        /// consumed by TopLevel decode API, which resets the coder back to being
        /// potentially able to decode data.
        pub fn getError(self: T) ?cocoa.NSError {
            const ret = self.object.getProperty(?objc.c.id, "error");
            return cocoa.NSError.fromObject(.{
                .value = ret orelse return null,
            });
        }
    };
}

pub const NSDecodingFailurePolicy = enum(c_int) {
    RaiseException,
    SetErrorAndReturn,
};

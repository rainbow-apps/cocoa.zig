const std = @import("std");
const objc = @import("zig-objc");
const cocoa = @import("main.zig");

pub const NSRange = extern struct {
    location: u64,
    length: u64,

    pub fn make(location: u64, length: u64) NSRange {
        return .{
            .location = location,
            .length = length,
        };
    }

    pub fn max(self: NSRange) u64 {
        return self.location + self.length;
    }

    pub fn locationInRange(self: NSRange, loc: u64) bool {
        return (!(loc < self.location) and (loc - self.location) < self.length);
    }

    pub fn equal(self: NSRange, other: NSRange) bool {
        return (self.location == other.location and self.length == other.length);
    }

    pub fn unionRange(self: NSRange, other: NSRange) NSRange {
        return NSUnionRange(self, other);
    }

    pub fn intersectionRange(self: NSRange, other: NSRange) NSRange {
        return NSIntersectionRange(self, other);
    }

    pub fn stringFromRang(self: NSRange) cocoa.NSString {
        return cocoa.NSString.fromObject(.{
            .value = NSStringFromRange(self),
        });
    }
};

extern "C" fn NSUnionRange(range1: NSRange, range2: NSRange) NSRange;
extern "C" fn NSIntersectionRange(range1: NSRange, range2: NSRange) NSRange;
extern "C" fn NSStringFromRange(range: NSRange) [*c]objc.c.id;

//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub const AocSolution = struct {
    answer: isize,
    time: usize,
};

pub fn divMod(comptime T: type, num: T, den: T) struct { div: T, rem: T } {
    return .{
        .div = @divTrunc(num, den),
        .rem = @rem(num, den),
    };
}

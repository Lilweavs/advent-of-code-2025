const std = @import("std");
const utils = @import("utils");

const Allocator = std.mem.Allocator;

const AocSolution = utils.AocSolution;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const p1 = try solvePart1(@embedFile("input.txt"), allocator);
    std.debug.print("Day 01|1: {d} dt: {d:0.3} ms\n", .{ p1.answer, @as(f32, @floatFromInt(p1.time)) / std.time.ns_per_ms });
    const p2 = try solvePart2(@embedFile("input.txt"), allocator);
    std.debug.print("Day 01|2: {d} dt: {d:0.3} ms\n", .{ p2.answer, @as(f32, @floatFromInt(p2.time)) / std.time.ns_per_ms });
}

const Ranges = struct {
    left: usize,
    right: usize,
};

fn solvePart1(input: []const u8, allocator: Allocator) !AocSolution {
    var comma = std.mem.tokenizeScalar(u8, input[0 .. input.len - 1], ',');
    var ranges = std.ArrayList(Ranges).empty;

    while (comma.next()) |range| {
        var hyphen = std.mem.tokenizeScalar(u8, range, '-');
        const l = hyphen.next().?;
        const r = hyphen.next().?;
        try ranges.append(allocator, .{
            .left = try std.fmt.parseInt(usize, l, 10),
            .right = try std.fmt.parseInt(usize, r, 10),
        });
    }

    var invalid_ids = std.ArrayList(usize).empty;

    var timer = try std.time.Timer.start();

    var sum: usize = 0;
    for (ranges.items) |*range| {
        // get range of possible numbers
        var ldigit: usize = @intFromFloat((@floor(@log10(@as(f32, @floatFromInt(range.left)))) + 1));
        if (ldigit & 1 == 1) {
            // odd number of digits can we shift the lower range?
            const new_bound = std.math.pow(usize, 10, ldigit);
            ldigit += 1;
            if (new_bound < range.right) {
                range.left = new_bound;
            } else {
                continue;
            }
        }

        const rdigit: usize = @intFromFloat((@floor(@log10(@as(f32, @floatFromInt(range.right)))) + 1));
        if (rdigit & 1 == 1) {
            const new_bound = std.math.pow(usize, 10, rdigit - 1) - 1;
            if (new_bound > range.left) {
                range.right = new_bound;
            } else {
                continue;
            }
        }

        // business
        const divisor = std.math.pow(usize, 10, ldigit / 2);
        const lu = range.left / divisor;
        const ll = range.left - lu * divisor;

        const ru = range.right / divisor;
        const rl = range.right - ru * divisor;

        if (lu == ru) {
            // only need to check one
            if (lu >= ll and lu <= rl) {
                try invalid_ids.append(allocator, lu + lu * divisor);
            }
        } else {
            if (lu >= ll) {
                try invalid_ids.append(allocator, lu + lu * divisor);
            }
            if (ru <= rl) {
                try invalid_ids.append(allocator, ru + ru * divisor);
            }
            // now loop through all candidates
            for (lu + 1..ru) |i| {
                try invalid_ids.append(allocator, i + i * divisor);
            }
        }
    }

    for (invalid_ids.items) |ids| {
        sum += ids;
    }

    return .{
        .answer = @intCast(sum),
        .time = timer.lap(),
    };
}

fn solvePart2(input: []const u8, allocator: Allocator) !AocSolution {
    var comma = std.mem.tokenizeScalar(u8, input[0 .. input.len - 1], ',');
    var ranges = std.ArrayList(Ranges).empty;

    while (comma.next()) |range| {
        var hyphen = std.mem.tokenizeScalar(u8, range, '-');
        const l = hyphen.next().?;
        const r = hyphen.next().?;
        try ranges.append(allocator, .{
            .left = try std.fmt.parseInt(usize, l, 10),
            .right = try std.fmt.parseInt(usize, r, 10),
        });
    }

    var invalid_ids = std.ArrayList(usize).empty;

    var timer = try std.time.Timer.start();

    var sum: usize = 0;
    for (ranges.items) |*range| {
        // get range of possible numbers

        const digits: usize = @max(@as(usize, @intFromFloat((@floor(@log10(@as(f32, @floatFromInt(range.left)))) + 1))), @as(usize, @intFromFloat((@floor(@log10(@as(f32, @floatFromInt(range.right)))) + 1))));

        var split = digits / 2;
        while (split != 0) : (split -= 1) {
            if (digits % split != 0) continue;

            const divisor = std.math.pow(usize, 10, digits - split);
            const lower = range.left / divisor;
            const upper = range.right / divisor;

            for (lower..upper + 1) |candidate| {
                const c: f32 = @floatFromInt(candidate);
                if (@floor(@log10(c)) != @floor(@log10(c))) continue;

                var offset: usize = 2;
                while (true) {
                    const ll =



                }




            }

            if (lu == ru) {
                // only need to check one
                if (lu >= ll and lu <= rl) {
                    try invalid_ids.append(allocator, lu + lu * divisor);
                    // std.debug.print("  Found: {d}{d}\n", .{ lu, lu });
                }
                // if (ru <= rl and ru >= ll) {
                //     std.debug.print("  Found: {d}{d}\n", .{ ru, ru });
                // }
            } else {
                if (lu >= ll) {
                    try invalid_ids.append(allocator, lu + lu * divisor);
                    // std.debug.print("  Found: {d}{d}\n", .{ lu, lu });
                }
                if (ru <= rl) {
                    try invalid_ids.append(allocator, ru + ru * divisor);
                    // std.debug.print("  Found: {d}{d}\n", .{ ru, ru });
                }
                // now loop through all candidates
                for (lu + 1..ru) |i| {
                    try invalid_ids.append(allocator, i + i * divisor);
                    // std.debug.print("  Found: {d}{d}\n", .{ i, i });
                }
            }

            // starting with half
            var divisor = split;
            while (divisor != 0) : (split -= split) {}
        }

        // business
        // const divisor = std.math.pow(usize, 10, ldigit / 2);
        // const lu = range.left / divisor;
        // const ll = range.left - lu * divisor;

        // const ru = range.right / divisor;
        // const rl = range.right - ru * divisor;

        // // std.debug.print("{d},{d},{d},{d}\n", .{ lu, ll, ru, rl });

    }

    for (invalid_ids.items) |ids| {
        sum += ids;
        // std.debug.print("{d}\n", .{ids});
    }

    return .{
        .answer = @intCast(sum),
        .time = timer.lap(),
    };
}

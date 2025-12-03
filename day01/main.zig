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

const Rotation = struct {
    const Direction = enum {
        Left,
        Right,
    };
    direction: Direction,
    distance: isize,
};

fn solvePart1(input: []const u8, allocator: Allocator) !AocSolution {
    var iter = std.mem.tokenizeScalar(u8, input, '\n');
    var rotations = std.ArrayList(Rotation).empty;
    while (iter.next()) |line| {
        if (line.len == 0) break;

        try rotations.append(allocator, .{
            .direction = if (line[0] == 'L') .Left else .Right,
            .distance = try std.fmt.parseInt(isize, line[1..], 10),
        });
    }

    var timer = try std.time.Timer.start();

    var pos: isize = 50;
    var cnt: isize = 0;
    for (rotations.items) |rotation| {
        if (rotation.direction == .Left) {
            pos = @mod(pos - rotation.distance, 100);
        } else {
            pos = @mod(pos + rotation.distance, 100);
        }
        if (pos == 0) cnt += 1;
    }

    return .{
        .answer = cnt,
        .time = timer.lap(),
    };
}

fn solvePart2(input: []const u8, allocator: Allocator) !AocSolution {
    var iter = std.mem.tokenizeScalar(u8, input, '\n');
    var rotations = std.ArrayList(Rotation).empty;
    while (iter.next()) |line| {
        if (line.len == 0) break;

        try rotations.append(allocator, .{
            .direction = if (line[0] == 'L') .Left else .Right,
            .distance = try std.fmt.parseInt(isize, line[1..], 10),
        });
    }

    var timer = try std.time.Timer.start();

    var pos: isize = 50;
    var cnt: isize = 0;
    for (rotations.items) |rotation| {
        const dm = utils.divMod(isize, rotation.distance, 100);
        const prev = pos;

        if (prev != 0) {
            if (rotation.direction == .Left) {
                pos = @mod(pos - dm.rem, 100);
                if (pos != 0 and pos > prev) cnt += 1;
            } else {
                pos = @mod(pos + dm.rem, 100);
                if (pos != 0 and pos < prev) cnt += 1;
            }
            if (pos == 0) cnt += 1;
        } else {
            pos += if (rotation.direction == .Left) -dm.rem else dm.rem;
            pos = @mod(pos, 100);
        }
        cnt += dm.div;

        // for (0..@intCast(rotation.distance)) |_| {
        //     pos += if (rotation.direction == .Left) -1 else 1;
        //     pos = @mod(pos, 100);
        //     if (pos == 0) cnt += 1;
        // }
    }

    return .{
        .answer = cnt,
        .time = timer.lap(),
    };
}

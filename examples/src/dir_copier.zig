/// This program is an example program, showing how to use the ZigLog logging library
const std = @import("std");
const ziglog = @import("ziglog");

pub fn main() !void {
    const logger = try ziglog.Logger.get(.{});

    const args = try std.process.argsAlloc(std.heap.page_allocator);

    if (args.len != 3) {
        const cmd = args[0];

        try logger.err(.{ .message = try std.fmt.allocPrint(
            std.heap.page_allocator,
            "Usage: {s} <src> <dest>",
            .{cmd},
        ) });
        return;
    }

    const src = args[1];
    const dest = args[2];

    try copy_files(src, dest);
}

fn copy_files(src: []const u8, dest: []const u8) !void {
    const logger = try ziglog.Logger.get(.{});
    try logger.info(.{ .message = try std.fmt.allocPrint(
        std.heap.page_allocator,
        "Starting copy process from {s} to {s}",
        .{ src, dest },
    ) });

    return;
}

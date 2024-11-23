const std = @import("std");
const fs = std.fs;

pub fn log(file_path: []const u8, text: []const u8) !void {
    const file = fs.cwd().openFile(file_path, .{ .mode = .read_write }) catch try fs.cwd().createFile(file_path, .{});
    defer file.close();

    // var buffer: [1024]u8 = undefined;

    try file.seekFromEnd(0);
    // _ = try file.readAll(&buffer);

    _ = try file.writeAll(text);
    _ = try file.writeAll("\n");
}

/// This program is an example program, showing how to use the ZigLog logging library
const std = @import("std");
const fs = std.fs;
const ziglog = @import("ziglog");

fn dir_exists(src: []const u8) bool {
    var result = fs.cwd().openDir(src, .{}) catch {
        return false;
    };
    defer result.close();
    return true;
}

pub fn main() !void {
    const logger = try ziglog.Logger.get(.{
        .format_string = "[{level}] {message}",
        .sink = .file,
        .file_path = "logs.txt",
    });

    const args = try std.process.argsAlloc(std.heap.page_allocator);

    if (args.len != 3) {
        const cmd = args[0];

        try logger.err(try std.fmt.allocPrint(
            std.heap.page_allocator,
            "Usage: {s} <src> <dest>",
            .{cmd},
        ));
        return;
    }

    const src = args[1];
    const dest = args[2];

    _ = try copy_files(src, dest);
}

fn copy_files(src: []const u8, dest: []const u8) !usize {
    const logger = try ziglog.Logger.get(.{});
    try logger.info(try std.fmt.allocPrint(
        std.heap.page_allocator,
        "Starting copy process from {s} to {s}",
        .{ src, dest },
    ));

    try logger.debug("Opening source directory");

    var src_dir = try fs.cwd().openDir(src, .{ .iterate = true });
    defer src_dir.close();

    var src_files = src_dir.iterate();
    var total_bytes: usize = 0;

    if (!dir_exists(dest)) {
        try fs.cwd().makeDir(dest);
    }

    while (try src_files.next()) |f| {
        const src_elem = try std.fmt.allocPrint(
            std.heap.page_allocator,
            "{s}/{s}",
            .{ src, f.name },
        );
        const dest_elem = try std.fmt.allocPrint(
            std.heap.page_allocator,
            "{s}/{s}",
            .{ dest, f.name },
        );
        if (f.kind == .file) {
            total_bytes += (try copy_file(src_elem, dest_elem)).?;
        } else if (f.kind == .directory) {
            try logger.info(try std.fmt.allocPrint(
                std.heap.page_allocator,
                "Go into sub-dir {s} for {s}",
                .{ src_elem, dest_elem },
            ));
            total_bytes += try copy_files(src_elem, dest_elem);
        }
    }

    try logger.info(try std.fmt.allocPrint(
        std.heap.page_allocator,
        "Total bytes copied: {}",
        .{total_bytes},
    ));

    return total_bytes;
}

fn copy_file(src: []const u8, dest: []const u8) !?usize {
    const logger = try ziglog.Logger.get(.{});

    const src_file = try fs.cwd().openFile(src, .{ .mode = .read_only });
    defer src_file.close();
    try logger.info(try std.fmt.allocPrint(
        std.heap.page_allocator,
        "Opened source file {s}",
        .{src},
    ));

    const dest_file = try fs.cwd().createFile(dest, .{
        .truncate = true,
    });
    defer dest_file.close();
    try logger.info(try std.fmt.allocPrint(
        std.heap.page_allocator,
        "Opened dest file {s}",
        .{dest},
    ));

    var buffer: [1024]u8 = undefined;
    var bytes: usize = 0;

    while (true) {
        const curr = try src_file.read(&buffer);
        if (curr == 0) break;

        bytes += curr;
        _ = try dest_file.write(buffer[0..curr]);
    }

    try logger.info(try std.fmt.allocPrint(
        std.heap.page_allocator,
        "Copied {} bytes",
        .{bytes},
    ));
    return bytes;
}

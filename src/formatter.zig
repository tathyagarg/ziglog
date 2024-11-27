const std = @import("std");
const logging = @import("logging.zig");
const LogLevel = logging.LogLevel;
const convertor = logging.log_level_to_label;

const zigTime = @import("std").time;
const cTime = @cImport(@cInclude("time.h"));

const labels = .{ "{level}", "{message}", "{time}" };

pub const Formatter = struct {
    format_string: []const u8,

    const Self = @This();

    pub fn init(options: struct {
        format_string: []const u8 = "{time} [{level}] {message}",
    }) Self {
        return Self{
            .format_string = options.format_string,
        };
    }

    pub fn format(
        self: Self,
        log_level: LogLevel,
        message: []const u8,
    ) ![]const u8 {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        const allocator = arena.allocator();

        var timestamp_buf: [13]u8 = undefined; // will hold a unix timestamp, which is currently 13 digits long.
        const timestamp = try std.fmt.bufPrint(&timestamp_buf, "{}", .{zigTime.timestamp()});
        const values = .{ convertor(log_level), message, timestamp };

        var size = self.format_string.len;
        var new = try allocator.alloc(u8, size);
        var formatted = try std.fmt.allocPrint(std.heap.page_allocator, "{s}", .{self.format_string});

        inline for (labels, 0..) |l, i| {
            const v = values[i];
            if (std.mem.containsAtLeast(u8, formatted, 1, l)) {
                size = std.mem.replacementSize(u8, formatted, l, v);
                new = try allocator.alloc(u8, size);

                _ = std.mem.replace(u8, formatted, l, v, new);
                formatted = new;
            }
        }

        return formatted;
    }
};

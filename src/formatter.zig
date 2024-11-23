const std = @import("std");
const logging = @import("logging.zig");
const LogLevel = logging.LogLevel;
const convertor = logging.log_level_to_label;

const labels = .{ "{level}", "{message}" };

pub const Formatter = struct {
    format_string: []const u8,

    const Self = @This();

    pub fn init(options: struct {
        format_string: []const u8 = "[{level}] {message}",
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

        var size = self.format_string.len;
        const values = .{ convertor(log_level), message };
        var new = try allocator.alloc(u8, size);
        var formatted_old = try std.fmt.allocPrint(std.heap.page_allocator, "{s}", .{self.format_string});

        inline for (labels, 0..) |l, i| {
            const v = values[i];
            if (std.mem.containsAtLeast(u8, formatted_old, 1, l)) {
                size = std.mem.replacementSize(u8, formatted_old, l, v);
                new = try allocator.alloc(u8, size);

                _ = std.mem.replace(u8, formatted_old, l, v, new);
                formatted_old = new;
            }
        }

        return formatted_old;
    }
};

const std = @import("std");
const LogLevel = @import("../logging.zig").LogLevel;
const file_sink = @import("file.zig");

fn console_logger(text: []const u8) void {
    std.debug.print("{s}\n", .{text});
}

pub const SinkType = enum {
    console,
    file,
};

pub const Sink = struct {
    sink_type: SinkType,
    file_path: []const u8,

    const Self = @This();

    pub fn init(options: struct { sink_type: SinkType, file_path: []const u8 = "" }) Self {
        return Self{
            .sink_type = options.sink_type,
            .file_path = options.file_path,
        };
    }

    pub fn log(self: Self, text: []const u8) !void {
        try switch (self.sink_type) {
            .console => console_logger(text),
            .file => file_sink.log(self.file_path, text),
        };
    }
};

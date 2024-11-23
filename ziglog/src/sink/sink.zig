const std = @import("std");
const LogLevel = @import("../logging.zig").LogLevel;

fn console_logger(text: []const u8) void {
    std.debug.print("{s}\n", .{text});
}

pub const SinkType = enum {
    console,
    file,
};

pub const Sink = struct {
    sink_type: SinkType,

    const Self = @This();

    pub fn init(options: struct { sink_type: SinkType }) Self {
        return Self{ .sink_type = options.sink_type };
    }

    pub fn log(self: Self, text: []const u8) void {
        switch (self.sink_type) {
            SinkType.console => console_logger(text),
            SinkType.file => unreachable,
        }
    }
};

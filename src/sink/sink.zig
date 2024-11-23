const LogLevel = @import("../logging.zig").LogLevel;
const console_logger = @import("console.zig");

pub const SinkTypes = enum {
    console,
    file,
};

pub const Sink = struct {
    sink_type: SinkTypes,

    const Self = @This();

    pub fn init(options: struct { sink_type: SinkTypes }) Self {
        return Self{ .sink_type = options.sink_type };
    }

    pub fn log(self: Self, log_level: LogLevel) void {
        switch (self.sink_type) {
            SinkTypes.console => console_logger.log(log_level),
            SinkTypes.file => unreachable,
        }
    }
};

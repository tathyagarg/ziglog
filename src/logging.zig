const std = @import("std");
const sinks = @import("sink/sink.zig");
const formatters = @import("formatter.zig");

var loggers = std.StringHashMap(Logger).init(std.heap.page_allocator);

pub const LogLevel = enum { trace, debug, info, warn, err, fatal };
pub fn log_level_to_label(log_level: LogLevel) []const u8 {
    return switch (log_level) {
        .trace => "TRACE",
        .debug => "DEBUG",
        .info => "INFO",
        .warn => "WARN",
        .err => "ERROR",
        .fatal => "FATAL",
    };
}

const LoggerOpts = struct {
    name: []const u8,
    default_level: LogLevel = .debug,
    sink: sinks.SinkType = .console,
    format_string: []const u8 = "{time} [{level}] {message}",
    file_path: []const u8 = "",
};

pub const Logger = struct {
    default_level: LogLevel,
    sink: sinks.Sink,
    formatter: formatters.Formatter,

    const Self = @This();

    fn init(options: LoggerOpts) Self {
        return Logger{
            .default_level = options.default_level,
            .sink = sinks.Sink.init(.{
                .sink_type = options.sink,
                .file_path = options.file_path,
            }),
            .formatter = formatters.Formatter.init(.{ .format_string = options.format_string }),
        };
    }

    pub fn get(options: LoggerOpts) !Self {
        if (loggers.get(options.name) != null) {
            return loggers.get(options.name).?;
        }
        const logger = Logger.init(options);
        try loggers.put(options.name, logger);

        return logger;
    }

    pub fn log(self: Self, message: []const u8) !void {
        const text = try self.formatter.format(self.default_level, message);
        try self.sink.log(text);
    }

    pub fn trace(self: Self, message: []const u8) !void {
        const text = try self.formatter.format(.trace, message);
        try self.sink.log(text);
    }

    pub fn debug(self: Self, message: []const u8) !void {
        const text = try self.formatter.format(.debug, message);
        try self.sink.log(text);
    }

    pub fn info(self: Self, message: []const u8) !void {
        const text = try self.formatter.format(.info, message);
        try self.sink.log(text);
    }

    pub fn warn(self: Self, message: []const u8) !void {
        const text = try self.formatter.format(.warn, message);
        try self.sink.log(text);
    }

    pub fn err(self: Self, message: []const u8) !void {
        const text = try self.formatter.format(.err, message);
        try self.sink.log(text);
    }

    pub fn fatal(self: Self, message: []const u8) !void {
        const text = try self.formatter.format(.fatal, message);
        try self.sink.log(text);
    }
};

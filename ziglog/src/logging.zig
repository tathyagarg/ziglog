const errors = @import("errors.zig").Errors;
const sinks = @import("sink/sink.zig");
const formatters = @import("formatter.zig");

var logger_instance: ?Logger = null;

pub const LogLevel = enum { trace, debug, info, warn, err, fatal };
pub fn log_level_to_label(log_level: LogLevel) []const u8 {
    return switch (log_level) {
        LogLevel.trace => "TRACE",
        LogLevel.debug => "DEBUG",
        LogLevel.info => "INFO",
        LogLevel.warn => "WARN",
        LogLevel.err => "ERROR",
        LogLevel.fatal => "FATAL",
    };
}

const LogOpts = struct { message: []const u8 };
const LoggerOpts = struct {
    default_level: LogLevel = LogLevel.debug,
    sink: sinks.SinkType = sinks.SinkType.console,
    format_string: []const u8 = "{time} [{level}] {message}",
};

pub const Logger = struct {
    default_level: LogLevel,
    sink: sinks.Sink,
    formatter: formatters.Formatter,

    const Self = @This();

    fn init(options: LoggerOpts) Self {
        return Logger{
            .default_level = options.default_level,
            .sink = sinks.Sink.init(.{ .sink_type = options.sink }),
            .formatter = formatters.Formatter.init(.{ .format_string = options.format_string }),
        };
    }

    pub fn get(options: LoggerOpts) !Self {
        if (logger_instance != null) {
            return logger_instance.?;
        }
        logger_instance = Logger.init(options);
        return logger_instance.?;
    }

    pub fn reset() !void {
        if (logger_instance == null) {
            return errors.CannotResetUninitialized;
        }
        logger_instance = null;
    }

    pub fn log(self: Self, options: LogOpts) !void {
        const text = try self.formatter.format(self.default_level, options.message);
        self.sink.log(text);
    }

    pub fn trace(self: Self, options: LogOpts) !void {
        const text = try self.formatter.format(LogLevel.trace, options.message);
        self.sink.log(text);
    }

    pub fn debug(self: Self, options: LogOpts) !void {
        const text = try self.formatter.format(LogLevel.debug, options.message);
        self.sink.log(text);
    }

    pub fn info(self: Self, options: LogOpts) !void {
        const text = try self.formatter.format(LogLevel.info, options.message);
        self.sink.log(text);
    }

    pub fn warn(self: Self, options: LogOpts) !void {
        const text = try self.formatter.format(LogLevel.warn, options.message);
        self.sink.log(text);
    }

    pub fn err(self: Self, options: LogOpts) !void {
        const text = try self.formatter.format(LogLevel.err, options.message);
        self.sink.log(text);
    }

    pub fn fatal(self: Self, options: LogOpts) !void {
        const text = try self.formatter.format(LogLevel.fatal, options.message);
        self.sink.log(text);
    }
};

const errors = @import("errors.zig").Errors;

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

pub const Logger = struct {
    default_level: LogLevel,

    const Self = @This();

    fn init(default_level: ?LogLevel) Self {
        return Logger{
            .default_level = default_level orelse LogLevel.debug,
        };
    }

    pub fn get(options: struct {
        default_level: ?LogLevel = null,
    }) !Self {
        if (logger_instance != null) {
            if (options.default_level != null) {
                return errors.UnexpectedLevelSpecifier;
            }
            return logger_instance.?;
        }
        logger_instance = Logger.init(options.default_level);
        return logger_instance.?;
    }

    pub fn reset() !void {
        if (logger_instance == null) {
            return errors.CannotResetUninitialized;
        }
        logger_instance = null;
    }
};

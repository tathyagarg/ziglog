pub const LogLevel = enum { trace, debug, info, warn, err, fatal };

pub const Logger = struct {
    default_level: LogLevel,

    const Self = @This();

    pub fn init(default_level: LogLevel) Self {
        return Logger{ .default_level = default_level };
    }

    pub fn default() Self {
        return Self.init(LogLevel.debug);
    }
};

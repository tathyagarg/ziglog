const std = @import("std");
const testing = std.testing;
const logging = @import("ziglog").logging;

test "default log level" {
    const logger = try logging.Logger.get(.{});

    try testing.expect(logger.default_level == logging.LogLevel.debug);

    try logging.Logger.reset();
}

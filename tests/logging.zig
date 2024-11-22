const std = @import("std");
const testing = std.testing;
const logging = @import("ziglog").logging;

test "default log level" {
    const logger = logging.Logger.default();
    return testing.expect(logger.default_level == logging.LogLevel.debug);
}

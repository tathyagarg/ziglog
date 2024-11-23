const std = @import("std");
const testing = std.testing;
const formatter = @import("ziglog").formatter;
const logging = @import("ziglog").logging;

test "custom format string" {
    const f = formatter.Formatter.init(.{
        .format_string = "log ({level}): {message}",
    });

    const res = try f.format(
        logging.LogLevel.err,
        "ZigLog is the best",
    );

    const expected = "log (ERROR): ZigLog is the best";

    try testing.expectEqualStrings(
        expected,
        res[0..expected.len],
    );
}

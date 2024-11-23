const std = @import("std");
const testing = std.testing;
const formatter = @import("ziglog").formatter;
const logging = @import("ziglog").logging;
const utils = @import("utils.zig");

test "formatter" {
    const f = formatter.Formatter.init(.{});

    const res = try f.format(
        logging.LogLevel.debug,
        "hello",
    );

    const expected = "[DEBUG] hello";

    try testing.expectEqualStrings(
        expected,
        res[0..expected.len],
    );
}

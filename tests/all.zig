const std = @import("std");
const testing = std.testing;

test "all" {
    _ = @import("logging.zig");
    _ = @import("formatter.zig");
}

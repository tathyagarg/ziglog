pub fn eql(comptime T: type, a: []const T, b: []const T) bool {
    if (a.len != b.len) return false;
    if (a.ptr == b.ptr) return true;

    for (a, b) |ia, ib| {
        if (ia != ib) return false;
    }
    return true;
}

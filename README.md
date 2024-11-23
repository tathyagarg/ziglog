# ZigLog
A minimal zig library for logging

## Setting up a logger
ZigLog uses a singleton instance to create a logger. I will probably change this soon, though, as it does add an unnecessary limit to what you can do with ZigLog.
To a get a logger, do:
```zig
const ziglog = @import("ziglog");

pub fn main() void {
  const logger = ziglog.Logger.get(.{});
}
```

When the get method is called for the first time, the options passed to it will be used to initalize a Logger. In subsequent calls, the contents of the options are ignored, and the logger instance is returned.
Since I'm lazy, I didn't feel like implementing anything more than the bare bones (a singleton), but to give you a teeny-tiny bit of control, in possibly the worst possible way, there is a method to 'deinit'/reset the current logger state.
To reset the logger state, we do:
```zig
logger.reset();
```


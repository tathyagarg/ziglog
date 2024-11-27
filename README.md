# ZigLog

<p align="center">
  <img src="assets/logo.png" width="200" />
</p>

**ZigLog** is a flexible and powerful logging library designed for the Zig programming language. The default Zig logging module is simple but not sufficient for more advanced logging needs, which is where **ZigLog** comes in. It provides enhanced logging capabilities, including support for multiple loggers, custom log formatting, and the ability to log to different sinks, such as files and the console.

## Features

- **Multiple Loggers**: Easily create and manage multiple loggers for different parts of your application.
- **Custom Formatters**: Customize log output with custom formatting options.
- **Flexible Sinks**: Switch the logging sink from the console to a file or any other destination.
- **MIT License**: Free to use, modify, and distribute under the MIT license.

## Installation

To use **ZigLog** in your Zig project, follow these steps:

1. Add **ZigLog** as a dependency in your `build.zig` file:

    ```zig
    const ziglog = b.dependency("ziglog", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("ziglog", ziglog.module("ziglog"));
    ```

2. Build your project as usual. **ZigLog** will be included and ready for use.

## Usage

Here's a basic example of how to use **ZigLog** in your project:

```zig
const std = @import("std");
const ziglog = @import("ziglog");


pub fn main() void {
    const logger = try ziglog.Logger.get(.{ .name = "example_logger", .sink = .file, .file = "log.txt" });
    const logger2 = try ziglog.Logger.get(.{ .name = "another_logger" } );
    // Log a message
    logger2.err("This is an error message");
    logger.info("This message will go to the file log.txt");
}
```

In this example:
- Logger.get() creates a new logger instance.
- Log messages can be written at different levels (e.g., info(), err()).
- You can specify the sink to be a file in the options when getting a logger.

More examples can be found in the [examples directory](examples/)

# License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) for details.




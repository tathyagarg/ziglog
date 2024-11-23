const std = @import("std");

const Example = struct {
    name: []const u8,
    source_file: std.Build.LazyPath,
};

pub fn build(b: *std.Build) void {
    const examples = [_]Example{
        .{
            .name = "dir_copier",
            .source_file = b.path("src/dir_copier.zig"),
        },
    };

    const tar = b.standardTargetOptions(.{});
    const opt = b.standardOptimizeOption(.{});

    const ziglog_dep = b.dependency("ziglog", .{
        .target = tar,
        .optimize = opt,
    });

    const ziglog_mod = ziglog_dep.module("ziglog");

    for (examples) |example| {
        const exe = b.addExecutable(.{
            .name = example.name,
            .root_source_file = example.source_file,
            .target = tar,
            .optimize = opt,
        });

        exe.root_module.addImport("ziglog", ziglog_mod);

        b.installArtifact(exe);
    }
}

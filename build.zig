const std = @import("std");

pub fn build(b: *std.Build) !void {
    const mod = b.addModule("ziglog", .{ .root_source_file = b.path("ziglog/src/root.zig") });

    const opt = b.standardOptimizeOption(.{});
    const tar = b.standardTargetOptions(.{});

    const test_step = b.step("test", "Run all tests");
    const tests = b.addTest(.{ .root_source_file = b.path("tests/all.zig"), .target = tar, .optimize = opt });
    tests.root_module.addImport("ziglog", mod);

    const run_tests = b.addRunArtifact(tests);
    test_step.dependOn(&run_tests.step);

    const all_step = b.step("all", "Build everything, run all tests");
    all_step.dependOn(test_step);

    b.default_step.dependOn(all_step);
}

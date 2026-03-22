const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "OpenGLRenderer",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });

    const glfw = b.dependency("glfw_zig", .{
        .target = target,
        .optimize = optimize,
    });

    exe.addCSourceFiles(.{
        .root = b.path("src"),
        .files = &.{"main.c"},
        .flags = &.{ "-Wall", "-Wextra", "-Werror", "-std=c23" },
    });

    exe.addIncludePath(b.path("include"));
    exe.addIncludePath(b.path("thirdparty"));

    exe.linkLibrary(glfw.artifact("glfw"));
    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_cmd.step);
}

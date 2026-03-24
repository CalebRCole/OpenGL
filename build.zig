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

    // Project Files
    exe.addCSourceFiles(.{
        .root = b.path("src"),
        .files = &.{"main.c"},
        .flags = &.{ "-Wall", "-Wextra", "-Werror", "-std=c23" },
    });

    // GLAD
    exe.addIncludePath(b.path("thirdparty/glad/include"));
    exe.addCSourceFile(.{
        .file = b.path("thirdparty/glad/src/glad.c"),
        .flags = &.{"-std=c11"},
    });

    // System Libraries
    if (target.result.os.tag == .windows) {
        exe.linkSystemLibrary("opengl32");
    } else {
        exe.linkSystemLibrary("GL");
    }
    exe.linkSystemLibrary("glfw3");
    exe.linkLibC();

    b.installArtifact(exe);

    // Compile & Run (zig build run)
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_cmd.step);
}

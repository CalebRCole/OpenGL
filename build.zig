const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "OpenGLRenderer",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });

    // Project Files
    exe.root_module.addCSourceFiles(.{
        .root = b.path("src"),
        .files = &.{"main.c"},
        .flags = &.{ "-Wall", "-Wextra", "-std=c23" },
    });

    // GLAD
    exe.root_module.addIncludePath(b.path("thirdparty/glad/include"));
    exe.root_module.addCSourceFile(.{
        .file = b.path("thirdparty/glad/src/glad.c"),
        .flags = &.{"-std=c11"},
    });

    // System Libraries
    if (target.result.os.tag == .windows) {
        exe.root_module.linkSystemLibrary("opengl32", .{});
    } else {
        exe.root_module.linkSystemLibrary("GL", .{});
    }
    exe.root_module.linkSystemLibrary("glfw3", .{});

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

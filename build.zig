const std = @import("std");
const zaudio = @import("libs/zaudio/build.zig");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();
    const exe_options = b.addOptions();
    const content_dir = "./";
    exe_options.addOption([]const u8, "content_dir", content_dir);

    const exe = b.addExecutable("soundtest", "src/main.zig");
    exe.addOptions("build_options", exe_options);

    exe.addPackage(zaudio.pkg);

    zaudio.link(exe);

    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

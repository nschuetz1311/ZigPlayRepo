const Build: type = @import("std").Build;
const Target: type = @import("std").Target;
const CrossTarget: type = @import("std").zig.Target;
const builtin: type = @import("std");

pub fn build(b: *Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.resolveTargetQuery(.{
        .cpu_arch = Target.Cpu.Arch.x86_64,
        .os_tag = Target.Os.Tag.uefi,
        .abi = Target.Abi.msvc,
    });
    const executable = b.addExecutable(.{ .name = "boot", .root_source_file = b.path("main.zig"), .optimize = optimize, .target = target });
    b.installArtifact(executable);
}

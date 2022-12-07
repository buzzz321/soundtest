const std = @import("std");
const zaudio = @import("zaudio");
const content_dir = @import("build_options").content_dir;
const mem = std.mem;

fn simplePlay(allocator: mem.Allocator) !void {
    zaudio.init(allocator);
    defer zaudio.deinit();

    const engine = try zaudio.Engine.create(null);
    defer engine.destroy();

    const music = try engine.createSoundFromFile(
        content_dir ++ "elimination.ogg",
        //content_dir ++ "broke.mp3",
        .{ .flags = .{ .stream = true } },
    );
    defer music.destroy();

    try music.start();

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var buf: [10]u8 = undefined;

    try stdout.print("A number please: ", .{});
    _ = try stdin.readUntilDelimiterOrEof(buf[0..], '\n');

    try music.stop();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const leak = gpa.deinit();
        if (leak) {
            @panic("leak");
        }
    }
    try simplePlay(allocator);
}

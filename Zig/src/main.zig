const std = @import("std");
const net = std.net;
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const address = try net.Ip4Address.parse("127.0.0.1", 53982);
    const localhost = net.Address{ .in = address };
    var server = try localhost.listen(.{});
    defer server.deinit();

    const addr = server.listen_address.getPort();
    print("TCP Running on port {d}\n", .{addr});

    while (true) {
        handle_connection(&server, allocator) catch |err| {
            print("{!}", .{err});
            continue;
        };
    }
}

fn handle_connection(server: *net.Server, allocator: std.mem.Allocator) !void {
    var client = try server.accept();
    defer client.stream.close();

    const message = try client.stream.reader().readAllAlloc(allocator, 1024);
    defer allocator.free(message);

    print("Request: {s}\n", .{message});

    try client.stream.writer().writeAll(message);
}

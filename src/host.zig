const builtin = @import("builtin");
const std = @import("std");
const io = std.io;
const glue = @import("glue");
const RocStr = glue.str.RocStr;

comptime {
    if (builtin.target.cpu.arch != .wasm32) {
        @compileError("This platform is for WebAssembly only. You need to pass `--target wasm32` to the Roc compiler.");
    }
}

const Align = 2 * @alignOf(usize);
extern fn malloc(size: usize) callconv(.C) ?*align(Align) anyopaque;
extern fn realloc(c_ptr: [*]align(Align) u8, size: usize) callconv(.C) ?*anyopaque;
extern fn free(c_ptr: [*]align(Align) u8) callconv(.C) void;
extern fn memcpy(dst: [*]u8, src: [*]u8, size: usize) callconv(.C) void;
extern fn memset(dst: [*]u8, value: i32, size: usize) callconv(.C) void;

export fn roc_alloc(size: usize, alignment: u32) callconv(.C) ?*anyopaque {
    _ = alignment;
    return malloc(size);
}

export fn roc_realloc(c_ptr: *anyopaque, new_size: usize, old_size: usize, alignment: u32) callconv(.C) ?*anyopaque {
    _ = old_size;
    _ = alignment;
    return realloc(@as([*]align(Align) u8, @alignCast(@ptrCast(c_ptr))), new_size);
}

export fn roc_dealloc(c_ptr: *anyopaque, alignment: u32) callconv(.C) void {
    _ = alignment;
    free(@as([*]align(Align) u8, @alignCast(@ptrCast(c_ptr))));
}

// NOTE roc_panic has to be provided by the wasm runtime, so it can throw an exception

extern fn roc__mainForHost_1_exposed_generic([*]u8) void;
extern fn roc__mainForHost_0_result_size() i64;
extern fn roc__mainForHost_1_exposed_size() i64;
extern fn roc__mainForHost_0_caller(*const u8, [*]u8, usize) void;
extern fn roc__mainForHost_0_size() i64;

pub fn main() void {
    // The size might be zero; if so, make it at least 8 so that we don't have a nullptr
    const size = @max(@as(usize, @as(usize, @intCast(roc__mainForHost_1_exposed_size()))), 8);

    const raw_output = roc_alloc(@as(usize, @as(usize, @intCast(size))), @alignOf(u64)).?;
    defer roc_dealloc(raw_output, @alignOf(u64));
    var output = @as([*]u8, @as([*]u8, @ptrCast(raw_output)));

    roc__mainForHost_1_exposed_generic(output);

    const closure_data_pointer = @as([*]u8, @as([*]u8, @ptrCast(output)));

    return call_the_closure(closure_data_pointer);
}

// From: crates/cli_testing_examples/benchmarks/platform/host.zig
fn call_the_closure(closure_data_pointer: [*]u8) void {
    // The size might be zero; if so, make it at least 8 so that we don't have a nullptr
    const size = @max(roc__mainForHost_0_result_size(), 8);
    _ = size;

    // TODO: Deallocate
    // const raw_output = roc_alloc(@as(usize, @intCast(size)), @alignOf(u64)).?;
    // defer roc_dealloc(raw_output, @alignOf(u64));
    // var output = @as([*]u8, @ptrCast(raw_output));

    const flags: u8 = 0;

    roc__mainForHost_0_caller(&flags, closure_data_pointer, 0);
}

export fn roc_fx_stdoutLine(str: *RocStr) void {
    const stdout = io.getStdOut().writer();
    stdout.print("{s}\n", .{str.*.asSlice()}) catch unreachable;
}

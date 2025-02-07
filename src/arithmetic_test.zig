const std = @import("std");
const Cpu = @import("Cpu.zig");
const OpCodes = @import("op_codes.zig").OpCodes;

test "ADC immediate mode - basic addition" {
    var cpu: Cpu = undefined;
    cpu.reset(0xFFFC);
    cpu.memory.reset();

    // Load program: ADC #$10
    cpu.memory.data[0xFFFC] = @intFromEnum(OpCodes.ADC_IM);
    cpu.memory.data[0xFFFD] = 0x10;
    cpu.memory.data[0xFFFE] = @intFromEnum(OpCodes.BRK);

    cpu.reg_A = 0x20; // Initial value in accumulator
    cpu.bit_C = 0; // Clear carry initially

    cpu.execute();

    try std.testing.expectEqual(@as(u8, 0x30), cpu.reg_A); // 0x20 + 0x10 = 0x30
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_C); // No carry
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_Z); // Not zero
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_N); // Not negative
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_V); // No overflow
}

test "ADC immediate mode - with carry" {
    var cpu: Cpu = undefined;
    cpu.reset(0xFFFC);
    cpu.memory.reset();

    cpu.memory.data[0xFFFC] = @intFromEnum(OpCodes.ADC_IM);
    cpu.memory.data[0xFFFD] = 0xFF;
    cpu.memory.data[0xFFFE] = @intFromEnum(OpCodes.BRK);

    cpu.reg_A = 0x02;
    cpu.bit_C = 1; // Set carry

    cpu.execute();

    try std.testing.expectEqual(@as(u8, 0x02), cpu.reg_A); // 0x02 + 0xFF + 1 = 0x102 (0x02)
    try std.testing.expectEqual(@as(u1, 1), cpu.bit_C); // Carry set
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_Z); // Not zero
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_N); // Not negative
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_V); // No overflow
}

test "SBC immediate mode - basic subtraction" {
    var cpu: Cpu = undefined;
    cpu.reset(0xFFFC);
    cpu.memory.reset();

    cpu.memory.data[0xFFFC] = @intFromEnum(OpCodes.SBC_IM);
    cpu.memory.data[0xFFFD] = 0x10;
    cpu.memory.data[0xFFFE] = @intFromEnum(OpCodes.BRK);

    cpu.reg_A = 0x50;
    cpu.bit_C = 1; // Set carry (no borrow)

    cpu.execute();

    try std.testing.expectEqual(@as(u8, 0x40), cpu.reg_A); // 0x50 - 0x10 = 0x40
    try std.testing.expectEqual(@as(u1, 1), cpu.bit_C); // No borrow needed
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_Z); // Not zero
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_N); // Not negative
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_V); // No overflow
}

test "SBC immediate mode - with borrow" {
    var cpu: Cpu = undefined;
    cpu.reset(0xFFFC);
    cpu.memory.reset();

    cpu.memory.data[0xFFFC] = @intFromEnum(OpCodes.SBC_IM);
    cpu.memory.data[0xFFFD] = 0x50;
    cpu.memory.data[0xFFFE] = @intFromEnum(OpCodes.BRK);

    cpu.reg_A = 0x20; // Initial accumulator value: +32 decimal
    cpu.bit_C = 1; // Set carry (no borrow)

    cpu.execute();

    try std.testing.expectEqual(@as(u8, 0xD0), cpu.reg_A); // Result should be -48 decimal
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_C); // Borrow needed
    try std.testing.expectEqual(@as(u1, 1), cpu.bit_N); // Negative
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_V); // No overflow - this is correct signed arithmetic!
}

test "ADC - overflow flag test" {
    var cpu: Cpu = undefined;
    cpu.reset(0xFFFC);
    cpu.memory.reset();

    cpu.memory.data[0xFFFC] = @intFromEnum(OpCodes.ADC_IM);
    cpu.memory.data[0xFFFD] = 0x50;
    cpu.memory.data[0xFFFE] = @intFromEnum(OpCodes.BRK);

    cpu.reg_A = 0x50; // +80 (positive)
    cpu.bit_C = 0; // No carry

    cpu.execute();

    try std.testing.expectEqual(@as(u8, 0xA0), cpu.reg_A); // Result is negative (overflow)
    try std.testing.expectEqual(@as(u1, 0), cpu.bit_C); // No carry
    try std.testing.expectEqual(@as(u1, 1), cpu.bit_N); // Negative
    try std.testing.expectEqual(@as(u1, 1), cpu.bit_V); // Overflow (signed overflow occurred)
}

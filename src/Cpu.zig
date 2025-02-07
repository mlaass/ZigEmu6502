// SPDX-License-Identifier: BSD 2-Clause "Simplified" License
//
// src/Cpu.zig
//
// Created by:	Aakash Sen Sharma, May 2023
// Copyright:	(C) 2023, Aakash Sen Sharma & Contributors

const Self = @This();
const std = @import("std");

const Memory = @import("Memory.zig");
const OpCodes = @import("op_codes.zig").OpCodes;

program_counter: u16 = undefined,
stack_pointer: u8 = undefined,
cycles: i32 = undefined,

memory: Memory = undefined,

reg_A: u8 = undefined, // Accumulator register
reg_X: u8 = undefined,
reg_Y: u8 = undefined,

bit_C: u1 = undefined, // Carry
bit_Z: u1 = undefined, // Zero
bit_I: u1 = undefined, // Interrupt
bit_D: u1 = undefined, // Decimal
bit_B: u1 = undefined, // Break
bit_U: u1 = undefined, // Unused
bit_V: u1 = undefined, // Overflow
bit_N: u1 = undefined, // Negative

pub fn tick(self: *Self) void {
    self.cycles -= 1;
}

pub fn reset(self: *Self, program_counter_addr: u16) void {
    self.program_counter = program_counter_addr;
    self.stack_pointer = 0x0;
    self.reg_A = 0;
    self.reg_X = 0;
    self.reg_Y = 0;
}

/// Set the required bits
fn LDA_set_bits(self: *Self) void {
    self.bit_Z = @intFromBool(self.reg_A == 0);
    self.bit_N = @as(u1, @truncate(self.reg_A & (1 << 7)));
}

/// Set the N and Z flags based on a value
fn set_NZ_flags(self: *Self, value: u8) void {
    self.bit_Z = @intFromBool(value == 0);
    self.bit_N = @as(u1, @truncate(value & (1 << 7)));
}

/// Set the N, Z, V and C flags based on addition result
fn set_add_flags(self: *Self, result: u16, operand1: u8, operand2: u8) void {
    // Carry flag - set if result > 255
    self.bit_C = @intFromBool(result > 0xFF);

    // Zero flag - set if lower 8 bits are zero
    self.bit_Z = @intFromBool((result & 0xFF) == 0);

    // Negative flag - set if bit 7 of the result (after truncation) is set
    self.bit_N = @as(u1, @truncate((result & 0xFF) >> 7));

    // Overflow flag - set if sign of operands was same and result has different sign
    const op1_neg = (operand1 & 0x80) != 0;
    const op2_neg = (operand2 & 0x80) != 0;
    const result_neg = ((result & 0xFF) & 0x80) != 0;
    self.bit_V = @intFromBool((op1_neg == op2_neg) and (op1_neg != result_neg));
}

/// Set the N, Z, V and C flags based on subtraction result
fn set_sub_flags(self: *Self, result: u16, operand1: u8, operand2: u8) void {
    // For SBC, carry flag is inverted from ADC
    self.bit_C = @intFromBool(operand1 >= operand2);

    // Zero flag - set if lower 8 bits are zero
    self.bit_Z = @intFromBool((result & 0xFF) == 0);

    // Negative flag - set if bit 7 of the result (after truncation) is set
    self.bit_N = @as(u1, @truncate((result & 0xFF) >> 7));

    // For 6502 SBC, overflow occurs when the sign of the result is wrong
    // This happens when:
    // - Subtracting a negative from a positive should give positive
    // - Subtracting a positive from a negative should give negative
    const a_neg = (operand1 & 0x80) != 0;
    const m_neg = (operand2 & 0x80) != 0;
    const r_neg = ((result & 0xFF) & 0x80) != 0;
    self.bit_V = @intFromBool((a_neg and !m_neg and !r_neg) or (!a_neg and m_neg and r_neg));
}
/// Set the N, Z, V and C flags based on arithmetic operation result
fn set_arithmetic_flags(self: *Self, result: u16, operand1: u8, operand2: u8) void {
    // Carry flag - set if result > 255
    self.bit_C = @intFromBool(result > 0xFF);

    // Zero flag - set if lower 8 bits are zero
    self.bit_Z = @intFromBool((result & 0xFF) == 0);

    // Negative flag - set if bit 7 of the result (after truncation) is set
    self.bit_N = @as(u1, @truncate((result & 0xFF) >> 7));

    // Overflow flag - set if sign of operands was same and result has different sign
    // We need to look at bit 7 of the truncated 8-bit result
    const op1_neg = (operand1 & 0x80) != 0;
    const op2_neg = (operand2 & 0x80) != 0;
    const result_neg = ((result & 0xFF) & 0x80) != 0;
    self.bit_V = @intFromBool((op1_neg == op2_neg) and (op1_neg != result_neg));
}

pub fn print_internal_state(self: *Self) void {
    std.io.getStdOut().writer().print(
        "Carry={d} Zero={d} Interrupt={d} Decimal={d} Break={d} Overflow={d} Negative={d}\nAccumulator={d} X={d} Y={d}\n",
        .{
            self.bit_C, self.bit_Z, self.bit_I, self.bit_D, self.bit_B, self.bit_V, self.bit_N,
            self.reg_A, self.reg_X, self.reg_Y,
        },
    ) catch unreachable;
}

pub fn execute(self: *Self) void {
    while (true) {
        const opcode = @as(OpCodes, @enumFromInt(self.memory.fetch_data(u8)));
        switch (opcode) {
            OpCodes.BRK => return, // Break/EOF opcode - terminate execution

            OpCodes.LDA_IM => {
                const val = self.memory.fetch_data(u8);
                self.reg_A = val;
                self.LDA_set_bits();
                continue;
            },
            OpCodes.LDA_ABS => {
                const address = self.memory.fetch_data(u16);
                self.reg_A = self.memory.read_data(u8, address);
                self.LDA_set_bits();
                continue;
            },
            OpCodes.LDA_ABS_X => {
                var address = self.memory.fetch_data(u16);
                address += self.reg_X;

                if (self.reg_X >= 0xFF) {
                    self.tick(); // Page boundary cross cycle!
                }

                self.reg_A = self.memory.read_data(u8, address);
                continue;
            },
            OpCodes.LDA_IND_X => {
                var zero_page_addr = self.memory.fetch_data(u8);
                zero_page_addr += self.reg_X;

                self.tick(); // Adding the reg_X value consumes a cycle :)

                const effective_adddr = self.memory.read_data(u16, zero_page_addr);

                self.reg_A = self.memory.read_data(u8, effective_adddr);
                continue;
            },
            OpCodes.LDA_IND_Y => {
                const zero_page_addr = self.memory.fetch_data(u8);
                var effective_addr = self.memory.read_data(u16, zero_page_addr);

                effective_addr += self.reg_Y;

                if (self.reg_Y >= 0xFF) {
                    self.tick(); // Page boundary cross cycle!
                }

                self.reg_A = self.memory.read_data(u8, effective_addr);
                continue;
            },
            OpCodes.LDA_ABS_Y => {
                var address = self.memory.fetch_data(u16);
                address += self.reg_Y;

                if (self.reg_Y >= 0xFF) {
                    self.tick(); // Page boundary cross cycle!
                }

                self.reg_A = self.memory.read_data(u8, address);
                continue;
            },
            OpCodes.LDA_ZP => {
                const address = self.memory.fetch_data(u8);
                self.reg_A = self.memory.read_data(u8, address);
                self.LDA_set_bits();
                continue;
            },
            OpCodes.LDA_ZP_X => {
                var address = self.memory.fetch_data(u8);
                address +%= self.reg_X;
                address &= 0xFF;

                self.reg_A = self.memory.read_data(u8, address);
                self.tick();
                self.LDA_set_bits();
                continue;
            },
            OpCodes.JSR_ABS => {
                const address = self.memory.fetch_data(u16);
                self.memory.write_data(self.program_counter - 1, self.stack_pointer);
                self.stack_pointer += 1;
                self.program_counter = address;
                continue;
            },
            OpCodes.NOP => {
                self.program_counter += 1;
                self.tick();
                continue;
            },
            OpCodes.AND_IM => {
                const value = self.memory.fetch_data(u8);
                self.reg_A &= value;
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.AND_ZP => {
                const addr = self.memory.fetch_data(u8);
                self.reg_A &= self.memory.read_data(u8, addr);
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.AND_ZP_X => {
                var addr = self.memory.fetch_data(u8);
                addr +%= self.reg_X;
                addr &= 0xFF;
                self.reg_A &= self.memory.read_data(u8, addr);
                self.tick();
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.ORA_IM => {
                const value = self.memory.fetch_data(u8);
                self.reg_A |= value;
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.ORA_ZP => {
                const addr = self.memory.fetch_data(u8);
                self.reg_A |= self.memory.read_data(u8, addr);
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.ORA_ZP_X => {
                var addr = self.memory.fetch_data(u8);
                addr +%= self.reg_X;
                addr &= 0xFF;
                self.reg_A |= self.memory.read_data(u8, addr);
                self.tick();
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.EOR_IM => {
                const value = self.memory.fetch_data(u8);
                self.reg_A ^= value;
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.EOR_ZP => {
                const addr = self.memory.fetch_data(u8);
                self.reg_A ^= self.memory.read_data(u8, addr);
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.EOR_ZP_X => {
                var addr = self.memory.fetch_data(u8);
                addr +%= self.reg_X;
                addr &= 0xFF;
                self.reg_A ^= self.memory.read_data(u8, addr);
                self.tick();
                self.set_NZ_flags(self.reg_A);
                continue;
            },
            OpCodes.ADC_IM => {
                const value = self.memory.fetch_data(u8);
                const result = @as(u16, self.reg_A) + value + self.bit_C;
                self.set_add_flags(result, self.reg_A, value);
                self.reg_A = @truncate(result);
                continue;
            },
            OpCodes.ADC_ZP => {
                const addr = self.memory.fetch_data(u8);
                const value = self.memory.read_data(u8, addr);
                const result = @as(u16, self.reg_A) + value + self.bit_C;
                self.set_add_flags(result, self.reg_A, value);
                self.reg_A = @truncate(result);
                continue;
            },
            OpCodes.ADC_ZP_X => {
                var addr = self.memory.fetch_data(u8);
                addr +%= self.reg_X;
                addr &= 0xFF;
                const value = self.memory.read_data(u8, addr);
                const result = @as(u16, self.reg_A) + value + self.bit_C;
                self.set_add_flags(result, self.reg_A, value);
                self.reg_A = @truncate(result);
                self.tick();
                continue;
            },
            OpCodes.SBC_IM => {
                const value = self.memory.fetch_data(u8);
                // On 6502, SBC A,M is implemented as A - M - !C
                // We need to invert the carry flag for subtraction
                const borrow = 1 - self.bit_C;
                const result = @as(u16, self.reg_A) -% value -% borrow;
                self.set_sub_flags(result, self.reg_A, value);
                self.reg_A = @truncate(result);
                continue;
            },
            OpCodes.SBC_ZP => {
                const addr = self.memory.fetch_data(u8);
                const value = self.memory.read_data(u8, addr);
                const result = @as(u16, self.reg_A) -% value -% (1 -% self.bit_C);
                self.set_sub_flags(result, self.reg_A, value);
                self.reg_A = @truncate(result);
                continue;
            },
            OpCodes.SBC_ZP_X => {
                var addr = self.memory.fetch_data(u8);
                addr +%= self.reg_X;
                addr &= 0xFF;
                const value = self.memory.read_data(u8, addr);
                const result = @as(u16, self.reg_A) -% value -% (1 -% self.bit_C);
                self.set_sub_flags(result, self.reg_A, value);
                self.reg_A = @truncate(result);
                self.tick();
                continue;
            },
            else => {
                @panic("Opcode not handled");
            },
        }
    }
}

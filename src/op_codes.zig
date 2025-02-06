// SPDX-License-Identifier: BSD 2-Clause "Simplified" License
//
// src/OpCodes.zig
//
// Created by:	Aakash Sen Sharma, May 2023
// Copyright:	(C) 2023, Aakash Sen Sharma & Contributors

pub const OpCodes = enum(u16) {
    // Tested op-codes are marked with "*"
    // zig fmt: off

    /// Load Accumulator - Immediate     (A = M)
    /// Flags: N Z
    LDA_IM      = 0xA9, // *

    /// Load Accumulator - Zero Page     (A = M)
    /// Flags: N Z
    LDA_ZP      = 0xA5, // *

    /// Load Accumulator - Zero Page,X   (A = M)
    /// Flags: N Z
    LDA_ZP_X    = 0xB5, // *

    /// Load Accumulator - Absolute      (A = M)
    /// Flags: N Z
    LDA_ABS     = 0xAD, // *

    /// Load Accumulator - Absolute,X    (A = M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    LDA_ABS_X   = 0xBD, // *

    /// Load Accumulator - Absolute,Y    (A = M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    LDA_ABS_Y   = 0xB9, // *

    /// Load Accumulator - (Indirect,X)  (A = M)
    /// Flags: N Z
    LDA_IND_X   = 0xA1, // *

    /// Load Accumulator - (Indirect),Y  (A = M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    LDA_IND_Y   = 0xB1, // *

    /// Jump - Absolute                  (PC = a)
    /// No flags affected
    JMP_ABS     = 0x4C,

    /// Jump - Indirect                  (PC = [a])
    /// No flags affected
    JMP_IND     = 0x6C,

    /// Jump to Subroutine - Absolute    (PC = a, push PC+2)
    /// No flags affected
    JSR_ABS     = 0x20, // *

    /// No Operation
    /// No flags affected
    NOP         = 0xEA, // *

    /// Break / Force Interrupt          (Push PC+2, Push SR)
    /// Flags: B=1, I=1
    BRK         = 0x00, // *

    // Logical AND Operations
    /// AND Accumulator - Immediate      (A = A & M)
    /// Flags: N Z
    AND_IM      = 0x29, // *

    /// AND Accumulator - Zero Page      (A = A & M)
    /// Flags: N Z
    AND_ZP      = 0x25, // *

    /// AND Accumulator - Zero Page,X    (A = A & M)
    /// Flags: N Z
    AND_ZP_X    = 0x35, // *

    /// AND Accumulator - Absolute       (A = A & M)
    /// Flags: N Z
    AND_ABS     = 0x2D, // *

    /// AND Accumulator - Absolute,X     (A = A & M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    AND_ABS_X   = 0x3D, // *

    /// AND Accumulator - Absolute,Y     (A = A & M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    AND_ABS_Y   = 0x39, // *

    /// AND Accumulator - (Indirect,X)   (A = A & M)
    /// Flags: N Z
    AND_IND_X   = 0x21, // *

    /// AND Accumulator - (Indirect),Y   (A = A & M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    AND_IND_Y   = 0x31, // *

    // Logical OR Operations
    /// OR Accumulator - Immediate       (A = A | M)
    /// Flags: N Z
    ORA_IM      = 0x09, // *

    /// OR Accumulator - Zero Page       (A = A | M)
    /// Flags: N Z
    ORA_ZP      = 0x05, // *

    /// OR Accumulator - Zero Page,X     (A = A | M)
    /// Flags: N Z
    ORA_ZP_X    = 0x15, // *

    /// OR Accumulator - Absolute        (A = A | M)
    /// Flags: N Z
    ORA_ABS     = 0x0D, // *

    /// OR Accumulator - Absolute,X      (A = A | M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    ORA_ABS_X   = 0x1D, // *

    /// OR Accumulator - Absolute,Y      (A = A | M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    ORA_ABS_Y   = 0x19, // *

    /// OR Accumulator - (Indirect,X)    (A = A | M)
    /// Flags: N Z
    ORA_IND_X   = 0x01, // *

    /// OR Accumulator - (Indirect),Y    (A = A | M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    ORA_IND_Y   = 0x11, // *

    // Exclusive OR Operations
    /// XOR Accumulator - Immediate      (A = A ^ M)
    /// Flags: N Z
    EOR_IM      = 0x49, // *

    /// XOR Accumulator - Zero Page      (A = A ^ M)
    /// Flags: N Z
    EOR_ZP      = 0x45, // *

    /// XOR Accumulator - Zero Page,X    (A = A ^ M)
    /// Flags: N Z
    EOR_ZP_X    = 0x55, // *

    /// XOR Accumulator - Absolute       (A = A ^ M)
    /// Flags: N Z
    EOR_ABS     = 0x4D, // *

    /// XOR Accumulator - Absolute,X     (A = A ^ M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    EOR_ABS_X   = 0x5D, // *

    /// XOR Accumulator - Absolute,Y     (A = A ^ M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    EOR_ABS_Y   = 0x59, // *

    /// XOR Accumulator - (Indirect,X)   (A = A ^ M)
    /// Flags: N Z
    EOR_IND_X   = 0x41, // *

    /// XOR Accumulator - (Indirect),Y   (A = A ^ M)
    /// Flags: N Z
    /// +1 cycle if page boundary crossed
    EOR_IND_Y   = 0x51, // *
    // zig fmt: on
};

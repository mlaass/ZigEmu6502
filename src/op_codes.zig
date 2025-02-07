// SPDX-License-Identifier: BSD 2-Clause "Simplified" License
//
// src/OpCodes.zig
//
// Created by:	Aakash Sen Sharma, May 2023
// Copyright:	(C) 2023, Aakash Sen Sharma & Contributors

pub const OpCodes = enum(u8) {
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

    // =======================================================================
    // Missing Opcodes (Not Yet Implemented)

    // =======================================================================

    // --- Arithmetic Operations ---
    // ADC - Add with Carry
    /// Add with Carry - Immediate      (A = A + M + C)
    /// Flags: N V Z C
    ADC_IM      = 0x69,

    /// Add with Carry - Zero Page     (A = A + M + C)
    /// Flags: N V Z C
    ADC_ZP      = 0x65,

    /// Add with Carry - Zero Page,X   (A = A + M + C)
    /// Flags: N V Z C
    ADC_ZP_X    = 0x75,

    /// Add with Carry - Absolute      (A = A + M + C)
    /// Flags: N V Z C
    ADC_ABS     = 0x6D,

    /// Add with Carry - Absolute,X    (A = A + M + C)
    /// Flags: N V Z C
    /// +1 cycle if page boundary crossed
    ADC_ABS_X   = 0x7D,

    /// Add with Carry - Absolute,Y    (A = A + M + C)
    /// Flags: N V Z C
    /// +1 cycle if page boundary crossed
    ADC_ABS_Y   = 0x79,

    /// Add with Carry - (Indirect,X)  (A = A + M + C)
    /// Flags: N V Z C
    ADC_IND_X   = 0x61,

    /// Add with Carry - (Indirect),Y  (A = A + M + C)
    /// Flags: N V Z C
    /// +1 cycle if page boundary crossed
    ADC_IND_Y   = 0x71,

    // SBC - Subtract with Carry
    /// Subtract with Carry - Immediate (A = A - M - !C)
    /// Flags: N V Z C
    SBC_IM      = 0xE9,

    /// Subtract with Carry - Zero Page (A = A - M - !C)
    /// Flags: N V Z C
    SBC_ZP      = 0xE5,

    /// Subtract with Carry - Zero Page,X (A = A - M - !C)
    /// Flags: N V Z C
    SBC_ZP_X    = 0xF5,

    /// Subtract with Carry - Absolute  (A = A - M - !C)
    /// Flags: N V Z C
    SBC_ABS     = 0xED,

    /// Subtract with Carry - Absolute,X (A = A - M - !C)
    /// Flags: N V Z C
    /// +1 cycle if page boundary crossed
    SBC_ABS_X   = 0xFD,

    /// Subtract with Carry - Absolute,Y (A = A - M - !C)
    /// Flags: N V Z C
    /// +1 cycle if page boundary crossed
    SBC_ABS_Y   = 0xF9,

    /// Subtract with Carry - (Indirect,X) (A = A - M - !C)
    /// Flags: N V Z C
    SBC_IND_X   = 0xE1,

    /// Subtract with Carry - (Indirect),Y (A = A - M - !C)
    /// Flags: N V Z C
    /// +1 cycle if page boundary crossed
    SBC_IND_Y   = 0xF1,

    //--- Bit and Logical Shift Operations ---
    // BIT - Bit Test
    //   BIT_ZP      = 0x24    // Zero Page
    //   BIT_ABS     = 0x2C    // Absolute

    // ASL - Arithmetic Shift Left
    //   ASL_A       = 0x0A    // Accumulator
    //   ASL_ZP      = 0x06    // Zero Page
    //   ASL_ZP_X    = 0x16    // Zero Page, X-Indexed
    //   ASL_ABS     = 0x0E    // Absolute
    //   ASL_ABS_X   = 0x1E    // Absolute, X-Indexed

    // LSR - Logical Shift Right
    //   LSR_A       = 0x4A    // Accumulator
    //   LSR_ZP      = 0x46    // Zero Page
    //   LSR_ZP_X    = 0x56    // Zero Page, X-Indexed
    //   LSR_ABS     = 0x4E    // Absolute
    //   LSR_ABS_X   = 0x5E    // Absolute, X-Indexed

    // ROL - Rotate Left
    //   ROL_A       = 0x2A    // Accumulator
    //   ROL_ZP      = 0x26    // Zero Page
    //   ROL_ZP_X    = 0x36    // Zero Page, X-Indexed
    //   ROL_ABS     = 0x2E    // Absolute
    //   ROL_ABS_X   = 0x3E    // Absolute, X-Indexed

    // ROR - Rotate Right
    //   ROR_A       = 0x6A    // Accumulator
    //   ROR_ZP      = 0x66    // Zero Page
    //   ROR_ZP_X    = 0x76    // Zero Page, X-Indexed
    //   ROR_ABS     = 0x6E    // Absolute
    //   ROR_ABS_X   = 0x7E    // Absolute, X-Indexed

    // --- Branch Instructions ---
    // BCC - Branch if Carry Clear        = 0x90
    // BCS - Branch if Carry Set          = 0xB0
    // BEQ - Branch if Equal (Zero Set)     = 0xF0
    // BNE - Branch if Not Equal (Zero Clear)= 0xD0
    // BMI - Branch if Minus (Negative Set) = 0x30
    // BPL - Branch if Plus (Negative Clear)= 0x10
    // BVC - Branch if Overflow Clear       = 0x50
    // BVS - Branch if Overflow Set         = 0x70

    // --- Processor Status Operations ---
    // CLC - Clear Carry Flag              = 0x18
    // CLD - Clear Decimal Mode            = 0xD8
    // CLI - Clear Interrupt Disable       = 0x58
    // CLV - Clear Overflow Flag           = 0xB8
    // SEC - Set Carry Flag                = 0x38
    // SED - Set Decimal Mode              = 0xF8
    // SEI - Set Interrupt Disable         = 0x78

    // --- Compare Instructions ---
    // CMP - Compare Accumulator
    //   CMP_IM      = 0xC9    // Immediate
    //   CMP_ZP      = 0xC5    // Zero Page
    //   CMP_ZP_X    = 0xD5    // Zero Page, X-Indexed
    //   CMP_ABS     = 0xCD    // Absolute
    //   CMP_ABS_X   = 0xDD    // Absolute, X-Indexed
    //   CMP_ABS_Y   = 0xD9    // Absolute, Y-Indexed
    //   CMP_IND_X   = 0xC1    // (Indirect, X)
    //   CMP_IND_Y   = 0xD1    // (Indirect), Y

    // CPX - Compare X Register
    //   CPX_IM      = 0xE0    // Immediate
    //   CPX_ZP      = 0xE4    // Zero Page
    //   CPX_ABS     = 0xEC    // Absolute

    // CPY - Compare Y Register
    //   CPY_IM      = 0xC0    // Immediate
    //   CPY_ZP      = 0xC4    // Zero Page
    //   CPY_ABS     = 0xCC    // Absolute

    // --- Decrement/Increment ---
    // DEC - Decrement Memory
    //   DEC_ZP      = 0xC6    // Zero Page
    //   DEC_ZP_X    = 0xD6    // Zero Page, X-Indexed
    //   DEC_ABS     = 0xCE    // Absolute
    //   DEC_ABS_X   = 0xDE    // Absolute, X-Indexed

    // INC - Increment Memory
    //   INC_ZP      = 0xE6    // Zero Page
    //   INC_ZP_X    = 0xF6    // Zero Page, X-Indexed
    //   INC_ABS     = 0xEE    // Absolute
    //   INC_ABS_X   = 0xFE    // Absolute, X-Indexed

    // DEX - Decrement X Register           = 0xCA
    // DEY - Decrement Y Register           = 0x88
    // INX - Increment X Register           = 0xE8
    // INY - Increment Y Register           = 0xC8

    // --- Stack Operations ---
    // PHA - Push Accumulator               = 0x48
    // PHP - Push Processor Status          = 0x08
    // PLA - Pull Accumulator               = 0x68
    // PLP - Pull Processor Status          = 0x28

    // --- Transfer Operations ---
    // TAX - Transfer Accumulator to X      = 0xAA
    // TAY - Transfer Accumulator to Y      = 0xA8
    // TXA - Transfer X to Accumulator      = 0x8A
    // TYA - Transfer Y to Accumulator      = 0x98
    // TSX - Transfer Stack Pointer to X    = 0xBA
    // TXS - Transfer X to Stack Pointer    = 0x9A

    // --- Subroutine and Interrupt ---
    // RTI - Return from Interrupt          = 0x40
    // RTS - Return from Subroutine         = 0x60

    // =======================================================================
    // End of Missing Opcodes
    // =======================================================================

};

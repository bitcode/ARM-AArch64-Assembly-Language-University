# ARM AArch64 Instruction Quick Reference

This quick reference provides the most commonly used ARM AArch64 instructions organized by category for easy lookup during exercises.

## 📋 Data Movement Instructions

### Basic Data Transfer
```assembly
mov   Xd, Xn          # Move register to register
mov   Xd, #imm        # Move immediate to register
mvn   Xd, Xn          # Move NOT (bitwise complement)
```

### Load/Store Instructions
```assembly
ldr   Xd, [Xn]        # Load register from memory
ldr   Xd, [Xn, #imm]  # Load with immediate offset
str   Xd, [Xn]        # Store register to memory
str   Xd, [Xn, #imm]  # Store with immediate offset

# Size variants
ldrb  Wd, [Xn]        # Load byte (8-bit)
ldrh  Wd, [Xn]        # Load halfword (16-bit)
ldrsb Xd, [Xn]        # Load signed byte
ldrsh Xd, [Xn]        # Load signed halfword
ldrsw Xd, [Xn]        # Load signed word
```

### Addressing Modes
```assembly
ldr   Xd, [Xn, #imm]!    # Pre-indexed (update base)
ldr   Xd, [Xn], #imm     # Post-indexed (update base)
ldr   Xd, [Xn, Xm]       # Register offset
ldr   Xd, [Xn, Xm, LSL #2] # Scaled register offset
```

## 🔢 Arithmetic Instructions

### Basic Arithmetic
```assembly
add   Xd, Xn, Xm      # Add registers
add   Xd, Xn, #imm    # Add immediate
sub   Xd, Xn, Xm      # Subtract registers
sub   Xd, Xn, #imm    # Subtract immediate
mul   Xd, Xn, Xm      # Multiply
udiv  Xd, Xn, Xm      # Unsigned divide
sdiv  Xd, Xn, Xm      # Signed divide
```

### Arithmetic with Flags
```assembly
adds  Xd, Xn, Xm      # Add and set flags
subs  Xd, Xn, Xm      # Subtract and set flags
cmp   Xn, Xm          # Compare (subtract and set flags)
cmn   Xn, Xm          # Compare negative (add and set flags)
```

### Extended Arithmetic
```assembly
adc   Xd, Xn, Xm      # Add with carry
sbc   Xd, Xn, Xm      # Subtract with carry
madd  Xd, Xn, Xm, Xa  # Multiply-add (Xd = Xa + Xn*Xm)
msub  Xd, Xn, Xm, Xa  # Multiply-subtract (Xd = Xa - Xn*Xm)
```

## 🔀 Logical Instructions

### Bitwise Operations
```assembly
and   Xd, Xn, Xm      # Bitwise AND
orr   Xd, Xn, Xm      # Bitwise OR
eor   Xd, Xn, Xm      # Bitwise XOR (exclusive OR)
bic   Xd, Xn, Xm      # Bit clear (AND NOT)
orn   Xd, Xn, Xm      # OR NOT
eon   Xd, Xn, Xm      # XOR NOT
```

### Logical with Flags
```assembly
ands  Xd, Xn, Xm      # AND and set flags
tst   Xn, Xm          # Test (AND and set flags)
```

### Shift and Rotate
```assembly
lsl   Xd, Xn, #imm    # Logical shift left
lsr   Xd, Xn, #imm    # Logical shift right
asr   Xd, Xn, #imm    # Arithmetic shift right
ror   Xd, Xn, #imm    # Rotate right
```

## 🔄 Control Flow Instructions

### Unconditional Branches
```assembly
b     label           # Branch to label
bl    label           # Branch with link (call function)
br    Xn              # Branch to register
blr   Xn              # Branch with link to register
ret                   # Return (branch to LR)
ret   Xn              # Return to register
```

### Conditional Branches
```assembly
b.eq  label           # Branch if equal (Z=1)
b.ne  label           # Branch if not equal (Z=0)
b.lt  label           # Branch if less than (N≠V)
b.le  label           # Branch if less than or equal
b.gt  label           # Branch if greater than
b.ge  label           # Branch if greater than or equal
b.cs  label           # Branch if carry set (unsigned >=)
b.cc  label           # Branch if carry clear (unsigned <)
b.mi  label           # Branch if minus (N=1)
b.pl  label           # Branch if plus (N=0)
b.vs  label           # Branch if overflow (V=1)
b.vc  label           # Branch if no overflow (V=0)
```

### Compare and Branch
```assembly
cbz   Xn, label       # Compare and branch if zero
cbnz  Xn, label       # Compare and branch if not zero
tbz   Xn, #bit, label # Test bit and branch if zero
tbnz  Xn, #bit, label # Test bit and branch if not zero
```

## 🏗️ System Instructions

### System Calls
```assembly
svc   #imm            # Supervisor call (system call)
hvc   #imm            # Hypervisor call
smc   #imm            # Secure monitor call
```

### Barriers and Synchronization
```assembly
dmb   sy              # Data memory barrier
dsb   sy              # Data synchronization barrier
isb                   # Instruction synchronization barrier
```

### Special Instructions
```assembly
nop                   # No operation
brk   #imm            # Breakpoint
hlt   #imm            # Halt
wfe                   # Wait for event
wfi                   # Wait for interrupt
sev                   # Send event
```

## 📊 Condition Codes

### Condition Code Flags (NZCV)
- **N**: Negative flag (bit 31 of result)
- **Z**: Zero flag (result is zero)
- **C**: Carry flag (unsigned overflow)
- **V**: Overflow flag (signed overflow)

### Condition Mnemonics
| Code | Meaning | Flags |
|------|---------|-------|
| EQ | Equal | Z=1 |
| NE | Not equal | Z=0 |
| CS/HS | Carry set / Unsigned higher or same | C=1 |
| CC/LO | Carry clear / Unsigned lower | C=0 |
| MI | Minus / Negative | N=1 |
| PL | Plus / Positive or zero | N=0 |
| VS | Overflow set | V=1 |
| VC | Overflow clear | V=0 |
| HI | Unsigned higher | C=1 && Z=0 |
| LS | Unsigned lower or same | C=0 \|\| Z=1 |
| GE | Signed greater than or equal | N=V |
| LT | Signed less than | N≠V |
| GT | Signed greater than | Z=0 && N=V |
| LE | Signed less than or equal | Z=1 \|\| N≠V |
| AL | Always | Any |

## 🎯 Register Reference

### General Purpose Registers
- **X0-X30**: 64-bit general purpose registers
- **W0-W30**: 32-bit views of X0-X30 (lower 32 bits)
- **XZR/WZR**: Zero register (always reads as 0)

### Special Purpose Registers
- **SP**: Stack pointer
- **PC**: Program counter (not directly accessible)
- **LR (X30)**: Link register
- **FP (X29)**: Frame pointer (by convention)

### Register Usage Conventions
| Registers | Purpose | Preserved across calls |
|-----------|---------|----------------------|
| X0-X7 | Argument/result registers | No |
| X8 | Indirect result register | No |
| X9-X15 | Temporary registers | No |
| X16-X17 | Intra-procedure-call registers | No |
| X18 | Platform register | Platform specific |
| X19-X28 | Callee-saved registers | Yes |
| X29 | Frame pointer | Yes |
| X30 | Link register | Special |

## 💡 Common Patterns

### Function Prologue
```assembly
stp   x29, x30, [sp, #-16]!  # Save frame pointer and link register
mov   x29, sp                # Set up frame pointer
```

### Function Epilogue
```assembly
ldp   x29, x30, [sp], #16    # Restore frame pointer and link register
ret                          # Return to caller
```

### Loop Pattern
```assembly
mov   x0, #10                # Initialize counter
loop:
    # Loop body here
    subs  x0, x0, #1         # Decrement and set flags
    b.ne  loop               # Branch if not zero
```

### Conditional Assignment
```assembly
cmp   x0, x1                 # Compare values
csel  x2, x3, x4, gt         # x2 = (x0 > x1) ? x3 : x4
```

---

**Need more details?** Refer to the [ARM Architecture Reference Manual](../../Aarch64-Architecture-Reference-Manual-for-A-profile/) or use your LLM research assistant to explore specific instructions in depth.
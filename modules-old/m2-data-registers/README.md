# Module 2: Data & Registers

> **ARM® Trademark Notice**: ARM® is a registered trademark of Arm Limited
> (or its subsidiaries) in the US and/or elsewhere. This educational content
> references ARM® technology for educational purposes only.

> **Educational Disclaimer**: This is an independent educational resource
> not affiliated with or endorsed by Arm Limited.

**Duration**: Weeks 2-3
**Prerequisites**: Module 1 completed, basic ARM® assembly understanding
**Difficulty**: Beginner to Intermediate

## 🎯 Learning Objectives

By the end of this module, you will:

1. **Master Register Usage Patterns**
   - Understand general-purpose register organization
   - Apply register naming conventions (X vs W registers)
   - Implement efficient register allocation strategies

2. **Understand Data Types and Representations**
   - Work with different data sizes (8, 16, 32, 64-bit)
   - Handle signed and unsigned integer representations
   - Apply proper data alignment principles

3. **Implement Data Manipulation Operations**
   - Perform arithmetic and logical operations
   - Use bitwise operations effectively
   - Handle data conversion and type casting

4. **Apply Memory Addressing Modes**
   - Use immediate, register, and memory addressing
   - Implement pre/post-indexing techniques
   - Optimize memory access patterns

## 📚 Key Concepts

### Register Architecture
- **General-Purpose Registers**: X0-X30 (64-bit) and W0-W30 (32-bit)
- **Special Registers**: Stack Pointer (SP), Program Counter (PC)
- **Zero Register**: XZR/WZR for constant zero values
- **Register Aliases**: Link Register (LR), Frame Pointer (FP)

### Data Types and Sizes
- **Byte Operations**: 8-bit data manipulation
- **Halfword Operations**: 16-bit data handling
- **Word Operations**: 32-bit processing
- **Doubleword Operations**: 64-bit computations

### Addressing Modes
- **Immediate Addressing**: Constants embedded in instructions
- **Register Addressing**: Data stored in registers
- **Memory Addressing**: Direct and indirect memory access
- **Indexed Addressing**: Base + offset calculations

## 🛠️ Exercises

### Lesson 2.1: Register Fundamentals
- **[2.1-registers-beginner.s](exercises/2.1-registers-beginner.s)** - Register naming and usage
- **[2.1-sizes-beginner.s](exercises/2.1-sizes-beginner.s)** - Data size operations
- **[2.1-zero-intermediate.s](exercises/2.1-zero-intermediate.s)** - Zero register applications

### Lesson 2.2: Data Operations
- **[2.2-arithmetic-beginner.s](exercises/2.2-arithmetic-beginner.s)** - Basic arithmetic operations
- **[2.2-logical-beginner.s](exercises/2.2-logical-beginner.s)** - Logical and bitwise operations
- **[2.2-shifts-intermediate.s](exercises/2.2-shifts-intermediate.s)** - Shift and rotate operations

### Lesson 2.3: Memory Addressing
- **[2.3-immediate-beginner.s](exercises/2.3-immediate-beginner.s)** - Immediate addressing modes
- **[2.3-memory-intermediate.s](exercises/2.3-memory-intermediate.s)** - Memory addressing patterns
- **[2.3-indexing-advanced.s](exercises/2.3-indexing-advanced.s)** - Advanced indexing techniques

## 📖 Required Reading

### ARM® Architecture Reference Manual Sections
- **B1.2**: AArch64 application level registers
- **C1.2**: Data types and alignment
- **C2.1**: Instruction encoding overview
- **C3.3**: Load and store instructions (basic patterns)

## 🎯 Learning Checkpoints

### Week 2 Goals
- [ ] Understand register organization and naming conventions
- [ ] Master basic data manipulation operations
- [ ] Complete exercises 2.1.* (all beginner level)
- [ ] Demonstrate effective ARM® manual navigation

### Week 3 Goals
- [ ] Apply complex addressing modes effectively
- [ ] Optimize register usage in programs
- [ ] Complete exercises 2.2.* and 2.3.* (including intermediate)
- [ ] Connect data concepts to real-world applications

## 🤖 LLM Research Prompts

### Register Understanding
```
I'm learning about ARM® AArch64 registers. Can you guide me through understanding the relationship between X and W registers and help me explore when to use each type?
```

### Data Type Exploration
```
Help me understand how ARM® AArch64 handles different data sizes. What ARM® manual sections should I explore to understand data alignment requirements?
```

### Addressing Mode Analysis
```
I'm working with ARM addressing modes. Can you help me develop a systematic approach to choosing the most efficient addressing mode for different scenarios?
```

## 🚀 Next Steps

After completing Module 2, you'll be ready for **[Module 3: Control Flow](../m3-control-flow/)**, where you'll learn:
- Conditional execution and branching
- Loop implementation strategies
- Control flow optimization techniques

---

**Ready to dive into data and registers?** Start with [exercise 2.1-registers-beginner.s](exercises/2.1-registers-beginner.s) to explore ARM register fundamentals.
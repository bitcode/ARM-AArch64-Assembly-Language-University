# Module 3: Basic Instruction Set

> **ARM® Trademark Notice**: ARM® is a registered trademark of Arm Limited
> (or its subsidiaries) in the US and/or elsewhere. This educational content
> references ARM® technology for educational purposes only.

> **Educational Disclaimer**: This is an independent educational resource
> not affiliated with or endorsed by Arm Limited.

**Duration**: Weeks 4-5
**Prerequisites**: Modules 1-2 completed, understanding of registers and data types
**Difficulty**: Intermediate

## 🎯 Learning Objectives

By the end of this module, you will:

1. **Master Arithmetic Instructions**
   - Implement addition, subtraction, multiplication operations
   - Handle overflow and underflow conditions
   - Apply arithmetic optimizations and shortcuts

2. **Apply Logical Operations**
   - Use bitwise AND, OR, XOR, and NOT operations
   - Implement bit manipulation techniques
   - Create efficient logical operation patterns

3. **Implement Bit Manipulation**
   - Perform shift and rotate operations
   - Extract and insert bit fields
   - Apply bit manipulation for optimization

4. **Understand Instruction Encoding**
   - Analyze instruction formats and encoding
   - Understand immediate value limitations
   - Apply encoding knowledge for optimization

## 📚 Key Concepts

### Arithmetic Instructions
- **Basic Operations**: ADD, SUB, MUL, DIV instructions
- **Extended Operations**: MADD, MSUB for multiply-accumulate
- **Condition Flags**: NZCV flags and their usage
- **Overflow Handling**: Signed vs unsigned arithmetic

### Logical Operations
- **Bitwise Operations**: AND, ORR, EOR, BIC instructions
- **Logical Shifts**: LSL, LSR, ASR operations
- **Bit Testing**: TST and comparison operations
- **Immediate Operands**: Logical immediate encoding

### Bit Manipulation
- **Shift Operations**: Logical and arithmetic shifts
- **Rotate Operations**: ROR and rotate with extend
- **Bit Field Operations**: UBFX, SBFX, BFI, BFXIL
- **Count Operations**: CLZ, CLS for bit counting

### Instruction Formats
- **Register Format**: Three-register operations
- **Immediate Format**: Register-immediate operations
- **Shifted Register**: Register with shift operations
- **Extended Register**: Register with extension

## 🛠️ Exercises

### Lesson 3.1: Arithmetic Operations
- **[3.1-addition-beginner.s](exercises/3.1-addition-beginner.s)** - Basic addition operations
- **[3.1-subtraction-beginner.s](exercises/3.1-subtraction-beginner.s)** - Subtraction and negation
- **[3.1-multiplication-intermediate.s](exercises/3.1-multiplication-intermediate.s)** - Multiplication techniques
- **[3.1-overflow-intermediate.s](exercises/3.1-overflow-intermediate.s)** - Overflow detection and handling

### Lesson 3.2: Logical Operations
- **[3.2-bitwise-beginner.s](exercises/3.2-bitwise-beginner.s)** - AND, OR, XOR operations
- **[3.2-masks-beginner.s](exercises/3.2-masks-beginner.s)** - Bit masking techniques
- **[3.2-logical-intermediate.s](exercises/3.2-logical-intermediate.s)** - Complex logical patterns
- **[3.2-immediate-intermediate.s](exercises/3.2-immediate-intermediate.s)** - Logical immediate values

### Lesson 3.3: Bit Manipulation
- **[3.3-shifts-beginner.s](exercises/3.3-shifts-beginner.s)** - Basic shift operations
- **[3.3-rotates-intermediate.s](exercises/3.3-rotates-intermediate.s)** - Rotation operations
- **[3.3-bitfields-advanced.s](exercises/3.3-bitfields-advanced.s)** - Bit field extraction and insertion
- **[3.3-counting-advanced.s](exercises/3.3-counting-advanced.s)** - Bit counting algorithms

### Lesson 3.4: Instruction Optimization
- **[3.4-encoding-intermediate.s](exercises/3.4-encoding-intermediate.s)** - Understanding instruction encoding
- **[3.4-immediate-advanced.s](exercises/3.4-immediate-advanced.s)** - Immediate value optimization
- **[3.4-patterns-advanced.s](exercises/3.4-patterns-advanced.s)** - Efficient instruction patterns

## 📖 Required Reading

### ARM® Architecture Reference Manual Sections
- **C3.4**: Data processing instructions
- **C3.5**: Arithmetic instructions (ADD, SUB, etc.)
- **C3.6**: Logical instructions (AND, ORR, etc.)
- **C3.7**: Shift and bit manipulation instructions
- **C2.3**: Instruction encoding formats

### Additional Resources
- [ARM Instruction Set Quick Reference](../../resources/quick-reference/instructions.md)
- [Bit Manipulation Techniques Guide](../../resources/optimization/bit-manipulation.md)
- [Arithmetic Optimization Patterns](../../resources/optimization/arithmetic.md)

## 🎯 Learning Checkpoints

### Week 4 Goals
- [ ] Master basic arithmetic operations (ADD, SUB, MUL)
- [ ] Understand condition flag usage and testing
- [ ] Complete exercises 3.1.* and 3.2.* (beginner level)
- [ ] Apply logical operations for bit manipulation

### Week 5 Goals
- [ ] Implement complex bit manipulation algorithms
- [ ] Optimize instruction usage for performance
- [ ] Complete exercises 3.3.* and 3.4.* (including advanced)
- [ ] Understand instruction encoding implications

## 🤖 LLM Research Prompts

### Arithmetic Understanding
```
I'm learning ARM® AArch64 arithmetic instructions. Can you guide me through understanding how condition flags work and help me explore the ARM® manual sections that explain overflow detection?
```

### Logical Operations Exploration
```
Help me understand ARM logical instructions and immediate value encoding. What ARM® manual sections should I study to understand the limitations and optimizations of logical immediate values?
```

### Bit Manipulation Mastery
```
I want to master ARM bit manipulation instructions. Can you help me develop a systematic approach to choosing between different bit field operations and understanding their performance characteristics?
```

### Instruction Optimization
```
Guide me through understanding ARM instruction encoding to help me write more efficient assembly code. What patterns should I look for in the ARM® manual to understand instruction selection trade-offs?
```

## 📊 Assessment Criteria

### Knowledge Assessment
- Understanding of arithmetic and logical instruction families
- Comprehension of condition flags and their applications
- Knowledge of bit manipulation techniques and optimizations

### Practical Skills
- Writing efficient arithmetic and logical operations
- Implementing bit manipulation algorithms
- Optimizing instruction selection for performance

### Research Skills
- Navigating ARM® manual instruction reference sections
- Understanding instruction encoding documentation
- Applying optimization principles from manual guidance

## 🚀 Next Steps

After completing Module 3, you'll be ready for **[Module 4: Memory Access & Data Structures](../m4-memory-data-structures/)**, where you'll learn:
- Load and store instruction families
- Memory addressing modes and optimization
- Data structure implementation in assembly

---

**Ready to master the instruction set?** Begin with [exercise 3.1-addition-beginner.s](exercises/3.1-addition-beginner.s) to explore ARM arithmetic operations.
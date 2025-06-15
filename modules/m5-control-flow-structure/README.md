# Module 5: Control Flow & Program Structure

> **ARM® Trademark Notice**: ARM® is a registered trademark of Arm Limited
> (or its subsidiaries) in the US and/or elsewhere. This educational content
> references ARM® technology for educational purposes only.

> **Educational Disclaimer**: This is an independent educational resource
> not affiliated with or endorsed by Arm Limited.

**Duration**: Weeks 8-9
**Prerequisites**: Modules 1-4 completed, understanding of memory access and data structures
**Difficulty**: Intermediate to Advanced

## 🎯 Learning Objectives

By the end of this module, you will:

1. **Master Conditional Execution**
   - Implement all ARM® conditional branch instructions
   - Use condition codes and flags effectively
   - Apply conditional execution for optimization

2. **Design Efficient Loop Structures**
   - Implement for, while, and do-while loops
   - Apply loop optimization techniques
   - Use loop unrolling and vectorization strategies

3. **Implement Function Calls**
   - Apply ARM® calling conventions correctly
   - Manage stack frames and local variables
   - Handle parameter passing and return values

4. **Structure Complex Programs**
   - Organize code into logical modules
   - Implement proper program flow control
   - Apply software engineering principles in assembly

## 📚 Key Concepts

### Conditional Execution
- **Condition Codes**: NZCV flags and their meanings
- **Branch Instructions**: B, BL, BR, BLR variants
- **Conditional Branches**: B.EQ, B.NE, B.LT, B.GE, etc.
- **Compare Instructions**: CMP, CMN, TST for flag setting

### Loop Structures
- **Counting Loops**: For-loop implementations
- **Conditional Loops**: While and do-while patterns
- **Loop Optimization**: Strength reduction and unrolling
- **Branch Prediction**: Writing prediction-friendly loops

### Function Implementation
- **Calling Conventions**: AAPCS64 standard compliance
- **Stack Management**: Frame pointer and stack pointer usage
- **Parameter Passing**: Register and stack parameter handling
- **Return Mechanisms**: Function return and value passing

### Program Organization
- **Code Sections**: .text, .data, .bss organization
- **Symbol Management**: Global and local symbol usage
- **Modular Design**: Function decomposition strategies
- **Error Handling**: Exception and error management

## 🛠️ Exercises

### Lesson 5.1: Conditional Execution
- **[5.1-conditions-beginner.s](exercises/5.1-conditions-beginner.s)** - Basic conditional branches
- **[5.1-flags-beginner.s](exercises/5.1-flags-beginner.s)** - Condition flag usage
- **[5.1-compare-intermediate.s](exercises/5.1-compare-intermediate.s)** - Compare and test operations
- **[5.1-optimization-intermediate.s](exercises/5.1-optimization-intermediate.s)** - Conditional optimization

### Lesson 5.2: Loop Implementation
- **[5.2-counting-beginner.s](exercises/5.2-counting-beginner.s)** - Basic counting loops
- **[5.2-while-beginner.s](exercises/5.2-while-beginner.s)** - While loop patterns
- **[5.2-nested-intermediate.s](exercises/5.2-nested-intermediate.s)** - Nested loop structures
- **[5.2-unrolling-advanced.s](exercises/5.2-unrolling-advanced.s)** - Loop unrolling techniques

### Lesson 5.3: Function Fundamentals
- **[5.3-simple-beginner.s](exercises/5.3-simple-beginner.s)** - Simple function calls
- **[5.3-parameters-intermediate.s](exercises/5.3-parameters-intermediate.s)** - Parameter passing
- **[5.3-stack-intermediate.s](exercises/5.3-stack-intermediate.s)** - Stack frame management
- **[5.3-recursion-advanced.s](exercises/5.3-recursion-advanced.s)** - Recursive functions

### Lesson 5.4: Advanced Function Concepts
- **[5.4-variadic-advanced.s](exercises/5.4-variadic-advanced.s)** - Variable argument functions
- **[5.4-callbacks-advanced.s](exercises/5.4-callbacks-advanced.s)** - Function pointers and callbacks
- **[5.4-optimization-expert.s](exercises/5.4-optimization-expert.s)** - Function call optimization
- **[5.4-conventions-expert.s](exercises/5.4-conventions-expert.s)** - Calling convention mastery

### Lesson 5.5: Program Structure
- **[5.5-modules-intermediate.s](exercises/5.5-modules-intermediate.s)** - Modular program design
- **[5.5-linking-advanced.s](exercises/5.5-linking-advanced.s)** - Multi-file programs
- **[5.5-libraries-advanced.s](exercises/5.5-libraries-advanced.s)** - Library integration
- **[5.5-architecture-expert.s](exercises/5.5-architecture-expert.s)** - Software architecture

## 📖 Required Reading

### ARM® Architecture Reference Manual Sections
- **C3.1**: Branch instructions
- **C3.2**: Conditional execution
- **C1.3**: Condition codes and flags
- **C5**: Procedure call standard (AAPCS64)
- **B1.3**: Stack pointer and frame management

### Additional Resources
- [ARM Calling Conventions Guide](../../resources/conventions/calling-conventions.md)
- [Loop Optimization Techniques](../../resources/optimization/loops.md)
- [Program Structure Patterns](../../resources/patterns/program-structure.md)

## 🎯 Learning Checkpoints

### Week 8 Goals
- [ ] Master conditional execution and branching
- [ ] Implement efficient loop structures
- [ ] Complete exercises 5.1.* and 5.2.* (beginner/intermediate)
- [ ] Understand condition flag usage patterns

### Week 9 Goals
- [ ] Implement complex function call patterns
- [ ] Design well-structured assembly programs
- [ ] Complete exercises 5.3.*, 5.4.*, and 5.5.* (including advanced)
- [ ] Apply software engineering principles to assembly

## 🤖 LLM Research Prompts

### Control Flow Understanding
```
I'm learning ARM control flow instructions. Can you guide me through understanding condition codes and help me explore which ARM® manual sections explain branch prediction and optimization strategies?
```

### Loop Optimization Exploration
```
Help me understand ARM loop implementation and optimization techniques. What ARM® manual sections should I study to understand branch prediction and loop unrolling strategies?
```

### Function Call Mastery
```
I want to master ARM function calling conventions. Can you help me develop a systematic approach to understanding AAPCS64 and guide me through the relevant ARM® manual sections?
```

### Program Structure Design
```
Guide me through designing well-structured ARM® assembly programs. What software engineering principles apply to assembly programming, and how can I organize complex assembly projects?
```

## 📊 Assessment Criteria

### Knowledge Assessment
- Understanding of conditional execution and control flow
- Comprehension of ARM® calling conventions and stack management
- Knowledge of loop optimization and program structure principles

### Practical Skills
- Implementing efficient control flow patterns
- Writing well-structured functions with proper conventions
- Designing modular and maintainable assembly programs

### Research Skills
- Navigating ARM® manual sections on control flow and procedures
- Understanding performance implications of control flow decisions
- Applying optimization principles from ARM documentation

## 🚀 Next Steps

After completing Module 5, you'll be ready for **[Module 6: Advanced AArch64 Features](../m6-advanced-features/)**, where you'll learn:
- SIMD/NEON programming for parallel processing
- Floating-point operations and optimization
- System-level programming concepts

---

**Ready to master control flow?** Begin with [exercise 5.1-conditions-beginner.s](exercises/5.1-conditions-beginner.s) to explore ARM® conditional execution fundamentals.
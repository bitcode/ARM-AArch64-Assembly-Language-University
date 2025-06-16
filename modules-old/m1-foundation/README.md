# Module 1: Foundation & Setup

> **ARM® Trademark Notice**: ARM® is a registered trademark of Arm Limited
> (or its subsidiaries) in the US and/or elsewhere. This educational content
> references ARM® technology for educational purposes only.

> **Educational Disclaimer**: This is an independent educational resource
> not affiliated with or endorsed by Arm Limited.

**Duration**: Weeks 1-2
**Prerequisites**: Basic programming experience, computer science fundamentals
**Difficulty**: Beginner to Intermediate

## 🎯 Learning Objectives

By the end of this module, you will:

1. **Understand ARM® AArch64 Architecture Basics**
   - Recognize the role of ARM® processors in modern computing
   - Identify key architectural features of AArch64
   - Understand the relationship between assembly and machine code

2. **Set Up Development Environment**
   - Install and configure ARM® development toolchain
   - Set up cross-compilation environment
   - Verify toolchain functionality with test programs

3. **Write Your First Assembly Programs**
   - Create basic "Hello World" assembly program
   - Understand program structure and syntax
   - Compile, link, and execute assembly code

4. **Navigate ARM Documentation**
   - Use the ARM® Architecture Reference Manual effectively
   - Locate instruction specifications and examples
   - Understand documentation conventions and terminology

## 📚 Key Concepts

### Architecture Fundamentals
- **AArch64 vs AArch32**: Understanding the 64-bit ARM® architecture
- **Execution States**: Exception levels and privilege modes
- **Register Overview**: General-purpose, special-purpose, and system registers
- **Memory Model**: Virtual memory, address translation basics

### Development Workflow
- **Toolchain Components**: Assembler, linker, debugger, emulator
- **Cross-Compilation**: Developing on x86 for ARM® targets
- **Build Process**: From source code to executable binary
- **Testing Strategies**: Emulation vs hardware testing

### Assembly Language Basics
- **Syntax Conventions**: GNU assembler syntax and directives
- **Program Structure**: Sections, labels, and symbol management
- **Basic Instructions**: Data movement, arithmetic, control flow
- **Calling Conventions**: Function calls and system interactions

## 🛠️ Exercises

### Lesson 1.1: Environment Setup
- **[1.1-hello-beginner.s](exercises/1.1-hello-beginner.s)** - Your first assembly program
- **[1.1-toolchain-beginner.s](exercises/1.1-toolchain-beginner.s)** - Verify toolchain installation

### Lesson 1.2: Basic Program Structure
- **[1.2-structure-beginner.s](exercises/1.2-structure-beginner.s)** - Understanding program sections
- **[1.2-comments-beginner.s](exercises/1.2-comments-beginner.s)** - Documentation and comments
- **[1.2-labels-intermediate.s](exercises/1.2-labels-intermediate.s)** - Working with labels and symbols

### Lesson 1.3: First Instructions
- **[1.3-move-beginner.s](exercises/1.3-move-beginner.s)** - Data movement instructions
- **[1.3-arithmetic-beginner.s](exercises/1.3-arithmetic-beginner.s)** - Basic arithmetic operations
- **[1.3-registers-intermediate.s](exercises/1.3-registers-intermediate.s)** - Register usage patterns

## 📖 Required Reading

### ARM® Architecture Reference Manual Sections
- **A1.1**: About the AArch64 architecture
- **A1.2**: AArch64 architectural concepts
- **B1.1**: The AArch64 application level view
- **C1.1**: Introduction to the AArch64 instruction set

### Additional Resources
- [GNU Assembler Manual](https://sourceware.org/binutils/docs/as/) - Syntax reference
- [ARM Developer Documentation](https://developer.arm.com/documentation/) - Official guides
- [Compiler Explorer](https://godbolt.org/) - Online assembly exploration

## 🔧 Setup Instructions

### 1. Install Development Tools

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install gcc-aarch64-linux-gnu
sudo apt install qemu-user-static
```

**macOS:**
```bash
brew install aarch64-elf-gcc
brew install qemu
```

**Windows (WSL2):**
```bash
# Install WSL2 with Ubuntu
# Then follow Linux instructions above
```

### 2. Verify Installation
```bash
# Check compiler
aarch64-linux-gnu-gcc --version

# Check emulator
qemu-aarch64-static --version
```

### 3. Test Your Setup
```bash
# Navigate to module directory
cd modules/m1-foundation/exercises

# Assemble and run first program
aarch64-linux-gnu-as -o hello.o 1.1-hello-beginner.s
aarch64-linux-gnu-ld -o hello hello.o
qemu-aarch64-static hello
```

## 🎯 Learning Checkpoints

### Week 1 Goals
- [ ] Complete development environment setup
- [ ] Successfully compile and run first assembly program
- [ ] Understand basic program structure and syntax
- [ ] Complete exercises 1.1.* (all beginner level)

### Week 2 Goals
- [ ] Master basic instruction usage
- [ ] Understand register allocation concepts
- [ ] Navigate ARM® manual effectively
- [ ] Complete exercises 1.2.* and 1.3.* (including intermediate)

## 🤖 LLM Research Prompts

Use these prompts with your IDE's LLM chat feature:

### Architecture Understanding
```
I'm learning ARM® AArch64 assembly language. Can you help me understand the key differences between AArch64 and x86-64 architectures? Focus on register organization and instruction encoding.
```

### Toolchain Setup
```
I'm setting up an ARM® AArch64 development environment on [your platform]. Can you guide me through the cross-compilation toolchain setup and explain each component's role?
```

### Code Analysis
```
I have this ARM® assembly code: [paste your code]. Can you help me understand what each instruction does and suggest improvements for clarity or efficiency?
```

## 📊 Assessment Criteria

### Knowledge Assessment
- Understanding of ARM® architecture fundamentals
- Ability to set up and use development toolchain
- Comprehension of assembly language syntax and structure

### Practical Skills
- Writing syntactically correct assembly programs
- Using development tools effectively
- Debugging basic compilation and runtime issues

### Research Skills
- Navigating ARM documentation independently
- Using LLM assistance effectively for learning
- Asking productive questions about unfamiliar concepts

## 🚀 Next Steps

After completing Module 1, you'll be ready for **[Module 2: Data & Registers](../m2-data-registers/)**, where you'll dive deeper into:
- Register usage patterns and conventions
- Data types and memory addressing modes
- More complex data manipulation instructions

---

**Ready to start?** Begin with the [setup instructions](#setup-instructions) above, then tackle your first exercise: [`1.1-hello-beginner.s`](exercises/1.1-hello-beginner.s)
# Module 1: Foundation

**Duration**: 2 weeks  
**Difficulty**: Beginner

## 🎯 Learning Objectives

- Understand ARM AArch64 architecture basics
- Set up development environment  
- Write first assembly programs
- Navigate ARM documentation

## 🛠️ Exercises

- **[hello.s](exercises/hello.s)** - Your first "Hello World" program
- **[registers.s](exercises/registers.s)** - Basic register manipulation
- **[arithmetic.s](exercises/arithmetic.s)** - Simple math operations

## 🚀 Quick Start

```bash
# Copy and edit an exercise
cp m1/exercises/hello.s my-hello.s

# Build and run
../build.sh my-hello.s && qemu-aarch64-static ./my-hello
```

## 📖 Key Concepts

- Program structure (.data, .text sections)
- System calls (sys_write, sys_exit)
- Basic instructions (mov, add, sub)
- Register usage patterns

## ✅ Success Criteria

- [ ] Complete all three exercises
- [ ] Understand program compilation process
- [ ] Can modify and test assembly programs independently

---

**Next**: [Module 2: Data & Registers](../m2/)
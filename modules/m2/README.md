# Module 2: Data & Registers

**Duration**: 2 weeks  
**Difficulty**: Intermediate

## 🎯 Learning Objectives

- Master different data types and sizes
- Understand memory addressing modes
- Practice register allocation strategies
- Work with arrays and pointers

## 🛠️ Exercises

- **[data-types.s](exercises/data-types.s)** - Working with bytes, words, and quads
- **[addressing.s](exercises/addressing.s)** - Memory addressing modes

## 🚀 Quick Start

```bash
# Copy and edit an exercise
cp m2/exercises/data-types.s my-data-types.s

# Build and run
../build.sh my-data-types.s && qemu-aarch64-static ./my-data-types
```

## 📖 Key Concepts

- Data sizes (.byte, .hword, .word, .quad)
- Load/store instructions (ldr, str, ldrb, strb)
- Addressing modes (base, offset, indexed)
- Memory layout and alignment

## ✅ Success Criteria

- [ ] Understand different data type declarations
- [ ] Can use various addressing modes effectively
- [ ] Comfortable with load/store operations

---

**Previous**: [Module 1: Foundation](../m1/) | **Next**: [Module 3: Instructions](../m3/)
# Module 3: Basic Instruction Set - Exercise Files

This directory contains the base exercise files for Module 3. These files provide guided learning experiences for ARM's fundamental instruction set.

## 🎯 Module 3 Focus

These exercises guide you through:
- **Arithmetic operations** and their variations
- **Logical operations** and bit manipulation
- **Comparison instructions** and flag usage
- **Instruction formats** and encoding patterns

## 📋 Exercise Structure

Each exercise file follows the guided learning pattern:
- **Instruction-specific objectives** for each operation type
- **ARM manual references** for detailed instruction documentation
- **Progressive complexity** from basic to advanced usage
- **Performance considerations** and optimization hints

## 🔒 Course Content Zone

**Important**: These files are part of the **Course Content Zone**:
- ❌ **Do NOT modify** these files directly
- ✅ **Copy to your student-work directory** before editing
- 🔄 **Course updates** may add new exercises or improve existing ones
- 🛡️ **Your work is protected** in the student workspace

## 🚀 How to Use These Exercises

### Step 1: Copy to Your Workspace
```bash
# Navigate to your student workspace
cd modules/m3-basic-instruction-set/student-work/exercises/

# Copy the exercise file
cp ../../exercises/3.1-arithmetic-beginner.s 3.1-my-solution.s
```

### Step 2: Work on Your Solution
Focus on understanding:
- Instruction syntax and operand formats
- Immediate vs register operands
- Condition codes and flag effects
- Instruction variants and optimizations

### Step 3: Test and Analyze
```bash
# Build and test your solution
aarch64-linux-gnu-gcc -static 3.1-my-solution.s -o arithmetic
qemu-aarch64-static ./arithmetic

# Analyze the generated code
objdump -d arithmetic
```

## 📚 Key Learning Areas

Module 3 exercises emphasize:
- **Instruction Mastery** - Understanding each instruction's behavior
- **Operand Formats** - Register, immediate, and shifted operands
- **Flag Management** - Condition codes and their applications
- **Code Efficiency** - Choosing optimal instructions for tasks

---

**Prerequisites**: Complete Modules 1-2 before starting Module 3.

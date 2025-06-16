# Module 2: Data & Registers - Exercise Files

This directory contains the base exercise files for Module 2. These files provide guided learning experiences for data manipulation and register usage patterns.

## 🎯 Module 2 Focus

These exercises guide you through:
- **Register usage patterns** and naming conventions
- **Data types** and their ARM assembly representations
- **Memory addressing modes** and data movement
- **Arithmetic operations** with different data sizes

## 📋 Exercise Structure

Each exercise file follows the guided learning pattern:
- **Clear learning objectives** for register and data concepts
- **ARM manual references** for authoritative information
- **Step-by-step guidance** without providing solutions
- **Practical hints** for common register usage patterns

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
cd modules/m2-data-registers/student-work/exercises/

# Copy the exercise file
cp ../../exercises/2.1-register-basics-beginner.s 2.1-my-solution.s
```

### Step 2: Work on Your Solution
Focus on understanding:
- X vs W register naming (64-bit vs 32-bit)
- Register allocation strategies
- Data movement patterns
- Memory addressing modes

### Step 3: Test and Validate
```bash
# Build and test your solution
aarch64-linux-gnu-gcc -static 2.1-my-solution.s -o registers
qemu-aarch64-static ./registers
```

## 📚 Key Learning Areas

Module 2 exercises emphasize:
- **Register Management** - Efficient use of ARM's 31 general-purpose registers
- **Data Types** - Working with different data sizes and formats
- **Memory Operations** - Load/store instructions and addressing modes
- **Calling Conventions** - Understanding register usage in function calls

---

**Prerequisites**: Complete Module 1 exercises before starting Module 2.

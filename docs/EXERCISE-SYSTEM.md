# ARM Assembly Exercise System

This document describes the guided exercise system for the ARM AArch64 Assembly Language University course.

## 🎯 Philosophy

The exercise system balances **guidance** with **self-reliance**:
- **Guided Learning**: Clear objectives, step-by-step instructions, and ARM manual references
- **Student Independence**: No boilerplate code - students write everything from scratch
- **Progressive Difficulty**: Exercises scale from beginner to expert level
- **Research Integration**: Direct links to ARM documentation for deep understanding

## 📁 Directory Structure

```
modules/
├── m1-foundation/
│   ├── exercises/                    # 🔒 Course Content Zone
│   │   ├── README.md                 # Module-specific exercise guide
│   │   ├── 1.1-hello-beginner.s     # Guided exercise files
│   │   └── 1.2-structure-beginner.s
│   └── student-work/                 # ✏️ Student Workspace Zone
│       └── exercises/                # Student solutions go here
├── m2-data-registers/
│   ├── exercises/                    # 🔒 Course Content Zone
│   └── student-work/exercises/       # ✏️ Student Workspace Zone
└── ...
```

## 🔒 Course Content vs Student Workspace

### Course Content Zone (Protected)
- **Location**: `modules/*/exercises/`
- **Purpose**: Base exercise files with guidance
- **Access**: Read-only for students
- **Updates**: Managed through course update system
- **Content**: Guided exercise files with comments and instructions

### Student Workspace Zone (Full Control)
- **Location**: `modules/*/student-work/exercises/`
- **Purpose**: Student solutions and implementations
- **Access**: Full read/write for students
- **Updates**: Never overwritten by course updates
- **Content**: Student-created solution files

## 🚀 Student Workflow

### 1. Copy Exercise File
```bash
# Navigate to student workspace
cd modules/m1-foundation/student-work/exercises/

# Copy the guided exercise file
cp ../../exercises/1.1-hello-beginner.s 1.1-hello-my-solution.s
```

### 2. Follow Guidance
- Read learning objectives and ARM manual references
- Follow step-by-step instructions in comments
- Use hints to understand concepts without getting solutions
- Write all code implementation from scratch

### 3. Implement Solution
- Students write 100% of the actual code
- No boilerplate or starter code provided
- Guided comments provide direction and context
- ARM manual references support deep learning

### 4. Test and Iterate
```bash
# Build and test solution
aarch64-linux-gnu-gcc -static 1.1-hello-my-solution.s -o hello
qemu-aarch64-static ./hello
```

### 5. Commit Work
```bash
# Commit to personal-work branch
git add 1.1-hello-my-solution.s
git commit -m "Complete exercise 1.1 - hello world solution"
```

## 📋 Exercise File Structure

Each guided exercise file contains:

### Header Section
```assembly
// File: 1.1-hello-beginner.s
// ARM AArch64 Assembly Language University
// Module 1: Foundation & Setup
// Exercise 1.1: Hello World - Your First Assembly Program
//
// Learning Objectives:
// - Understand basic ARM assembly program structure
// - Learn about program sections (.text, .data)
// - Practice using system calls for output
//
// ARM Manual References:
// - Section A1.1: About the AArch64 architecture
// - Section C1.1: Introduction to the A64 instruction set
//
// Prerequisites:
// - Completed development environment setup
```

### YAML Metadata Block
```yaml
/*
YAML Metadata Block:
---
exercise_info:
  module: "m1-foundation"
  lesson: "1.1"
  title: "Hello World - Your First Assembly Program"
  difficulty: "beginner"
  estimated_time: "30-45 minutes"
  learning_objectives:
    - "Write a complete ARM assembly program"
    - "Use system calls for output"
  arm_manual_sections:
    - "A1.1: About the AArch64 architecture"
  prerequisites:
    - "Development environment setup complete"
---
*/
```

### Instructions Section
```assembly
// ============================================================================
// EXERCISE INSTRUCTIONS
// ============================================================================
//
// Your task: Create a program that prints "Hello, ARM Assembly!" to the console
//
// Steps to complete this exercise:
// 1. Set up the program sections (.text and .data)
// 2. Define your message string in the data section
// 3. Implement the main program logic
// 4. Use system calls to output the message
// 5. Properly exit the program
//
// Key concepts to explore:
// - Program entry point (_start)
// - Data section for string storage
// - System call numbers and conventions
// - Register usage for system calls
//
// Testing your solution:
// 1. Assemble: aarch64-linux-gnu-gcc -static your-solution.s -o hello
// 2. Run: qemu-aarch64-static ./hello
// 3. Expected output: "Hello, ARM Assembly!"
//
// ============================================================================

// TODO: Add your solution below this line
// Remember: Copy this file to your student-work/exercises/ directory first!

// Hint: You'll need these sections:
// - .data section for your message string
// - .text section for your program code
// - _start label as your program entry point

// Hint: Useful system calls for this exercise:
// - sys_write (system call number 64)
// - sys_exit (system call number 93)
```

## 🎚️ Difficulty Levels

### Beginner
- **Detailed step-by-step instructions**
- **Extensive hints and guidance**
- **Clear expected outcomes**
- **Basic concepts introduction**

### Intermediate
- **General guidance with key concepts**
- **Moderate hints for direction**
- **Some problem-solving required**
- **Building on previous knowledge**

### Advanced
- **Minimal guidance, focus on objectives**
- **Complex implementation challenges**
- **Performance considerations**
- **Integration of multiple concepts**

### Expert
- **Open-ended research challenges**
- **Minimal instruction, maximum exploration**
- **Real-world problem solving**
- **Innovation and optimization focus**

## 🔄 Git Workflow Integration

The exercise system integrates seamlessly with the existing Git workflow:

### Course Updates
- New exercises added to `modules/*/exercises/`
- Improved guidance in existing exercises
- Student work in `student-work/` remains untouched
- Automatic conflict resolution protects student solutions

### Backup System
- Student solutions automatically backed up
- Course content updates don't affect student work
- Recovery options available if needed

### Branch Management
- Course content on `main` branch
- Student work on `personal-work` branch
- Clean separation prevents conflicts

## 🛠️ Tool Integration

The exercise system works with existing course tools:

### Validation
- Exercise metadata enables automated validation
- Learning objective tracking
- Progress monitoring

### Build System
- Exercise files work with existing build tools
- Consistent naming conventions
- Automated testing support

### Documentation
- ARM manual integration
- Automatic reference linking
- Learning path tracking

## 📚 Educational Benefits

### For Students
- **Clear Direction**: Know what to learn and why
- **Self-Reliance**: Write all code independently
- **Deep Learning**: ARM manual integration
- **Progressive Growth**: Difficulty scales appropriately

### For Instructors
- **Consistent Structure**: Standardized exercise format
- **Easy Updates**: Improve guidance without affecting student work
- **Progress Tracking**: Metadata enables monitoring
- **Scalable Content**: Easy to add new exercises

## 🚀 Next Steps

1. **Create sample exercises** for Module 1 to demonstrate the approach
2. **Design exercise templates** for efficient content creation
3. **Update workflow documentation** to reflect the new system
4. **Test integration** with existing Git workflow

---

This exercise system provides the perfect balance of guidance and independence, supporting student learning while maintaining the educational value of writing code from scratch.

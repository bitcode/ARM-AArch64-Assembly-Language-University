# ARM Assembly Course

**Learn ARM AArch64 assembly language programming through hands-on exercises**

```
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║     █████╗ ██████╗ ███╗   ███╗     █████╗ ███████╗███╗   ███╗ ║
    ║    ██╔══██╗██╔══██╗████╗ ████║    ██╔══██╗██╔════╝████╗ ████║ ║
    ║    ███████║██████╔╝██╔████╔██║    ███████║███████╗██╔████╔██║ ║
    ║    ██╔══██║██╔══██╗██║╚██╔╝██║    ██╔══██║╚════██║██║╚██╔╝██║ ║
    ║    ██║  ██║██║  ██║██║ ╚═╝ ██║    ██║  ██║███████║██║ ╚═╝ ██║ ║
    ║    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ║
    ║                                                               ║
    ║                    ASSEMBLY COURSE                           ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
```

## 🚀 Quick Start

**Fork → Setup → Start Coding in 5 minutes!**

### Step 1: Fork and Clone
```bash
# 1. Fork this repository on GitHub
# 2. Clone your fork
git clone <your-fork-url>
cd ARM-AArch64-Assembly-Language-University
```

### Step 2: Run Setup Script
```bash
# This handles everything: git workflow, tools, environment
./tools/setup/setup.sh
```

### Step 3: Start Coding!
```bash
# Go to Module 1
cd modules/m1-foundation/exercises

# Copy the first exercise
cp 1.1-hello-beginner.s my-hello.s

# Edit the file and look for: ★ START HERE ★
# Build your code
../../../build.sh my-hello.s

# Run your program
qemu-aarch64-static ./my-hello
```

**That's it! You're coding ARM assembly in minutes, not hours.**

## 🎯 What You'll Learn

**Master ARM AArch64 assembly language through hands-on exercises**

- **Write ARM assembly programs** from simple "Hello World" to complex applications
- **Understand ARM architecture** - registers, memory model, instruction set
- **Use system calls** to interact with the operating system
- **Debug and optimize** assembly code for performance
- **Interface with C/C++** to build real-world applications

### 🌟 Why This Course Works

- **Visual Learning**: Clear ASCII art markers show exactly where to start coding
- **No Cognitive Overload**: Minimal documentation, maximum hands-on practice
- **Immediate Results**: Fork → setup → coding in under 5 minutes
- **Self-Reliance**: Comment-based guidance without giving away solutions
- **Progressive Difficulty**: Start simple, build complexity naturally

## 📚 Course Modules

**8 modules, each building on the previous one**

| Module | Focus | What You'll Build |
|--------|-------|-------------------|
| **M1** | Foundation & Setup | Hello World, basic programs |
| **M2** | Data & Registers | Data manipulation, register usage |
| **M3** | Basic Instructions | Arithmetic, logical operations |
| **M4** | Memory & Data | Arrays, structures, memory access |
| **M5** | Control Flow | Loops, conditionals, functions |
| **M6** | Advanced Features | SIMD, floating-point, system calls |
| **M7** | Optimization | Performance tuning, debugging |
| **M8** | Applications | Real-world projects, portfolio |

### 🎯 Exercise Structure

Each exercise follows this pattern:
- **Clear visual markers** showing exactly where to start coding
- **Comment-based guidance** without giving away solutions
- **Progressive difficulty** from beginner to expert
- **Immediate feedback** through build and test cycle

**Example exercise workflow:**
1. Copy exercise file: `cp 1.1-hello-beginner.s my-hello.s`
2. Edit file and find: `★ START HERE ★`
3. Write your code following the guidance comments
4. Build: `./build.sh my-hello.s`
5. Run: `qemu-aarch64-static ./my-hello`

## 🛠️ Requirements

**What you need before starting:**

- **Basic programming experience** (any language - C, Python, Java, etc.)
- **Linux, macOS, or Windows with WSL2**
- **Command line familiarity**
- **Text editor** (VS Code, vim, nano, etc.)

**The setup script handles everything else automatically!**

## 🔧 Build Commands

**Simple commands for everyday use:**

```bash
# Build any assembly file
./build.sh <filename.s>

# Run your program
qemu-aarch64-static ./<program_name>

# Example workflow
cp 1.1-hello-beginner.s my-hello.s
./build.sh my-hello.s
qemu-aarch64-static ./my-hello
```

## 🤝 Getting Help

**If you get stuck:**

1. **Check the exercise comments** - they contain helpful hints
2. **Try the ARM Manual sections** referenced in each exercise
3. **Ask in GitHub Discussions** - the community is helpful
4. **Look at other exercises** for similar patterns

**Remember: Learning assembly takes practice. Don't get discouraged!**

## 🎯 Learning Tips

**How to succeed in this course:**

- **Start simple** - don't skip the early exercises
- **Copy and modify** - learn by changing working examples
- **Read the comments** - they contain essential guidance
- **Practice regularly** - assembly skills build through repetition
- **Ask questions** - the community is here to help

## 📖 ARM Manual Integration

**This course references the official ARM Architecture Reference Manual:**
- Each exercise links to specific manual sections
- Learn to navigate professional documentation
- Build skills for real-world ARM development

**Key sections you'll use:**
- **A1.1**: Architecture overview
- **C1.1**: Instruction set introduction
- **C3.x**: Specific instruction details
- **C6.2**: System call interface

## 🌟 What's Next?

**Ready to start your ARM assembly journey?**

1. **Fork this repository**
2. **Run the setup script**: `./tools/setup/setup.sh`
3. **Start coding**: `cd modules/m1-foundation/exercises`

## 📞 Support

- **Questions?** Open a GitHub Discussion
- **Found a bug?** Create an Issue
- **Want to contribute?** Submit a Pull Request

---

**ARM® is a registered trademark of Arm Limited. This educational resource is provided under fair use principles.**

*Happy coding! 🚀*
# Getting Started with ARM AArch64 Assembly Language University

**Welcome to your comprehensive journey into ARM AArch64 assembly language programming!**

This guide will help you set up your learning environment and begin your systematic exploration of ARM assembly language using our innovative DREAM methodology.

## 🎯 What You'll Achieve

By completing this course, you will:
- **Master ARM AArch64 Architecture**: Deep understanding of registers, instruction set, and memory models
- **Write Production-Quality Assembly Code**: Apply optimization techniques and professional practices
- **Navigate ARM Documentation Independently**: Effectively use official ARM resources
- **Integrate Assembly with Modern Development**: Interface with C/C++ and development workflows
- **Build a Professional Portfolio**: Demonstrate expertise through real-world projects

## 📋 Prerequisites Check

Before starting, ensure you have:

### Required Background
- [ ] **Programming Experience**: Familiarity with at least one programming language
- [ ] **Computer Science Fundamentals**: Understanding of variables, functions, and basic algorithms
- [ ] **Computer Architecture Basics**: Knowledge of CPU, memory, and instruction execution concepts

### Technical Requirements
- [ ] **Computer with Internet Access**: For downloading tools and accessing documentation
- [ ] **Administrative Privileges**: To install development tools
- [ ] **Text Editor or IDE**: Preferably with LLM integration (VS Code, Cursor, etc.)
- [ ] **Terminal/Command Line Access**: Basic comfort with command-line operations

## 🛠️ Environment Setup

### Step 1: Choose Your Platform

#### Linux (Recommended)
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install gcc-aarch64-linux-gnu qemu-user-static gdb-multiarch

# Fedora/RHEL
sudo dnf install gcc-aarch64-linux-gnu qemu-user-static gdb

# Arch Linux
sudo pacman -S aarch64-linux-gnu-gcc qemu-user-static gdb
```

#### macOS
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install ARM toolchain
brew install aarch64-elf-gcc qemu
```

#### Windows
```powershell
# Install WSL2 (Windows Subsystem for Linux)
wsl --install

# Then follow Linux instructions within WSL2
```

### Step 2: Automated Setup
```bash
# Clone the course repository
git clone git@github.com:bitcode/ARM-AArch64-Assembly-Language-University.git
cd ARM-Assembly-Language-University

# Run automated setup
./tools/setup/setup.sh

# Initialize your student workspace
./tools/setup/student-workspace-init.sh

# Verify installation
./tools/setup/setup.sh --verify
```

### Step 2.5: Git Workflow Setup

**Important**: This course uses a special Git workflow to protect your work and safely manage course updates.

```bash
# Read the student workflow guide
cat STUDENT-GIT-WORKFLOW.md

# Your workspace is now initialized with:
# - personal-work branch (where you'll do all your work)
# - student workspace directories (for your solutions)
# - automatic backup system
# - conflict resolution tools

# Quick validation
./tools/testing/validate-student-work.sh --quick
```

**Essential Reading**:
- 📖 **[Student Git Workflow Guide](STUDENT-GIT-WORKFLOW.md)** - Complete workflow explanation
- ⚡ **[Quick Reference](STUDENT-QUICK-REFERENCE.md)** - Daily commands and tips
- 🆘 **[Troubleshooting Guide](STUDENT-TROUBLESHOOTING.md)** - Solutions to common issues

### Step 3: Manual Verification
Test your setup with a simple program:

```bash
# Navigate to first exercise
cd modules/m1-foundation/exercises

# Compile and run hello world
aarch64-linux-gnu-gcc -static 1.1-hello-beginner.s -o hello
qemu-aarch64-static ./hello
```

Expected output: `Hello, ARM AArch64 World!`

## 🧠 Understanding the DREAM Methodology

This course uses the **DREAM methodology** for systematic learning:

### **D**efine
- Clearly articulate what you want to understand
- Break complex problems into specific questions
- Set measurable learning objectives

### **R**esearch
- Use ARM documentation as your primary source
- Leverage your LLM research assistant for guidance
- Explore related concepts and connections

### **E**xperiment
- Write code to test your understanding
- Modify examples to see how changes affect behavior
- Create variations to explore edge cases

### **A**nalyze
- Examine results systematically
- Identify patterns and relationships
- Compare actual vs. expected outcomes

### **M**aster
- Synthesize understanding across concepts
- Apply knowledge to new situations
- Teach concepts to solidify learning

## 🤖 Setting Up Your LLM Research Assistant

### Recommended LLM Tools
- **GitHub Copilot Chat** (VS Code integration)
- **Cursor** (AI-powered IDE)
- **Claude** (Web interface or API)
- **ChatGPT** (Web interface or API)

### Initial LLM Setup
1. **Load Course Context**:
   ```
   Please read this course context: [paste llm-integration/course-context.md]
   
   I'm beginning the ARM AArch64 Assembly Language University course. 
   Act as my research assistant, helping me discover concepts rather 
   than providing direct solutions.
   ```

2. **Establish Research Mode**:
   ```
   For this learning session:
   - Guide me to discover answers through research and exploration
   - Ask clarifying questions to deepen my understanding
   - Point me to relevant ARM manual sections
   - Help me debug systematically using the DREAM methodology
   - Encourage experimentation and hypothesis testing
   ```

### Effective LLM Interaction Examples

**✅ Good Research Questions:**
- "Can you guide me through ARM manual section B1.2 to understand register organization?"
- "Help me develop a systematic approach to analyze this assembly code"
- "What questions should I ask myself about ARM calling conventions?"

**❌ Avoid Solution-Seeking:**
- "What's the answer to exercise 1.1?"
- "Write this code for me"
- "Fix my program"

## 📚 Course Navigation

### Module Progression
Follow this sequence for optimal learning:

1. **[M1: Foundation & Setup](modules/m1-foundation/)** (Weeks 1-2)
   - Environment configuration
   - Basic ARM concepts
   - First assembly programs

2. **[M2: Data & Registers](modules/m2-data-registers/)** (Weeks 2-3)
   - Register usage patterns
   - Data types and representations
   - Memory addressing

3. **[M3: Basic Instruction Set](modules/m3-basic-instruction-set/)** (Weeks 4-5)
   - Arithmetic and logical operations
   - Bit manipulation
   - Instruction encoding

4. **[M4: Memory & Data Structures](modules/m4-memory-data-structures/)** (Weeks 6-7)
   - Load/store operations
   - Arrays and structures
   - Memory models

5. **[M5: Control Flow & Structure](modules/m5-control-flow-structure/)** (Weeks 8-9)
   - Branching and loops
   - Function calls
   - Program structure

6. **[M6: Advanced Features](modules/m6-advanced-features/)** (Week 10)
   - SIMD/NEON instructions
   - Floating-point operations
   - System programming

7. **[M7: Optimization & Debugging](modules/m7-optimization-debugging/)** (Week 11)
   - Performance analysis
   - Debugging techniques
   - Code optimization

8. **[M8: Applications & Capstone](modules/m8-applications-capstone/)** (Week 12)
   - Real-world projects
   - Portfolio development
   - Professional integration

### Exercise Structure
Each exercise follows this pattern:
- **Filename**: `module.lesson-topic-difficulty.s`
- **Difficulty Levels**: beginner → intermediate → advanced → expert
- **YAML Metadata**: Learning objectives and research prompts
- **Guided Comments**: TODO items for systematic exploration

## 📖 ARM Manual Integration

### Accessing the ARM Manual
The course includes the complete ARM Architecture Reference Manual:
- **Location**: `Aarch64-Architecture-Reference-Manual-for-A-profile/`
- **Navigation Guide**: `resources/arm-manual-guide/navigation.md`
- **Module Mappings**: Links between course content and manual sections

### Manual Navigation Strategy
1. **Start with Overview**: Part A provides architectural context
2. **Focus on Application Level**: Part B covers programming model
3. **Reference Instructions**: Part C details instruction set
4. **Explore System Level**: Part D covers advanced topics

## 🎯 Learning Strategies

### Daily Practice Routine
1. **Review Previous Day** (10 minutes)
   - Recap key concepts learned
   - Identify any remaining questions

2. **New Concept Exploration** (30-45 minutes)
   - Use DREAM methodology
   - Engage with ARM manual
   - Leverage LLM research assistant

3. **Hands-on Practice** (45-60 minutes)
   - Complete exercises systematically
   - Experiment with variations
   - Debug and analyze results

4. **Reflection and Integration** (15 minutes)
   - Connect new learning to previous knowledge
   - Identify areas for deeper exploration
   - Plan next session focus

### Weekly Milestones
- **Week 1**: Environment setup and basic programs
- **Week 2**: Register usage and data manipulation
- **Week 3**: Control flow and program structure
- **Week 4**: Function calls and stack management
- **Week 5**: Memory operations and data structures
- **Week 6**: Advanced features exploration
- **Week 7**: Optimization and debugging skills
- **Week 8**: Integration and portfolio projects

## 🔍 Troubleshooting Common Issues

### Setup Problems
**Toolchain not found**:
```bash
# Check PATH
echo $PATH
# Add toolchain to PATH if needed
export PATH="/usr/bin:$PATH"
```

**QEMU execution fails**:
```bash
# Verify QEMU installation
qemu-aarch64-static --version
# Reinstall if necessary
sudo apt reinstall qemu-user-static
```

**Permission errors**:
```bash
# Make scripts executable
chmod +x tools/setup/setup.sh
# Run with appropriate permissions
```

### Learning Challenges
**Feeling overwhelmed**:
- Focus on one concept at a time
- Use DREAM methodology systematically
- Engage with LLM for guided exploration

**Stuck on exercises**:
- Review ARM manual sections
- Ask LLM for debugging guidance
- Break problems into smaller parts

**Concepts not connecting**:
- Use LLM to explore relationships
- Review previous modules
- Create concept maps

## 📊 Progress Tracking

### Self-Assessment Questions
After each module, ask yourself:
1. Can I explain the key concepts to someone else?
2. Can I write code demonstrating these concepts?
3. Can I debug problems systematically?
4. Can I find relevant information in the ARM manual?
5. Can I connect this module to previous learning?

### Competency Indicators
- **Beginner**: Following guided instructions successfully
- **Intermediate**: Solving problems independently
- **Advanced**: Optimizing and integrating concepts
- **Expert**: Teaching and innovating with concepts

## 🚀 Your First Steps

### Immediate Actions (Next 30 minutes)
1. **Verify Environment**: Run setup verification script
2. **Load LLM Context**: Set up your research assistant
3. **Explore Module 1**: Read the foundation module overview
4. **Complete First Exercise**: Write your first ARM assembly program

### This Week's Goals
- [ ] Complete environment setup and verification
- [ ] Understand DREAM methodology
- [ ] Establish effective LLM research partnership
- [ ] Complete Module 1 beginner exercises
- [ ] Begin exploring ARM manual navigation

### Success Indicators
You're ready to proceed when you can:
- Compile and run ARM assembly programs
- Use your LLM effectively for research
- Navigate basic ARM manual sections
- Apply DREAM methodology to learning

## 🎓 Welcome to Your Journey

You're about to embark on a comprehensive exploration of ARM AArch64 assembly language. This course is designed to build not just technical skills, but also the research and problem-solving abilities that define professional developers.

**Remember**: The goal isn't just to learn assembly language—it's to develop the systematic thinking and research skills that will serve you throughout your career in systems programming.

**Ready to begin?** Start with [Module 1: Foundation & Setup](modules/m1-foundation/) and begin your systematic exploration of ARM AArch64 assembly language!

---

*Questions or issues? Use your LLM research assistant to explore solutions, consult the troubleshooting guides, or engage with the learning community.*
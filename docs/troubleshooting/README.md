# Troubleshooting Guide for ARM AArch64 Assembly Language University

This comprehensive troubleshooting guide addresses common issues students encounter during course setup, exercise completion, and learning progression. Use this systematic approach to resolve problems independently and develop debugging skills.

## 🎯 Troubleshooting Philosophy

### DREAM Methodology for Problem Solving
- **D**efine: Clearly identify the specific problem and symptoms
- **R**esearch: Investigate potential causes using available resources
- **E**xperiment: Test solutions systematically and document results
- **A**nalyze: Examine outcomes and identify patterns
- **M**aster: Understand root causes and prevent future occurrences

### Problem Classification System
- **Environment Issues**: Setup, installation, and configuration problems
- **Compilation Errors**: Assembly, linking, and build failures
- **Runtime Problems**: Execution errors and unexpected behavior
- **Learning Challenges**: Conceptual difficulties and progression obstacles
- **Tool Integration**: LLM, IDE, and development tool issues

## 🛠️ Environment Setup Issues

### Toolchain Installation Problems

#### Issue: ARM Cross-Compiler Not Found
**Symptoms:**
```bash
bash: aarch64-linux-gnu-gcc: command not found
```

**Diagnosis Steps:**
1. Check if toolchain is installed:
   ```bash
   which aarch64-linux-gnu-gcc
   dpkg -l | grep aarch64  # Ubuntu/Debian
   rpm -qa | grep aarch64  # Fedora/RHEL
   ```

2. Verify PATH configuration:
   ```bash
   echo $PATH
   ```

**Solutions:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install gcc-aarch64-linux-gnu

# Fedora/RHEL
sudo dnf install gcc-aarch64-linux-gnu

# macOS
brew install aarch64-elf-gcc

# Manual PATH addition if needed
export PATH="/usr/bin:$PATH"
echo 'export PATH="/usr/bin:$PATH"' >> ~/.bashrc
```

**Prevention:**
- Run setup verification script after installation
- Add PATH configuration to shell profile
- Document custom installation locations

#### Issue: QEMU Emulation Failures
**Symptoms:**
```bash
qemu-aarch64-static: command not found
./hello: cannot execute binary file: Exec format error
```

**Diagnosis Steps:**
1. Check QEMU installation:
   ```bash
   which qemu-aarch64-static
   qemu-aarch64-static --version
   ```

2. Verify binfmt support (Linux):
   ```bash
   cat /proc/sys/fs/binfmt_misc/qemu-aarch64
   ```

**Solutions:**
```bash
# Ubuntu/Debian
sudo apt install qemu-user-static binfmt-support

# Fedora/RHEL
sudo dnf install qemu-user-static

# Enable binfmt if needed
sudo systemctl restart systemd-binfmt

# Manual execution if binfmt not working
qemu-aarch64-static ./hello
```

**Prevention:**
- Install complete qemu-user-static package
- Verify binfmt configuration
- Test with simple programs before complex exercises

### Permission and Access Issues

#### Issue: Script Execution Permissions
**Symptoms:**
```bash
bash: ./setup.sh: Permission denied
```

**Solutions:**
```bash
# Make script executable
chmod +x setup.sh

# Alternative execution
bash setup.sh

# Fix all scripts in directory
find . -name "*.sh" -exec chmod +x {} \;
```

#### Issue: Directory Access Problems
**Symptoms:**
```bash
mkdir: cannot create directory: Permission denied
```

**Solutions:**
```bash
# Check current permissions
ls -la

# Create in user directory
mkdir -p ~/arm-assembly-course
cd ~/arm-assembly-course

# Fix ownership if needed
sudo chown -R $USER:$USER /path/to/course
```

## 🔧 Compilation and Build Issues

### Assembly Syntax Errors

#### Issue: Unrecognized Instructions
**Symptoms:**
```
Error: unrecognized instruction 'mov'
Error: bad instruction 'add x0, x1, x2'
```

**Diagnosis Steps:**
1. Check instruction syntax in ARM manual
2. Verify register naming conventions
3. Confirm instruction availability in AArch64

**Common Fixes:**
```assembly
// Incorrect AArch32 syntax
mov r0, #42

// Correct AArch64 syntax
mov x0, #42

// Incorrect immediate syntax
add x0, x1, #4096  // Too large for immediate

// Correct syntax
mov x2, #4096
add x0, x1, x2
```

**Prevention:**
- Always use AArch64 instruction reference
- Verify immediate value ranges
- Use correct register naming (x0-x30, w0-w30)

#### Issue: Label and Symbol Errors
**Symptoms:**
```
Error: undefined symbol 'main'
Error: symbol 'loop' is already defined
```

**Diagnosis Steps:**
1. Check label definitions and references
2. Verify symbol visibility and scope
3. Confirm proper section declarations

**Solutions:**
```assembly
// Missing global declaration
.global _start
_start:
    // program code

// Duplicate label fix
loop1:
    // first loop
    b end1
loop2:
    // second loop
end1:
end2:

// Proper section organization
.section .text
.global _start
_start:
    // code here

.section .data
message: .ascii "Hello\n"
```

### Linking Problems

#### Issue: Undefined References
**Symptoms:**
```
ld: undefined reference to 'printf'
ld: undefined reference to '_start'
```

**Solutions:**
```bash
# Link with C library
aarch64-linux-gnu-gcc -static program.s -o program

# Specify entry point
aarch64-linux-gnu-ld -static -e _start program.o -o program

# Link multiple objects
aarch64-linux-gnu-gcc -static main.s utils.s -o program
```

#### Issue: Section Placement Errors
**Symptoms:**
```
ld: section .text loaded at overlapping addresses
```

**Solutions:**
```assembly
// Proper section declarations
.section .text
.global _start
_start:
    // executable code

.section .data
    // initialized data

.section .bss
    // uninitialized data
```

## 🏃 Runtime and Execution Issues

### Program Crashes and Segmentation Faults

#### Issue: Memory Access Violations
**Symptoms:**
```
Segmentation fault (core dumped)
qemu: uncaught target signal 11 (Segmentation fault)
```

**Debugging Steps:**
1. Use GDB for debugging:
   ```bash
   gdb ./program
   (gdb) run
   (gdb) bt  # backtrace
   (gdb) info registers
   ```

2. Check memory access patterns:
   ```assembly
   // Dangerous: uninitialized pointer
   ldr x0, [x1]  // x1 might be invalid
   
   // Safe: proper initialization
   adr x1, data_label
   ldr x0, [x1]
   ```

**Common Causes and Fixes:**
```assembly
// Stack overflow prevention
// Reserve adequate stack space
sub sp, sp, #64  // Allocate stack frame
// ... use stack
add sp, sp, #64  // Restore stack

// Null pointer protection
cbz x0, error_handler  // Check for null
ldr x1, [x0]          // Safe access

// Array bounds checking
cmp x1, #array_size
bge bounds_error
ldr x0, [x2, x1, lsl #3]  // Safe indexed access
```

#### Issue: Infinite Loops
**Symptoms:**
- Program hangs indefinitely
- High CPU usage without progress

**Debugging Approach:**
```assembly
// Add loop counters for debugging
mov x10, #1000  // Maximum iterations
loop:
    // loop body
    subs x10, x10, #1
    beq loop_timeout
    // loop condition
    bne loop
    
loop_timeout:
    // Handle timeout
```

### System Call Issues

#### Issue: System Call Failures
**Symptoms:**
```
System call returned error code
Program terminates unexpectedly
```

**Debugging System Calls:**
```assembly
// Proper system call structure
mov x8, #64      // sys_write
mov x0, #1       // stdout
adr x1, message  // buffer
mov x2, #13      // length
svc #0           // system call

// Check return value
cmp x0, #0
blt syscall_error
```

**Common System Call Errors:**
- Invalid file descriptors
- Incorrect parameter counts
- Wrong system call numbers
- Insufficient permissions

## 🧠 Learning and Conceptual Issues

### Understanding ARM Architecture

#### Issue: Register Confusion
**Common Misunderstandings:**
- Mixing AArch32 and AArch64 register names
- Incorrect register size usage
- Misunderstanding register aliases

**Clarification:**
```assembly
// AArch64 register naming
x0-x30: 64-bit general purpose registers
w0-w30: 32-bit views of x0-x30
sp:     stack pointer (64-bit)
lr:     link register (x30)
pc:     program counter

// Correct usage examples
mov x0, #42      // 64-bit operation
mov w0, #42      // 32-bit operation (zeros upper 32 bits)
add x1, x0, x2   // 64-bit addition
add w1, w0, w2   // 32-bit addition
```

#### Issue: Memory Model Confusion
**Common Problems:**
- Misunderstanding address calculation
- Incorrect pointer arithmetic
- Confusion about memory alignment

**Clarification Examples:**
```assembly
// Address calculation
adr x0, data_label    // Load address of label
ldr x1, =data_label   // Load address (literal pool)
ldr x2, [x0]          // Load value at address

// Pointer arithmetic
add x0, x0, #8        // Advance by 8 bytes
ldr x1, [x0, #16]     // Load from offset
ldr x2, [x0], #8      // Post-increment addressing
```

### DREAM Methodology Application Issues

#### Issue: Ineffective Research Strategies
**Symptoms:**
- Difficulty finding relevant ARM manual sections
- Inefficient LLM interactions
- Lack of systematic problem-solving approach

**Improvement Strategies:**
1. **Define Phase Enhancement:**
   ```
   Instead of: "My program doesn't work"
   Try: "My program crashes when accessing array element 5, 
         with segmentation fault at instruction ldr x0, [x1, x2, lsl #3]"
   ```

2. **Research Phase Improvement:**
   ```
   Instead of: "How do I fix this?"
   Try: "Can you guide me to ARM manual sections about 
         indexed addressing modes and help me understand 
         the addressing calculation?"
   ```

3. **Experiment Phase Structure:**
   ```assembly
   // Systematic testing approach
   // Test 1: Simple case
   mov x1, #0
   ldr x0, [x2, x1, lsl #3]
   
   // Test 2: Boundary case
   mov x1, #7  // Last valid index
   ldr x0, [x2, x1, lsl #3]
   
   // Test 3: Error case
   mov x1, #8  // Invalid index
   // Add bounds checking here
   ```

## 🤖 LLM Integration Issues

### Ineffective LLM Usage Patterns

#### Issue: Solution-Seeking Instead of Learning
**Problematic Approaches:**
```
❌ "What's the answer to exercise 1.1?"
❌ "Write the code for me"
❌ "Fix my program"
```

**Effective Research Questions:**
```
✅ "Can you guide me through ARM manual section B1.2 to understand 
   register organization and help me identify which registers 
   are appropriate for my function parameters?"

✅ "I'm getting a segmentation fault in my array access code. 
   Can you help me develop a systematic debugging approach 
   using the DREAM methodology?"

✅ "Help me understand the relationship between addressing modes 
   and instruction encoding by exploring relevant ARM manual sections."
```

#### Issue: Context Loading Problems
**Symptoms:**
- LLM provides generic programming advice
- Responses don't align with course methodology
- Lack of ARM-specific guidance

**Solutions:**
1. **Proper Context Loading:**
   ```
   Load this course context: [paste llm-integration/course-context.md]
   
   I'm working on Module [X] of the ARM AArch64 Assembly Language 
   University course. Act as my research assistant using the DREAM 
   methodology to guide my learning.
   ```

2. **Session Continuity:**
   ```
   Continue our ARM assembly learning session. I'm currently 
   working on [specific exercise] and need guidance on 
   [specific concept] using the course's research-oriented approach.
   ```

## 🔍 Systematic Debugging Approach

### General Debugging Methodology

#### Step 1: Problem Isolation
```bash
# Create minimal test case
# Start with simplest possible version
# Add complexity incrementally
# Document each change and result
```

#### Step 2: Information Gathering
```bash
# Collect error messages
# Note exact symptoms
# Document environment details
# Record reproduction steps
```

#### Step 3: Hypothesis Formation
```bash
# List possible causes
# Prioritize by likelihood
# Plan testing approach
# Prepare validation criteria
```

#### Step 4: Systematic Testing
```bash
# Test one variable at a time
# Document all results
# Compare with expected outcomes
# Iterate based on findings
```

#### Step 5: Solution Implementation
```bash
# Apply fix systematically
# Verify complete resolution
# Test edge cases
# Document solution for future reference
```

### Debugging Tools and Techniques

#### GDB Usage for Assembly Debugging
```bash
# Compile with debug information
aarch64-linux-gnu-gcc -g -static program.s -o program

# Start debugging session
gdb ./program

# Essential GDB commands
(gdb) break _start        # Set breakpoint
(gdb) run                 # Start execution
(gdb) step                # Single step
(gdb) info registers      # Show register values
(gdb) x/10x $sp          # Examine stack
(gdb) disassemble        # Show assembly code
```

#### Static Analysis Techniques
```bash
# Examine object file
objdump -d program.o

# Check symbols
nm program.o

# Analyze sections
readelf -S program

# Verify linking
ldd program  # For dynamically linked programs
```

## 📚 Resource Quick Reference

### Essential Documentation Links
- **ARM Architecture Reference Manual**: `Aarch64-Architecture-Reference-Manual-for-A-profile/`
- **Course Navigation Guide**: `resources/arm-manual-guide/navigation.md`
- **Quick Reference**: `resources/quick-reference/instructions.md`
- **LLM Integration Guide**: `llm-integration/README.md`

### Emergency Contact and Support
- **Course Forums**: Community discussion and peer support
- **Instructor Office Hours**: Direct instructor assistance
- **Technical Support**: Environment and tool issues
- **LLM Research Assistant**: Guided problem-solving support

### Self-Help Checklist
Before seeking help, verify:
- [ ] Problem clearly defined and documented
- [ ] Basic troubleshooting steps attempted
- [ ] Relevant documentation consulted
- [ ] LLM research assistant engaged appropriately
- [ ] Systematic debugging approach applied
- [ ] Minimal test case created
- [ ] Error messages and symptoms recorded

---

## 🚀 Building Debugging Expertise

### Progressive Skill Development
1. **Beginner**: Follow guided troubleshooting steps
2. **Intermediate**: Apply systematic debugging methodology
3. **Advanced**: Develop custom debugging strategies
4. **Expert**: Contribute to troubleshooting knowledge base

### Learning from Problems
- **Document Solutions**: Build personal troubleshooting database
- **Share Knowledge**: Help peers with similar issues
- **Analyze Patterns**: Identify common mistake categories
- **Prevent Recurrence**: Develop best practices and checklists

**Remember**: Every problem is a learning opportunity. Use the DREAM methodology to transform debugging challenges into deeper understanding of ARM assembly language and systematic problem-solving skills.
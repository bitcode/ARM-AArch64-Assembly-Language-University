# Development Tools

This directory contains scripts and utilities to support ARM AArch64 assembly language development and learning.

## 📁 Directory Structure

### Setup Scripts
- **[setup/](setup/)** - Platform-specific environment setup and student workspace initialization
- **[verification/](verification/)** - Installation verification tools

### Git Workflow Tools
- **[git-workflow/](git-workflow/)** - Student Git workflow automation and conflict resolution
- **[testing/](testing/)** - Student work validation and automated testing framework

### Development Tools
- **[build/](build/)** - Build automation and project management
- **[debugging/](debugging/)** - Debugging utilities and helpers

### Utilities
- **[templates/](templates/)** - Code templates and boilerplate
- **[scripts/](scripts/)** - Utility scripts for common tasks

## 🚀 Quick Setup

### Development Environment
```bash
# Linux/macOS
./setup/setup.sh

# Windows (PowerShell)
.\setup\setup.ps1
```

### Student Workspace (Git Workflow)
```bash
# Initialize student workspace and Git workflow
./setup/student-workspace-init.sh
```

**📖 Student Documentation**:
- **[Student Git Workflow Guide](../STUDENT-GIT-WORKFLOW.md)** - Complete workflow explanation
- **[Quick Reference](../STUDENT-QUICK-REFERENCE.md)** - Daily commands and tips
- **[Troubleshooting Guide](../STUDENT-TROUBLESHOOTING.md)** - Solutions to common issues

### Manual Setup
If automated setup fails, see [setup/manual-setup.md](setup/manual-setup.md) for detailed instructions.

## 🔧 Tool Categories

### Environment Setup
- Cross-compilation toolchain installation
- Emulator configuration
- IDE integration setup
- Student workspace initialization
- Verification and testing

### Git Workflow Management
- Fork-based dual-zone directory structure
- Automated conflict resolution
- Semester course updates
- Backup and recovery management
- Repository integrity checking

### Build System
- Automated assembly and linking
- Multi-target build support
- Dependency management
- Clean and rebuild utilities

### Testing & Validation Framework
- Exercise validation
- Student work integrity checking
- Automated testing for student solutions
- Performance benchmarking
- Regression testing

### Debugging Support
- GDB integration scripts
- Memory analysis tools
- Disassembly utilities
- Trace analysis

## 📋 Usage Examples

### Git Workflow Management
```bash
# Initialize student workspace
./setup/student-workspace-init.sh

# Update course content
./git-workflow/semester-update.sh --interactive

# Create backup
./git-workflow/backup-manager.sh --create "before-exercise-3"

# Validate student work
./testing/validate-student-work.sh

# Check repository integrity
./git-workflow/repository-integrity-check.sh
```

### Build an Exercise
```bash
# Build single exercise
./build/build-exercise.sh modules/m1-foundation/exercises/1.1-hello-beginner.s

# Build all exercises in a module
./build/build-module.sh m1-foundation
```

### Run Tests
```bash
# Test single exercise
./testing/test-exercise.sh 1.1-hello-beginner

# Test entire module
./testing/test-module.sh m1-foundation
```

### Debug Program
```bash
# Launch debugger for exercise
./debugging/debug-exercise.sh hello

# Analyze memory usage
./debugging/memory-analysis.sh hello
```

## 🛠️ Tool Requirements

### Minimum Requirements
- ARM AArch64 cross-compilation toolchain
- QEMU user-mode emulation
- Basic shell environment (bash/PowerShell)

### Recommended Tools
- GDB with ARM support
- Hex editor for binary analysis
- Performance profiling tools
- Text editor with assembly syntax highlighting

## 📚 Documentation

Each tool directory contains:
- **README.md** - Tool-specific documentation
- **examples/** - Usage examples and tutorials
- **config/** - Configuration files and templates

## 🔍 Troubleshooting

### Common Issues
1. **Toolchain not found**: Verify PATH configuration
2. **Permission errors**: Check script execution permissions
3. **QEMU failures**: Ensure user-mode emulation is installed
4. **Build errors**: Verify toolchain compatibility

### Getting Help
- Check tool-specific README files
- Review setup verification output
- Consult platform-specific setup guides
- Use LLM research assistant for debugging guidance

---

**Ready to set up your development environment?** Start with the [setup scripts](setup/) for your platform.
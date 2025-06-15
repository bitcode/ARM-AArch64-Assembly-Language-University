# Student Git Workflow Guide
## ARM Assembly Language University Course

**Welcome to your safe, student-friendly Git workflow!** This guide will help you understand and use the Git workflow system designed specifically for this course.

## 🎯 What This Workflow Does For You

This Git workflow system is designed to:
- **Protect your work** - Your student work will never be lost during course updates
- **Keep you organized** - Clear separation between course content and your personal work
- **Make Git safe** - Automated backups and conflict resolution
- **Support your learning** - Focus on ARM assembly, not Git complexity

## 📚 Table of Contents

1. [Understanding the Workflow](#understanding-the-workflow)
2. [Getting Started](#getting-started)
3. [Daily Workflow](#daily-workflow)
4. [Receiving Course Updates](#receiving-course-updates)
5. [Managing Backups](#managing-backups)
6. [Understanding Your Workspace](#understanding-your-workspace)
7. [Git Concepts Explained](#git-concepts-explained)
8. [Best Practices](#best-practices)
9. [Advanced Features](#advanced-features)

---

## Understanding the Workflow

### The Big Picture

```
┌─────────────────────────────────────────────────────────────┐
│                    Course Repository                        │
│  ┌─────────────────┐              ┌─────────────────────┐   │
│  │  Course Content │              │  Your Student Work  │   │
│  │   (Read-Only)   │              │  (Full Control)     │   │
│  │                 │              │                     │   │
│  │ • Module docs   │              │ • Exercise solutions│   │
│  │ • Resources     │              │ • Personal projects │   │
│  │ • Assessments   │              │ • Learning notes    │   │
│  │ • Tools         │              │ • Experiments       │   │
│  └─────────────────┘              └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Fork-Based Workflow

This course uses a **fork-based workflow**:

1. **Upstream Repository** - The main course repository (instructor-controlled)
2. **Your Fork** - Your personal copy of the repository
3. **Local Repository** - The copy on your computer

```
Instructor's Repository (upstream)
         ↓ (you fork)
Your GitHub Fork (origin)
         ↓ (you clone)
Your Local Computer
```

### Dual-Zone Directory Structure

The repository is organized into two zones:

#### 🔒 Course Content Zone (Read-Only)
- `modules/*/README.md` - Module documentation
- `modules/*/exercises/*.s` - Base exercise files
- `resources/` - Reference materials
- `docs/` - Course documentation
- `assessment/` - Assessment materials

#### ✏️ Student Workspace Zone (Your Control)
- `modules/*/student-work/` - Your exercise solutions and projects
- `modules/*/personal-notes/` - Your learning notes and research
- `student-workspace/` - Top-level workspace for projects
- `personal-workspace/` - Personal notes and research

---

## Getting Started

### Step 1: Initial Setup

Run the initialization script to set up your student workspace:

```bash
./tools/setup/student-workspace-init.sh
```

This script will:
- ✅ Create your student workspace directories
- ✅ Set up Git remotes (upstream and origin)
- ✅ Create the `personal-work` branch for your daily work
- ✅ Configure Git hooks for automatic validation
- ✅ Create README files in your workspace directories

### Step 2: Verify Your Setup

Check that everything is working:

```bash
# Verify you're on the personal-work branch
git branch --show-current
# Should show: personal-work

# Check your workspace structure
ls modules/m1-foundation/
# Should show: README.md  exercises/  personal-notes/  student-work/

# Validate your workspace
./tools/testing/validate-student-work.sh
```

### Step 3: Understand Your Branches

After setup, you'll have these branches:

- **`main`** - Synchronized with course content (don't work here)
- **`personal-work`** - Your daily working branch (work here)
- **`backup/*`** - Automatic backups of your work

---

## Daily Workflow

### Your Daily Routine

1. **Start on the right branch**:
   ```bash
   git checkout personal-work
   ```

2. **Work in your student directories**:
   ```bash
   cd modules/m1-foundation/student-work/exercises/
   # Create your solution files here
   ```

3. **Commit your work regularly**:
   ```bash
   git add .
   git commit -m "Complete exercise 1.1 - hello world solution"
   ```

4. **Push your work to your fork**:
   ```bash
   git push origin personal-work
   ```

### Where to Put Your Work

#### ✅ Safe Places for Your Work
```
modules/m1-foundation/student-work/
├── exercises/
│   ├── 1.1-hello-my-solution.s
│   └── 1.2-arithmetic-my-approach.s
├── projects/
│   └── my-calculator-project.s
└── experiments/
    └── register-testing.s

modules/m1-foundation/personal-notes/
├── module-notes/
│   └── architecture-insights.md
├── research/
│   └── arm-vs-x86-comparison.md
└── debugging-logs/
    └── exercise-1-debugging.md
```

#### ❌ Don't Modify These
```
modules/m1-foundation/README.md          # Course documentation
modules/m1-foundation/exercises/1.1-hello-beginner.s  # Base exercise files
resources/                               # Course resources
docs/                                   # Course documentation
```

### Example Daily Session

```bash
# 1. Start your day
git checkout personal-work
git status  # Check what you were working on

# 2. Work on an exercise
cd modules/m2-data-registers/student-work/exercises/
cp ../../../exercises/2.1-register-basics-beginner.s 2.1-my-solution.s
# Edit your solution file

# 3. Test your work
aarch64-linux-gnu-gcc -static 2.1-my-solution.s -o my-solution
qemu-aarch64-static ./my-solution

# 4. Commit your progress
git add 2.1-my-solution.s
git commit -m "WIP: Working on register basics exercise"

# 5. Take notes
cd ../../personal-notes/module-notes/
echo "## Register Usage Insights" >> registers.md
echo "- R0-R7 are general purpose..." >> registers.md
git add registers.md
git commit -m "Add notes on register usage patterns"

# 6. End of session
git push origin personal-work
```

---

## Receiving Course Updates

### When Updates Are Available

Your instructor will announce when course updates are available. You'll receive:
- New exercise files
- Updated documentation
- Additional resources
- Bug fixes

### Safe Update Process

#### Option 1: Interactive Mode (Recommended for Beginners)

```bash
./tools/git-workflow/semester-update.sh --interactive
```

This will guide you through each step:
1. ✅ Check prerequisites
2. ✅ Create automatic backup
3. ✅ Show you what's changing
4. ✅ Ask for your confirmation
5. ✅ Apply updates safely
6. ✅ Validate results

#### Option 2: Check What's Available

```bash
./tools/git-workflow/semester-update.sh --check
```

This shows you what updates are available without applying them.

#### Option 3: Automatic Mode (For Experienced Users)

```bash
./tools/git-workflow/semester-update.sh --auto
```

### What Happens During Updates

```
Before Update:
┌─────────────────┐    ┌─────────────────┐
│  Course Content │    │ Your Work       │
│  (Version 1.0)  │    │ (Preserved)     │
└─────────────────┘    └─────────────────┘

During Update:
┌─────────────────┐    ┌─────────────────┐
│ 1. Backup       │    │ 2. Fetch New    │
│    Your Work    │    │    Course       │
│                 │    │    Content      │
└─────────────────┘    └─────────────────┘

After Update:
┌─────────────────┐    ┌─────────────────┐
│  Course Content │    │ Your Work       │
│  (Version 1.1)  │    │ (Still Safe!)   │
└─────────────────┘    └─────────────────┘
```

### Understanding Conflicts

Sometimes your changes and course updates might conflict. The system handles this automatically:

#### Automatic Resolution Rules
- **Your student work** → Always kept (your version wins)
- **Course content** → Always updated (instructor version wins)
- **Configuration files** → Merged intelligently

#### If Manual Resolution Needed
The system will:
1. Create a backup of your current state
2. Show you exactly what needs manual attention
3. Provide a step-by-step guide
4. Help you resolve conflicts safely

---

## Managing Backups

### Automatic Backups

The system creates backups automatically:
- **Before course updates** - So you can always go back
- **Before major operations** - Like conflict resolution
- **Daily** - If you've made significant changes

### Manual Backups

Create your own backups anytime:

```bash
# Create a backup with description
./tools/git-workflow/backup-manager.sh --create "before-midterm-project"

# List all your backups
./tools/git-workflow/backup-manager.sh --list

# Interactive backup management
./tools/git-workflow/backup-manager.sh --interactive
```

### Restoring from Backup

If something goes wrong:

```bash
# List available backups
./tools/git-workflow/backup-manager.sh --list

# Restore from a specific backup
./tools/git-workflow/backup-manager.sh --restore backup/20231215-before-midterm-project

# Compare current state with backup
./tools/git-workflow/backup-manager.sh --compare backup/20231215-before-midterm-project
```

### Backup Naming Convention

Backups are named systematically:
```
backup/YYYYMMDD-HHMMSS-type-description
backup/20231215-143022-manual-before-midterm-project
backup/20231215-090000-auto-daily
backup/20231215-100000-pre-update-semester-update
```

---

## Understanding Your Workspace

### Directory Structure Overview

```
ARM-Assembly-Language-University/
├── modules/                          # Course modules
│   ├── m1-foundation/
│   │   ├── README.md                 # 🔒 Course content
│   │   ├── exercises/                # 🔒 Base exercise files
│   │   ├── student-work/             # ✏️ YOUR SOLUTIONS
│   │   │   ├── exercises/            # Your exercise solutions
│   │   │   ├── projects/             # Your projects
│   │   │   └── experiments/          # Your experiments
│   │   └── personal-notes/           # ✏️ YOUR NOTES
│   │       ├── module-notes/         # Notes about concepts
│   │       ├── research/             # Additional research
│   │       └── debugging-logs/       # Debugging sessions
│   ├── m2-data-registers/            # Same structure for each module
│   └── ...
├── student-workspace/                # ✏️ Top-level workspace
│   ├── projects/                     # Cross-module projects
│   └── experiments/                  # General experiments
├── personal-workspace/               # ✏️ Personal area
│   ├── notes/                        # General notes
│   └── research/                     # Personal research
├── resources/                        # 🔒 Course resources
├── docs/                            # 🔒 Course documentation
└── tools/                           # 🔒 Workflow tools
```

### File Naming Conventions

#### For Exercise Solutions
```
# Original exercise file (don't modify):
1.1-hello-beginner.s

# Your solution files:
1.1-hello-my-solution.s
1.1-hello-alternative-approach.s
1.1-hello-optimized-version.s
```

#### For Projects
```
calculator-project.s
string-manipulation-experiment.s
performance-test-suite.s
```

#### For Notes
```
module-1-insights.md
arm-vs-x86-comparison.md
debugging-session-2023-12-15.md
```

---

## Git Concepts Explained

### Branches Explained Simply

Think of branches like parallel universes for your code:

```
main branch:      A---B---C---D (course updates)
                   \
personal-work:      E---F---G---H (your work)
```

- **`main`** - The "official" course timeline
- **`personal-work`** - Your personal timeline where you do all your work

### Remotes Explained

Remotes are like bookmarks to different copies of the repository:

```
upstream (instructor's repo) ←--fetch updates--← origin (your fork) ←--clone--← local (your computer)
                                                      ↑                              ↓
                                                   push work                    commit work
```

- **`upstream`** - The instructor's original repository
- **`origin`** - Your fork on GitHub
- **`local`** - The copy on your computer

### Merging and Conflicts

When Git tries to combine changes:

```
✅ No Conflict:
Course: Added new exercise file
You:    Added solution file
Result: Both files exist happily

❌ Conflict:
Course: Modified exercise instructions
You:    Also modified the same instructions
Result: Git needs help deciding which version to keep
```

The workflow system resolves most conflicts automatically using smart rules.

---

## Best Practices

### Daily Habits

#### ✅ Good Practices
- Work on the `personal-work` branch
- Commit frequently with descriptive messages
- Keep your work in student workspace directories
- Take notes about your learning process
- Push your work regularly to your fork

#### ❌ Avoid These
- Working directly on the `main` branch
- Modifying course content files
- Large commits without descriptive messages
- Forgetting to backup before major changes

### Commit Message Guidelines

#### ✅ Good Commit Messages
```
"Complete exercise 1.1 - hello world with comments"
"Add notes on ARM register usage patterns"
"Experiment with different loop implementations"
"Fix bug in calculator project - handle negative numbers"
"WIP: Working on advanced sorting algorithm"
```

#### ❌ Poor Commit Messages
```
"stuff"
"update"
"fix"
"asdf"
"final version"
```

### Organization Tips

#### Keep Your Work Organized
```
student-work/exercises/
├── 1.1-hello-my-solution.s
├── 1.2-arithmetic-basic-solution.s
├── 1.2-arithmetic-optimized.s
└── README.md  # Your own notes about exercises

personal-notes/module-notes/
├── week-1-insights.md
├── register-usage-patterns.md
└── debugging-strategies.md
```

#### Document Your Learning
```markdown
# Week 1 Insights

## What I Learned
- ARM uses 31 general-purpose registers (X0-X30)
- Register W0 is the lower 32 bits of X0
- The stack pointer is SP, not a general register

## Questions for Next Week
- How does ARM calling convention compare to x86?
- When should I use 32-bit vs 64-bit operations?

## Debugging Notes
- Use `objdump -d` to see disassembly
- QEMU's `-d in_asm` flag shows instruction execution
```

### Weekly Maintenance

#### Every Week
1. **Check for course updates**:
   ```bash
   ./tools/git-workflow/semester-update.sh --check
   ```

2. **Create a weekly backup**:
   ```bash
   ./tools/git-workflow/backup-manager.sh --create "week-$(date +%U)-progress"
   ```

3. **Validate your workspace**:
   ```bash
   ./tools/testing/validate-student-work.sh
   ```

4. **Clean up old backups**:
   ```bash
   ./tools/git-workflow/backup-manager.sh --cleanup
   ```

---

## Advanced Features

### Workspace Validation

The validation system checks:
- Directory structure integrity
- No unauthorized course content modifications
- File size and type validation
- Git repository health
- Conflict marker detection

```bash
# Full validation
./tools/testing/validate-student-work.sh

# Quick check
./tools/testing/validate-student-work.sh --quick

# Quiet mode (for scripts)
./tools/testing/validate-student-work.sh --quiet
```

### Conflict Resolution System

The automated conflict resolver uses intelligent rules:

```bash
# Automatic resolution
./tools/git-workflow/resolve-conflicts.sh --auto

# Interactive step-by-step
./tools/git-workflow/resolve-conflicts.sh --interactive

# Just analyze conflicts
./tools/git-workflow/resolve-conflicts.sh --analyze
```

#### Resolution Rules
- **Student workspace files** → Your version always wins
- **Course content files** → Instructor version always wins
- **Configuration files** → Intelligent merging
- **Complex conflicts** → Manual resolution with guidance

### Repository Integrity Checks

```bash
# Check repository health
./tools/git-workflow/repository-integrity-check.sh

# Verify all components
./tools/git-workflow/repository-integrity-check.sh --full

# Fix common issues
./tools/git-workflow/repository-integrity-check.sh --repair
```

### Advanced Backup Features

#### Backup Comparison
```bash
# Compare current state with backup
./tools/git-workflow/backup-manager.sh --compare backup/20231215-manual

# Show differences in detail
git diff backup/20231215-manual HEAD
```

#### Selective Restore
```bash
# Restore specific files from backup
git checkout backup/20231215-manual -- modules/m1-foundation/student-work/exercises/
```

#### Backup Metadata
```bash
# View backup registry
cat tools/git-workflow/logs/backup-registry.log

# Find backups by date
grep "2023-12-15" tools/git-workflow/logs/backup-registry.log
```

---

## Getting Help

### When Things Go Wrong

1. **Check the logs**:
   ```bash
   ls tools/git-workflow/logs/
   cat tools/git-workflow/logs/validation-*.log
   ```

2. **Run validation**:
   ```bash
   ./tools/testing/validate-student-work.sh
   ```

3. **Check your backups**:
   ```bash
   ./tools/git-workflow/backup-manager.sh --list
   ```

4. **Consult troubleshooting guide**:
   See [`STUDENT-TROUBLESHOOTING.md`](STUDENT-TROUBLESHOOTING.md)

### Support Resources

- **Course Documentation**: `docs/` directory
- **ARM Manual Guide**: `resources/arm-manual-guide/`
- **LLM Integration**: `llm-integration/` for research assistant setup
- **Troubleshooting**: [`STUDENT-TROUBLESHOOTING.md`](STUDENT-TROUBLESHOOTING.md)
- **Quick Reference**: [`STUDENT-QUICK-REFERENCE.md`](STUDENT-QUICK-REFERENCE.md)

### Emergency Recovery

If your workspace becomes corrupted:

1. **Don't panic** - your work is backed up!
2. **List your backups**:
   ```bash
   ./tools/git-workflow/backup-manager.sh --list
   ```
3. **Restore from recent backup**:
   ```bash
   ./tools/git-workflow/backup-manager.sh --restore backup/YYYYMMDD-HHMMSS-type
   ```
4. **Re-initialize if needed**:
   ```bash
   ./tools/setup/student-workspace-init.sh
   ```

---

## Summary

This Git workflow is designed to be **safe**, **educational**, and **student-focused**. Key points to remember:

### 🛡️ Safety Features
- Automatic backups before major operations
- Intelligent conflict resolution
- Multiple recovery options
- Validation to catch issues early

### 📚 Learning Focus
- Clear separation of course content and student work
- Progressive complexity introduction
- Educational explanations of Git concepts
- Focus on ARM assembly learning, not Git complexity

### 🎯 Daily Workflow
1. Work on `personal-work` branch
2. Use student workspace directories
3. Commit frequently with good messages
4. Push regularly to your fork
5. Update course content when announced

### 🆘 When You Need Help
1. Check validation output
2. Review backup options
3. Consult troubleshooting guide
4. Use course support resources

**Remember**: This workflow is designed to protect your work and support your learning. When in doubt, create a backup and ask for help!

---

*Happy coding and learning ARM assembly! 🚀*
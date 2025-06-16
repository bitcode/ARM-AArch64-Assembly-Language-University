# Student Quick Reference
## ARM Assembly Language University Course

### 🚀 Getting Started
```bash
# 1. Fork repository on GitHub
# 2. Clone your fork
git clone <your-fork-url>
cd ARM-AArch64-Assembly-Language-University

# 3. Run setup (one time only)
./setup.sh

# 4. Start coding
cd modules/m1/exercises
cp hello.s my-hello.s
# Edit and look for ★ START HERE ★
```

### 🔨 Build & Run
```bash
# Build any assembly file
./build.sh <file.s>

# Run the program
qemu-aarch64-static ./<program>

# Example
./build.sh my-hello.s
qemu-aarch64-static ./my-hello
```

### 💾 Save Your Work
```bash
# Save changes
git add .
git commit -m "Complete exercise X"
git push origin my-work
```

### 📚 Get Course Updates
```bash
# Check for updates
./update-course.sh --check

# Apply updates
./update-course.sh
```

### 📁 File Organization
- **Your work**: `modules/m*/student-work/`
- **Your notes**: `modules/m*/personal-notes/`
- **Course content**: `modules/m*/exercises/` (don't edit)

### 🆘 Common Commands
```bash
git status              # Check what's changed
git log --oneline       # View commit history
git diff                # See current changes
./build.sh --help       # Build script help
./update-course.sh --help  # Update script help
```

### 🎯 Workflow Summary
1. Copy exercise file to student-work
2. Edit and implement solution
3. Build and test with build.sh
4. Commit and push your work
5. Update course content when announced

**Need help?** Check `docs/student/STUDENT-TROUBLESHOOTING.md`
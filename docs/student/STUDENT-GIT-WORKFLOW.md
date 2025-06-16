# Simple Git Workflow Guide
## ARM Assembly Language University Course

**Welcome to your simplified Git workflow!** This guide covers everything you need to know to work with the course repository using standard Git practices.

## 🎯 Quick Start

### 1. Initial Setup
After forking and cloning the repository, run:
```bash
./setup.sh
```
This automatically configures your Git workflow with:
- Upstream remote for course updates
- Student work branch (`my-work`)
- Simplified module structure

### 2. Daily Workflow
```bash
# Start working (you'll be on 'my-work' branch)
cd modules/m1/exercises
cp hello.s my-hello.s
# Edit my-hello.s and look for ★ START HERE ★

# Build and test
../../../build.sh my-hello.s
qemu-aarch64-static ./my-hello

# Save your work
git add my-hello.s
git commit -m "Complete hello world exercise"
git push origin my-work
```

### 3. Get Course Updates
```bash
./update-course.sh
```
This safely merges new course content while preserving your student work.

## 📁 Where to Put Your Work

### ✅ Your Workspace (Safe to Edit)
- `modules/m1/student-work/` - Your exercise solutions
- `modules/m1/personal-notes/` - Your learning notes
- Any files you create in student-work directories

### ❌ Course Content (Don't Edit)
- `modules/m1/exercises/` - Original exercise files
- `modules/m1/README.md` - Module documentation
- `docs/` - Course documentation

## 🔄 Standard Git Commands

```bash
# Check status
git status

# Save your work
git add .
git commit -m "Descriptive message"
git push origin my-work

# Get course updates
./update-course.sh

# View your progress
git log --oneline
```

## 🆘 Need Help?

- **Build issues**: Check `docs/student/STUDENT-TROUBLESHOOTING.md`
- **Git conflicts**: Run `./update-course.sh` - it provides guidance
- **Quick reference**: See `docs/student/STUDENT-QUICK-REFERENCE.md`

That's it! This simplified workflow lets you focus on learning ARM assembly instead of complex Git operations.
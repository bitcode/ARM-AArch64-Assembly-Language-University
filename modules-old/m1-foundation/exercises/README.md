# Module 1: Foundation & Setup - Exercise Files

This directory contains the base exercise files for Module 1. These files provide guided learning experiences while maintaining student self-reliance.

## 🎯 Purpose

These exercise files serve as **guided starting points** for students:
- **Provide clear learning objectives** and step-by-step guidance
- **Include ARM manual references** for deeper understanding  
- **Maintain student self-reliance** - no boilerplate code provided
- **Support the Git workflow** - students copy to their `student-work/exercises/` directory

## 📋 Exercise Structure

Each exercise file follows this pattern:
- **Header**: Module, lesson, and learning objectives
- **YAML Metadata**: Structured information for tracking and validation
- **Instructions**: Clear steps and guidance comments
- **Hints**: Helpful tips without giving away solutions
- **No Code**: Students write all implementation from scratch

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
cd modules/m1-foundation/student-work/exercises/

# Copy the exercise file
cp ../../exercises/1.1-hello-beginner.s 1.1-hello-my-solution.s
```

### Step 2: Work on Your Solution
```bash
# Edit your copy (not the original!)
# Follow the guidance comments
# Write all code from scratch
```

### Step 3: Test Your Solution
```bash
# Assemble and test
aarch64-linux-gnu-gcc -static 1.1-hello-my-solution.s -o hello
qemu-aarch64-static ./hello
```

### Step 4: Commit Your Work
```bash
# Add and commit your solution
git add 1.1-hello-my-solution.s
git commit -m "Complete exercise 1.1 - hello world solution"
```

## 📚 Learning Philosophy

These guided exercises balance:
- **Structure** - Clear objectives and progression
- **Independence** - Students write all code themselves
- **Research** - ARM manual integration for deep learning
- **Practice** - Hands-on implementation experience

## 🔄 Exercise Updates

When course updates include new or improved exercises:
- New exercise files will appear in this directory
- Existing exercises may receive improved guidance
- Your solutions in `student-work/` remain untouched
- The Git workflow handles updates automatically

---

**Ready to start?** Copy your first exercise file and begin your ARM assembly journey!

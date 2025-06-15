# Student Git Workflow - Quick Reference
## ARM Assembly Language University Course

**Quick commands and reminders for daily use**

## 🚀 Daily Essentials

### Start Your Day
```bash
git checkout personal-work    # Switch to your working branch
git status                   # Check what you were working on
git pull origin personal-work # Get your latest changes (if working on multiple computers)
```

### Work on Exercises
```bash
cd modules/m1-foundation/student-work/exercises/
# Copy base exercise to your solution file
cp ../../exercises/1.1-hello-beginner.s 1.1-my-solution.s
# Edit your solution, then test it
aarch64-linux-gnu-gcc -static 1.1-my-solution.s -o my-solution
qemu-aarch64-static ./my-solution
```

### Save Your Work
```bash
git add .                                    # Stage your changes
git commit -m "Complete exercise 1.1"       # Commit with good message
git push origin personal-work               # Push to your fork
```

### End Your Day
```bash
git status                   # Check everything is committed
git push origin personal-work # Make sure your work is backed up
```

## 📁 Directory Quick Guide

### ✅ Where to Put Your Work
```
modules/*/student-work/exercises/     # Your exercise solutions
modules/*/student-work/projects/      # Your projects
modules/*/student-work/experiments/   # Your experiments
modules/*/personal-notes/             # Your learning notes
student-workspace/                    # Cross-module projects
personal-workspace/                   # Personal research
```

### ❌ Don't Touch These
```
modules/*/README.md                   # Course documentation
modules/*/exercises/*.s               # Base exercise files
resources/                           # Course resources
docs/                               # Course documentation
assessment/                         # Assessment materials
```

## 🔄 Course Updates

### Check for Updates
```bash
./tools/git-workflow/semester-update.sh --check
```

### Apply Updates (Interactive - Recommended)
```bash
./tools/git-workflow/semester-update.sh --interactive
```

### Apply Updates (Automatic - For Experienced Users)
```bash
./tools/git-workflow/semester-update.sh --auto
```

## 💾 Backup Commands

### Create Manual Backup
```bash
./tools/git-workflow/backup-manager.sh --create "description"
```

### List All Backups
```bash
./tools/git-workflow/backup-manager.sh --list
```

### Interactive Backup Management
```bash
./tools/git-workflow/backup-manager.sh --interactive
```

## 🔍 Validation & Health Checks

### Quick Validation
```bash
./tools/testing/validate-student-work.sh --quick
```

### Full Validation
```bash
./tools/testing/validate-student-work.sh
```

### Check Repository Health
```bash
./tools/git-workflow/repository-integrity-check.sh
```

## 🌿 Branch Commands

### Check Current Branch
```bash
git branch --show-current
```

### Switch to Personal Work Branch
```bash
git checkout personal-work
```

### View All Branches
```bash
git branch -a
```

## 📝 File Naming Conventions

### Exercise Solutions
```
1.1-hello-my-solution.s              # Your main solution
1.1-hello-alternative.s              # Alternative approach
1.1-hello-optimized.s                # Optimized version
```

### Projects
```
calculator-project.s                 # Descriptive project names
string-utils-experiment.s            # Experiment files
performance-test.s                   # Test files
```

### Notes
```
module-1-insights.md                 # Module-specific notes
debugging-session-2023-12-15.md     # Debugging logs
arm-reference-notes.md               # Reference materials
```

## 🆘 Emergency Commands

### If You're Lost
```bash
git status                          # See what's happening
git branch --show-current           # Check which branch you're on
./tools/testing/validate-student-work.sh --quick  # Quick health check
```

### If Something Went Wrong
```bash
./tools/git-workflow/backup-manager.sh --list     # See available backups
./tools/git-workflow/backup-manager.sh --restore backup/YYYYMMDD-HHMMSS-type
```

### If You Have Conflicts
```bash
./tools/git-workflow/resolve-conflicts.sh --interactive
```

## 📊 Status Commands

### Check Git Status
```bash
git status                          # See modified files
git log --oneline -10               # See recent commits
git diff                           # See unstaged changes
git diff --staged                  # See staged changes
```

### Check Workspace Status
```bash
ls modules/m1-foundation/student-work/    # See your work directories
find . -name "*.s" -path "*/student-work/*"  # Find your solution files
```

## 🔧 Common Git Commands

### Staging and Committing
```bash
git add filename.s                  # Stage specific file
git add .                          # Stage all changes
git commit -m "message"            # Commit with message
git commit -am "message"           # Stage and commit modified files
```

### Viewing History
```bash
git log --oneline                  # Compact log
git log --graph --oneline          # Visual branch history
git show HEAD                      # Show last commit details
```

### Undoing Changes
```bash
git checkout -- filename.s        # Discard changes to file
git reset HEAD filename.s          # Unstage file
git reset --soft HEAD~1           # Undo last commit (keep changes)
```

## 📋 Weekly Checklist

### Every Week
- [ ] Check for course updates: `./tools/git-workflow/semester-update.sh --check`
- [ ] Create weekly backup: `./tools/git-workflow/backup-manager.sh --create "week-N"`
- [ ] Validate workspace: `./tools/testing/validate-student-work.sh`
- [ ] Clean old backups: `./tools/git-workflow/backup-manager.sh --cleanup`
- [ ] Push all work: `git push origin personal-work`

## 🎯 Good Commit Messages

### ✅ Good Examples
```
"Complete exercise 1.1 - hello world with detailed comments"
"Add notes on ARM register usage patterns"
"Implement calculator project with error handling"
"Fix bug in sorting algorithm - handle empty arrays"
"WIP: Working on advanced memory management exercise"
"Experiment with different loop optimization techniques"
```

### ❌ Avoid These
```
"update"
"fix"
"stuff"
"final"
"asdf"
```

## 🔗 Quick Links

- **Main Guide**: [`STUDENT-GIT-WORKFLOW.md`](STUDENT-GIT-WORKFLOW.md)
- **Troubleshooting**: [`STUDENT-TROUBLESHOOTING.md`](STUDENT-TROUBLESHOOTING.md)
- **Course Overview**: [`COURSE_OVERVIEW.md`](COURSE_OVERVIEW.md)
- **Getting Started**: [`GETTING_STARTED.md`](GETTING_STARTED.md)

## 💡 Pro Tips

### Efficiency Tips
- Use tab completion for file names
- Create aliases for common commands
- Use `git status` frequently to stay oriented
- Commit early and often with good messages

### Organization Tips
- Keep related files together in appropriate directories
- Use descriptive file names
- Document your thought process in comments
- Take notes about what you learn

### Safety Tips
- Always work on `personal-work` branch
- Create backups before major changes
- Validate your workspace regularly
- Don't modify course content files

---

**Remember**: When in doubt, create a backup and ask for help! This workflow is designed to keep your work safe.

*For detailed explanations, see the full [`STUDENT-GIT-WORKFLOW.md`](STUDENT-GIT-WORKFLOW.md) guide.*
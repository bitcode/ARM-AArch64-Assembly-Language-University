# Student Git Workflow - Troubleshooting Guide
## ARM Assembly Language University Course

**Solutions to common issues and problems you might encounter**

## 📋 Table of Contents

1. [Initial Setup Issues](#initial-setup-issues)
2. [Daily Workflow Problems](#daily-workflow-problems)
3. [Course Update Issues](#course-update-issues)
4. [Merge Conflicts](#merge-conflicts)
5. [Backup and Recovery](#backup-and-recovery)
6. [Workspace Corruption](#workspace-corruption)
7. [Git Configuration Problems](#git-configuration-problems)
8. [File and Directory Issues](#file-and-directory-issues)
9. [Performance and Storage Issues](#performance-and-storage-issues)
10. [Emergency Recovery Procedures](#emergency-recovery-procedures)

---

## Initial Setup Issues

### Problem: "Not in a Git repository" Error

**Symptoms:**
```
fatal: not a git repository (or any of the parent directories): .git
```

**Solution:**
```bash
# Make sure you're in the correct directory
pwd
# Should show: /path/to/ARM-Assembly-Language-University

# If not, navigate to the correct directory
cd /path/to/ARM-Assembly-Language-University

# If the directory doesn't exist, clone the repository
git clone https://github.com/yourusername/ARM-Assembly-Language-University.git
cd ARM-Assembly-Language-University
```

### Problem: Upstream Remote Not Configured

**Symptoms:**
```
error: upstream remote not found
```

**Solution:**
```bash
# Check current remotes
git remote -v

# Add upstream remote (replace with actual upstream URL)
git remote add upstream https://github.com/ARM-Assembly-University/ARM-Assembly-Language-University.git

# Verify it was added
git remote -v
# Should show both origin and upstream
```

### Problem: Student Workspace Initialization Fails

**Symptoms:**
- Missing student-work directories
- No personal-work branch
- Validation fails

**Solution:**
```bash
# Re-run the initialization script
./tools/setup/student-workspace-init.sh

# If script is not executable
chmod +x ./tools/setup/student-workspace-init.sh
./tools/setup/student-workspace-init.sh

# Verify the setup
./tools/testing/validate-student-work.sh --quick
```

### Problem: Permission Denied Errors

**Symptoms:**
```
Permission denied (publickey)
```

**Solution:**
```bash
# Check if you have SSH keys set up
ls -la ~/.ssh/

# If no SSH keys, generate them
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add SSH key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Add the public key to your GitHub account
cat ~/.ssh/id_ed25519.pub
# Copy this output and add it to GitHub Settings > SSH Keys

# Test SSH connection
ssh -T git@github.com
```

---

## Daily Workflow Problems

### Problem: Working on Wrong Branch

**Symptoms:**
- Changes appear in course content files
- Validation warnings about protected files

**Solution:**
```bash
# Check current branch
git branch --show-current

# If not on personal-work, switch to it
git checkout personal-work

# If you made changes on the wrong branch, stash them first
git stash
git checkout personal-work
git stash pop
```

### Problem: Can't Switch Branches Due to Uncommitted Changes

**Symptoms:**
```
error: Your local changes to the following files would be overwritten by checkout
```

**Solution:**
```bash
# Option 1: Commit your changes
git add .
git commit -m "WIP: Save current progress"
git checkout personal-work

# Option 2: Stash your changes
git stash
git checkout personal-work
git stash pop  # Apply stashed changes

# Option 3: Discard changes (BE CAREFUL!)
git checkout -- .  # This will lose your changes!
git checkout personal-work
```

### Problem: Accidentally Modified Course Content

**Symptoms:**
- Validation shows warnings about protected files
- Git shows changes to README.md or exercise files

**Solution:**
```bash
# Check what files were modified
git status

# Restore course content files to original state
git checkout HEAD -- modules/m1-foundation/README.md
git checkout HEAD -- modules/m1-foundation/exercises/

# For all course content files
git checkout HEAD -- resources/ docs/ assessment/

# Verify restoration
./tools/testing/validate-student-work.sh --quick
```

### Problem: Large Files or Too Many Files

**Symptoms:**
- Git operations are slow
- Validation warnings about file sizes
- Repository becomes very large

**Solution:**
```bash
# Find large files
find . -type f -size +10M -not -path "./.git/*"

# Find files in student workspace
find modules/*/student-work -type f -size +5M

# Remove large files and use .gitignore
echo "*.bin" >> .gitignore
echo "*.exe" >> .gitignore
echo "*.o" >> .gitignore
git add .gitignore
git commit -m "Add gitignore for binary files"

# Clean up repository
git gc --aggressive
```

---

## Course Update Issues

### Problem: Update Script Fails to Run

**Symptoms:**
```
Permission denied: ./tools/git-workflow/semester-update.sh
```

**Solution:**
```bash
# Make script executable
chmod +x ./tools/git-workflow/semester-update.sh

# Run the script
./tools/git-workflow/semester-update.sh --interactive
```

### Problem: "No Updates Available" When You Know There Are Updates

**Symptoms:**
- Instructor announced updates but script says none available

**Solution:**
```bash
# Manually fetch upstream
git fetch upstream

# Check if upstream exists
git remote -v

# If upstream is missing, add it
git remote add upstream https://github.com/ARM-Assembly-University/ARM-Assembly-Language-University.git
git fetch upstream

# Try update again
./tools/git-workflow/semester-update.sh --check
```

### Problem: Update Fails Due to Uncommitted Changes

**Symptoms:**
```
error: You have uncommitted changes
```

**Solution:**
```bash
# Check what's uncommitted
git status

# Option 1: Commit your changes
git add .
git commit -m "Save work before update"

# Option 2: Stash your changes
git stash
# Run update
./tools/git-workflow/semester-update.sh --interactive
# Restore changes
git stash pop

# Then run the update
./tools/git-workflow/semester-update.sh --interactive
```

### Problem: Update Creates Unexpected Conflicts

**Symptoms:**
- Many files show conflicts
- Automatic resolution fails

**Solution:**
```bash
# Don't panic! Your work is backed up
# Check available backups
./tools/git-workflow/backup-manager.sh --list

# Use interactive conflict resolution
./tools/git-workflow/resolve-conflicts.sh --interactive

# If that fails, restore from backup and try again
./tools/git-workflow/backup-manager.sh --restore backup/YYYYMMDD-HHMMSS-pre-update
```

---

## Merge Conflicts

### Problem: Understanding Conflict Markers

**Symptoms:**
```
<<<<<<< HEAD
Your version of the code
=======
Their version of the code
>>>>>>> upstream/main
```

**Solution:**
1. **Understand the markers:**
   - `<<<<<<< HEAD` - Start of your changes
   - `=======` - Separator
   - `>>>>>>> upstream/main` - End of upstream changes

2. **Resolve manually:**
   ```bash
   # Edit the file to remove markers and keep desired content
   # Remove ALL conflict markers: <<<<<<< ======= >>>>>>>
   
   # After editing, stage the resolved file
   git add filename.s
   
   # Continue the merge
   git commit
   ```

### Problem: Too Many Conflicts to Resolve Manually

**Symptoms:**
- Dozens of conflicted files
- Overwhelmed by conflict resolution

**Solution:**
```bash
# Use the automated conflict resolver
./tools/git-workflow/resolve-conflicts.sh --auto

# If some conflicts remain, use interactive mode
./tools/git-workflow/resolve-conflicts.sh --interactive

# As a last resort, abort and restore from backup
git merge --abort
./tools/git-workflow/backup-manager.sh --restore backup/YYYYMMDD-HHMMSS-pre-update
```

### Problem: Conflict in Student Workspace Files

**Symptoms:**
- Conflicts in your student-work directories
- Your solutions conflict with course updates

**Solution:**
```bash
# This shouldn't happen often, but if it does:
# Your version should always win in student workspace

# For student-work files, keep your version
git checkout --ours modules/m1-foundation/student-work/exercises/your-file.s
git add modules/m1-foundation/student-work/exercises/your-file.s

# For personal-notes, keep your version
git checkout --ours modules/m1-foundation/personal-notes/
git add modules/m1-foundation/personal-notes/

# Continue the merge
git commit
```

---

## Backup and Recovery

### Problem: No Backups Available

**Symptoms:**
```
No backup branches found
```

**Solution:**
```bash
# Create a backup now
./tools/git-workflow/backup-manager.sh --create "emergency-backup"

# Check if there are any backup branches
git branch | grep backup

# If no backups exist, your current state becomes the backup
# Make sure to commit any important work
git add .
git commit -m "Emergency save of current work"
```

### Problem: Backup Restore Fails

**Symptoms:**
```
error: backup branch not found
```

**Solution:**
```bash
# List all branches to see what's available
git branch -a

# Check backup registry
cat tools/git-workflow/logs/backup-registry.log

# If backup branch exists but restore fails
git checkout backup/YYYYMMDD-HHMMSS-type
git checkout -b recovery-branch
git checkout personal-work
git merge recovery-branch
```

### Problem: Backup is Too Old

**Symptoms:**
- Latest backup is missing recent work
- Need to recover specific files

**Solution:**
```bash
# Check Git reflog for recent commits
git reflog

# Find the commit you want to recover
git show HEAD@{n}  # where n is the number from reflog

# Create a branch from that commit
git branch recovery-branch HEAD@{n}

# Cherry-pick specific commits
git cherry-pick commit-hash

# Or restore specific files
git checkout HEAD@{n} -- path/to/file
```

---

## Workspace Corruption

### Problem: Missing Student Workspace Directories

**Symptoms:**
- student-work directories don't exist
- Validation fails with directory structure errors

**Solution:**
```bash
# Re-run workspace initialization
./tools/setup/student-workspace-init.sh

# If that fails, create directories manually
mkdir -p modules/m1-foundation/student-work/{exercises,projects,experiments}
mkdir -p modules/m1-foundation/personal-notes/{module-notes,research,debugging-logs}

# Repeat for other modules
for module in m2-data-registers m3-basic-instruction-set m4-memory-data-structures m5-control-flow-structure m6-advanced-features m7-optimization-debugging m8-applications-capstone; do
    mkdir -p modules/$module/student-work/{exercises,projects,experiments}
    mkdir -p modules/$module/personal-notes/{module-notes,research,debugging-logs}
done

# Validate the structure
./tools/testing/validate-student-work.sh
```

### Problem: Git Repository Corruption

**Symptoms:**
```
fatal: bad object
error: Could not read
```

**Solution:**
```bash
# Try to repair the repository
git fsck --full

# If that fails, clone a fresh copy
cd ..
git clone https://github.com/yourusername/ARM-Assembly-Language-University.git ARM-Assembly-Language-University-new
cd ARM-Assembly-Language-University-new

# Copy your student work from the old repository
cp -r ../ARM-Assembly-Language-University/modules/*/student-work/ modules/
cp -r ../ARM-Assembly-Language-University/modules/*/personal-notes/ modules/

# Re-initialize the workspace
./tools/setup/student-workspace-init.sh
```

### Problem: Validation Consistently Fails

**Symptoms:**
- Multiple validation errors
- Can't identify the root cause

**Solution:**
```bash
# Run full validation with detailed output
./tools/testing/validate-student-work.sh --full

# Check the validation log
cat tools/git-workflow/logs/validation-*.log | tail -50

# Reset to a known good state
git checkout main
./tools/setup/student-workspace-init.sh

# Restore your work from backup
./tools/git-workflow/backup-manager.sh --list
./tools/git-workflow/backup-manager.sh --restore backup/YYYYMMDD-HHMMSS-type
```

---

## Git Configuration Problems

### Problem: Git User Not Configured

**Symptoms:**
```
Please tell me who you are
```

**Solution:**
```bash
# Set your Git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify configuration
git config --list | grep user
```

### Problem: Wrong Remote URLs

**Symptoms:**
- Can't push to origin
- Can't fetch from upstream

**Solution:**
```bash
# Check current remotes
git remote -v

# Fix origin URL (replace with your fork URL)
git remote set-url origin https://github.com/yourusername/ARM-Assembly-Language-University.git

# Fix upstream URL
git remote set-url upstream https://github.com/ARM-Assembly-University/ARM-Assembly-Language-University.git

# Verify changes
git remote -v
```

### Problem: Authentication Issues

**Symptoms:**
```
Authentication failed
```

**Solution:**
```bash
# For HTTPS (use personal access token)
git config --global credential.helper store
# Next push/pull will prompt for username and token

# For SSH (check SSH key)
ssh -T git@github.com

# If SSH fails, check if key is added to ssh-agent
ssh-add -l

# Add key if needed
ssh-add ~/.ssh/id_ed25519
```

---

## File and Directory Issues

### Problem: Files Not Being Tracked by Git

**Symptoms:**
- Files don't appear in `git status`
- Changes not being committed

**Solution:**
```bash
# Check if files are in .gitignore
cat .gitignore | grep filename

# Check if files are in student workspace
ls -la modules/m1-foundation/student-work/exercises/

# Force add if needed (be careful!)
git add -f filename.s

# Check file permissions
ls -la filename.s
chmod 644 filename.s  # Make readable/writable
```

### Problem: Binary Files in Repository

**Symptoms:**
- Repository size growing rapidly
- Validation warnings about file types

**Solution:**
```bash
# Find binary files
find . -type f -exec file {} \; | grep -v text | grep -v directory

# Remove binary files
git rm *.exe *.bin *.o

# Add to .gitignore
echo "*.exe" >> .gitignore
echo "*.bin" >> .gitignore
echo "*.o" >> .gitignore

# Commit changes
git add .gitignore
git commit -m "Remove binary files and update gitignore"
```

### Problem: File Encoding Issues

**Symptoms:**
- Strange characters in files
- Assembly files won't compile

**Solution:**
```bash
# Check file encoding
file -bi filename.s

# Convert to UTF-8 if needed
iconv -f ISO-8859-1 -t UTF-8 filename.s > filename_utf8.s
mv filename_utf8.s filename.s

# Or use dos2unix for line ending issues
dos2unix filename.s
```

---

## Performance and Storage Issues

### Problem: Git Operations Are Very Slow

**Symptoms:**
- `git status` takes a long time
- Push/pull operations timeout

**Solution:**
```bash
# Clean up repository
git gc --aggressive --prune=now

# Check repository size
du -sh .git/

# Remove large files from history (DANGEROUS - backup first!)
git filter-branch --tree-filter 'rm -f large-file.bin' HEAD

# Or use BFG Repo-Cleaner for better performance
# Download BFG and run:
# java -jar bfg.jar --strip-blobs-bigger-than 10M
```

### Problem: Running Out of Disk Space

**Symptoms:**
- Git operations fail with "No space left on device"
- Can't create new files

**Solution:**
```bash
# Check disk usage
df -h

# Clean up Git repository
git gc --aggressive
git prune

# Remove old backup branches
./tools/git-workflow/backup-manager.sh --cleanup 7  # Keep only 7 days

# Remove temporary files
find . -name "*.tmp" -delete
find . -name "*.temp" -delete
find . -name "*~" -delete
```

---

## Emergency Recovery Procedures

### Complete Workspace Reset

**When to use:** Everything is broken and you need to start fresh

**Steps:**
```bash
# 1. Create emergency backup of current state
git branch emergency-backup-$(date +%Y%m%d-%H%M%S)

# 2. List any existing backups
./tools/git-workflow/backup-manager.sh --list

# 3. Reset to main branch
git checkout main
git reset --hard upstream/main

# 4. Re-initialize workspace
./tools/setup/student-workspace-init.sh

# 5. Restore your work from backup
./tools/git-workflow/backup-manager.sh --restore backup/YYYYMMDD-HHMMSS-type

# 6. Validate everything is working
./tools/testing/validate-student-work.sh
```

### Nuclear Option: Fresh Clone

**When to use:** Repository is completely corrupted

**Steps:**
```bash
# 1. Backup your student work manually
cp -r modules/*/student-work ~/backup-student-work
cp -r modules/*/personal-notes ~/backup-personal-notes

# 2. Clone fresh repository
cd ..
git clone https://github.com/yourusername/ARM-Assembly-Language-University.git ARM-Assembly-New
cd ARM-Assembly-New

# 3. Initialize workspace
./tools/setup/student-workspace-init.sh

# 4. Restore your work
cp -r ~/backup-student-work/* modules/*/student-work/
cp -r ~/backup-personal-notes/* modules/*/personal-notes/

# 5. Commit restored work
git add .
git commit -m "Restore student work after repository reset"
git push origin personal-work
```

### Recovering Lost Commits

**When to use:** You accidentally lost commits

**Steps:**
```bash
# 1. Check reflog for lost commits
git reflog

# 2. Find the commit you want to recover
git show HEAD@{n}  # Check each entry

# 3. Create a branch from the lost commit
git branch recovery HEAD@{n}

# 4. Merge the recovered work
git checkout personal-work
git merge recovery

# 5. Clean up
git branch -d recovery
```

---

## Getting Help

### Self-Diagnosis Checklist

Before asking for help, try these steps:

1. **Check your current state:**
   ```bash
   git status
   git branch --show-current
   pwd
   ```

2. **Run validation:**
   ```bash
   ./tools/testing/validate-student-work.sh --quick
   ```

3. **Check logs:**
   ```bash
   ls tools/git-workflow/logs/
   tail tools/git-workflow/logs/validation-*.log
   ```

4. **Verify backups:**
   ```bash
   ./tools/git-workflow/backup-manager.sh --list
   ```

### Information to Gather

When asking for help, provide:

- **Error message** (exact text)
- **What you were trying to do**
- **Current branch** (`git branch --show-current`)
- **Git status** (`git status`)
- **Recent commands** you ran
- **Validation output** (if relevant)

### Support Resources

- **Course Documentation**: `docs/` directory
- **ARM Manual Guide**: `resources/arm-manual-guide/`
- **LLM Integration**: `llm-integration/` for research assistant setup
- **Main Workflow Guide**: [`STUDENT-GIT-WORKFLOW.md`](STUDENT-GIT-WORKFLOW.md)
- **Quick Reference**: [`STUDENT-QUICK-REFERENCE.md`](STUDENT-QUICK-REFERENCE.md)

---

## Prevention Tips

### Daily Habits to Avoid Problems

1. **Always work on personal-work branch**
2. **Commit frequently with good messages**
3. **Run validation regularly**
4. **Create backups before major changes**
5. **Keep your work in student workspace directories**
6. **Don't modify course content files**

### Weekly Maintenance

1. **Check for course updates**
2. **Create weekly backups**
3. **Clean up old backups**
4. **Validate workspace health**
5. **Push all work to your fork**

---

**Remember**: This workflow is designed to be safe and recoverable. When in doubt, create a backup and ask for help!

*Most problems have simple solutions - don't panic and work through the troubleshooting steps systematically.*
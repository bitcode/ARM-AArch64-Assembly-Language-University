# Git Workflow for ARM Assembly Language University

This directory contains the Git workflow automation tools for the ARM Assembly Language University course repository.

## 📖 Student Documentation

**For Students**: Please refer to the comprehensive student-friendly documentation:
- **[Student Git Workflow Guide](../../STUDENT-GIT-WORKFLOW.md)** - Complete workflow explanation with examples
- **[Quick Reference](../../STUDENT-QUICK-REFERENCE.md)** - Daily commands and tips
- **[Troubleshooting Guide](../../STUDENT-TROUBLESHOOTING.md)** - Solutions to common issues

The documentation below is technical reference for instructors and advanced users.

## 🎯 Overview

The Git workflow implements a **fork-based dual-zone directory structure** that safely separates course content from student work, enabling seamless course updates while preserving student progress.

## 📁 Directory Structure

```
tools/git-workflow/
├── README.md                    # This documentation
├── workflow-config.yaml         # Workflow configuration
├── resolve-conflicts.sh         # Automated conflict resolution
├── semester-update.sh           # Course content updates
├── backup-manager.sh            # Backup management
└── logs/                        # Operation logs and reports
```

## 🚀 Quick Start

### 1. Initialize Student Workspace
```bash
# Run once to set up your student workspace
./tools/setup/student-workspace-init.sh
```

### 2. Update Course Content
```bash
# Check for and apply course updates
./tools/git-workflow/semester-update.sh --interactive
```

### 3. Manage Backups
```bash
# Create manual backup
./tools/git-workflow/backup-manager.sh --create "before-exercise-3"

# List all backups
./tools/git-workflow/backup-manager.sh --list
```

### 4. Validate Your Work
```bash
# Validate student workspace integrity
./tools/testing/validate-student-work.sh
```

## 🏗️ Dual-Zone Directory Structure

### Course Content Zone (Read-Only)
- `modules/*/README.md` - Module documentation
- `modules/*/exercises/*.s` - Base exercise files
- `resources/` - Reference materials
- `docs/` - Course documentation
- `assessment/` - Assessment materials

### Student Workspace Zone (Full Control)
- `modules/*/student-work/` - Your exercise solutions and projects
- `modules/*/personal-notes/` - Your learning notes and research
- `student-workspace/` - Top-level workspace for projects
- `personal-workspace/` - Personal notes and research

## 🌿 Branch Strategy

### Main Branches
- **`main`** - Synchronized with upstream course content (read-only)
- **`personal-work`** - Your primary working branch (full control)

### Automatic Branches
- **`course-updates-*`** - Temporary branches for merging updates
- **`backup/*`** - Automated backups of your work

## 🔧 Workflow Scripts

### Student Workspace Initialization
**File**: `tools/setup/student-workspace-init.sh`

Initializes the dual-zone directory structure and Git workflow:
- Creates student workspace directories
- Sets up Git remotes and branches
- Configures Git hooks for validation
- Creates initial README files

**Usage**:
```bash
./tools/setup/student-workspace-init.sh
```

### Conflict Resolution
**File**: `tools/git-workflow/resolve-conflicts.sh`

Intelligently resolves merge conflicts based on file patterns:
- Automatically favors student changes in workspace areas
- Favors upstream changes in course content areas
- Provides interactive resolution for complex conflicts

**Usage**:
```bash
# Automatic resolution
./tools/git-workflow/resolve-conflicts.sh --auto

# Interactive step-by-step resolution
./tools/git-workflow/resolve-conflicts.sh --interactive

# Analyze conflicts without resolving
./tools/git-workflow/resolve-conflicts.sh --analyze
```

### Semester Updates
**File**: `tools/git-workflow/semester-update.sh`

Safely updates course content while preserving student work:
- Creates pre-update backups
- Fetches and analyzes upstream changes
- Applies intelligent conflict resolution
- Validates update results

**Usage**:
```bash
# Interactive update (recommended for beginners)
./tools/git-workflow/semester-update.sh --interactive

# Automatic update (for experienced users)
./tools/git-workflow/semester-update.sh --auto

# Check for updates without applying
./tools/git-workflow/semester-update.sh --check
```

### Backup Management
**File**: `tools/git-workflow/backup-manager.sh`

Manages automated and manual backups of student work:
- Creates timestamped backup branches
- Implements intelligent retention policies
- Provides restore and comparison capabilities
- Tracks backup history

**Usage**:
```bash
# Create manual backup
./tools/git-workflow/backup-manager.sh --create "description"

# List all backups
./tools/git-workflow/backup-manager.sh --list

# Restore from backup
./tools/git-workflow/backup-manager.sh --restore backup/20231215-manual

# Interactive management
./tools/git-workflow/backup-manager.sh --interactive
```

### Student Work Validation
**File**: `tools/testing/validate-student-work.sh`

Validates workspace integrity and detects issues:
- Checks directory structure
- Validates file integrity
- Detects unauthorized course content modifications
- Ensures Git repository health

**Usage**:
```bash
# Full validation
./tools/testing/validate-student-work.sh

# Quick validation
./tools/testing/validate-student-work.sh --quick

# Quiet mode (minimal output)
./tools/testing/validate-student-work.sh --quiet
```

## ⚙️ Configuration

### Workflow Configuration
**File**: `tools/git-workflow/workflow-config.yaml`

Central configuration for all workflow components:
- Repository and branch settings
- Directory zone definitions
- Conflict resolution rules
- Automation settings
- Validation rules

### Git Configuration Files
- **`.gitignore`** - Enhanced patterns for student workspace
- **`.gitattributes`** - Merge strategies and conflict resolution rules

## 🔍 Conflict Resolution Rules

### Automatic Resolution Strategies

| File Pattern | Strategy | Description |
|--------------|----------|-------------|
| `modules/*/student-work/**` | `ours` | Always keep student version |
| `modules/*/personal-notes/**` | `ours` | Always keep student version |
| `modules/*/README.md` | `theirs` | Always use course version |
| `resources/**` | `theirs` | Always use course version |
| `.gitignore` | `union` | Combine both versions |
| `Makefile` | `union` | Combine both versions |

### Manual Resolution Required
- Complex configuration files
- Files with conflicting logic
- Custom build scripts with modifications

## 📊 Logging and Monitoring

### Log Files
All operations are logged to `tools/git-workflow/logs/`:
- `workspace-init-*.log` - Initialization logs
- `semester-update-*.log` - Update operation logs
- `conflict-resolution-*.log` - Conflict resolution logs
- `backup-manager-*.log` - Backup operation logs
- `validation-*.log` - Validation logs

### Reports
- `validation-report-*.md` - Detailed validation reports
- `update-summary-*.md` - Semester update summaries
- `backup-registry.log` - Backup history tracking

## 🚨 Troubleshooting

### Common Issues

#### 1. Merge Conflicts
**Symptoms**: Git reports conflicts during updates
**Solution**: Run conflict resolver
```bash
./tools/git-workflow/resolve-conflicts.sh --interactive
```

#### 2. Missing Student Workspace
**Symptoms**: Validation fails, directories missing
**Solution**: Re-run workspace initialization
```bash
./tools/setup/student-workspace-init.sh
```

#### 3. Upstream Sync Issues
**Symptoms**: Cannot fetch upstream changes
**Solution**: Check upstream remote configuration
```bash
git remote -v
git remote add upstream <upstream-url>
```

#### 4. Backup Restore Needed
**Symptoms**: Work accidentally lost or corrupted
**Solution**: Restore from backup
```bash
./tools/git-workflow/backup-manager.sh --list
./tools/git-workflow/backup-manager.sh --restore <backup-name>
```

### Recovery Procedures

#### Complete Workspace Reset
If your workspace becomes corrupted:
1. Create emergency backup: `git branch emergency-backup`
2. Reset to known good state: `git reset --hard upstream/main`
3. Re-initialize workspace: `./tools/setup/student-workspace-init.sh`
4. Restore student work from backup

#### Conflict Resolution Failure
If automatic conflict resolution fails:
1. Review manual resolution guide: `tools/git-workflow/logs/manual-resolution-guide.md`
2. Edit conflicted files manually
3. Remove all conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
4. Test your changes
5. Complete merge: `git add . && git commit`

## 🎓 Best Practices

### Daily Workflow
1. Start on `personal-work` branch
2. Work in student workspace directories
3. Commit frequently with descriptive messages
4. Run validation before major commits

### Weekly Maintenance
1. Check for course updates: `./tools/git-workflow/semester-update.sh --check`
2. Create weekly backup: `./tools/git-workflow/backup-manager.sh --create "week-X"`
3. Clean old backups: `./tools/git-workflow/backup-manager.sh --cleanup`
4. Validate workspace: `./tools/testing/validate-student-work.sh`

### Before Major Updates
1. Create pre-update backup
2. Commit all current work
3. Run validation to ensure clean state
4. Use interactive update mode for safety

## 🔗 Integration with Course

### LLM Research Assistant
The workflow integrates with LLM research assistants:
- Validation reports provide context for debugging help
- Conflict resolution guides assist with problem-solving
- Backup history helps track learning progress

### Course Assessment
- Student workspace preserves all work for portfolio review
- Validation ensures submission integrity
- Backup history demonstrates consistent progress

## 📚 Additional Resources

- **Course Documentation**: `docs/`
- **ARM Manual Guide**: `resources/arm-manual-guide/`
- **LLM Integration**: `llm-integration/`
- **Troubleshooting**: `troubleshooting/`

## 🆘 Getting Help

1. **Check logs**: Review operation logs in `tools/git-workflow/logs/`
2. **Run validation**: Use `validate-student-work.sh` to identify issues
3. **Consult documentation**: Review course materials and guides
4. **Use LLM assistant**: Ask for help with specific error messages
5. **Course forums**: Seek help from instructors and peers

---

**Remember**: This workflow is designed to be safe and forgiving. When in doubt, create a backup before making changes!
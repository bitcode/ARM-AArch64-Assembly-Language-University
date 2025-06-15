#!/bin/bash

# =============================================================================
# ARM Assembly Language University - Student Workspace Initialization
# =============================================================================
# This script sets up the dual-zone directory structure and initializes
# the Git workflow for student use.

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_FILE="$REPO_ROOT/tools/git-workflow/workflow-config.yaml"
LOG_DIR="$REPO_ROOT/tools/git-workflow/logs"
LOG_FILE="$LOG_DIR/workspace-init-$(date +%Y%m%d-%H%M%S).log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Output functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
    log "HEADER: $1"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
    log "SUCCESS: $1"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
    log "WARNING: $1"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    log "ERROR: $1"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
    log "INFO: $1"
}

# Check if we're in a Git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a Git repository. Please run this script from the course repository root."
        exit 1
    fi
    print_success "Git repository detected"
}

# Check if upstream remote exists
check_upstream_remote() {
    if git remote | grep -q "^upstream$"; then
        print_success "Upstream remote already configured"
        return 0
    else
        print_warning "Upstream remote not configured"
        return 1
    fi
}

# Configure upstream remote
configure_upstream() {
    print_info "Configuring upstream remote..."
    
    # Try to detect the original repository URL
    local origin_url=$(git remote get-url origin 2>/dev/null || echo "")
    local upstream_url=""
    
    if [[ "$origin_url" =~ github\.com[:/]([^/]+)/Arm-Assembly-Language-University ]]; then
        local username="${BASH_REMATCH[1]}"
        if [[ "$username" != "ARM-Assembly-University" ]]; then
            upstream_url="https://github.com/ARM-Assembly-University/Arm-Assembly-Language-University.git"
        fi
    fi
    
    if [[ -z "$upstream_url" ]]; then
        echo -e "${YELLOW}Please enter the upstream repository URL:${NC}"
        read -p "Upstream URL: " upstream_url
    fi
    
    if [[ -n "$upstream_url" ]]; then
        git remote add upstream "$upstream_url"
        print_success "Upstream remote configured: $upstream_url"
    else
        print_warning "Upstream remote not configured - you may need to set this manually"
    fi
}

# Create student workspace directories
create_workspace_directories() {
    print_info "Creating student workspace directories..."
    
    local modules=(
        "m1-foundation"
        "m2-data-registers" 
        "m3-basic-instruction-set"
        "m4-memory-data-structures"
        "m5-control-flow-structure"
        "m6-advanced-features"
        "m7-optimization-debugging"
        "m8-applications-capstone"
    )
    
    for module in "${modules[@]}"; do
        local module_path="$REPO_ROOT/modules/$module"
        if [[ -d "$module_path" ]]; then
            # Create student-work subdirectories
            mkdir -p "$module_path/student-work/exercises"
            mkdir -p "$module_path/student-work/projects"
            mkdir -p "$module_path/student-work/experiments"
            
            # Create personal-notes subdirectories
            mkdir -p "$module_path/personal-notes/module-notes"
            mkdir -p "$module_path/personal-notes/research"
            mkdir -p "$module_path/personal-notes/debugging-logs"
            
            print_success "Created workspace directories for $module"
        else
            print_warning "Module directory not found: $module"
        fi
    done
    
    # Create top-level workspace directories
    mkdir -p "$REPO_ROOT/student-workspace/projects"
    mkdir -p "$REPO_ROOT/student-workspace/experiments"
    mkdir -p "$REPO_ROOT/personal-workspace/notes"
    mkdir -p "$REPO_ROOT/personal-workspace/research"
    
    print_success "Created top-level workspace directories"
}

# Create workspace README files
create_workspace_readmes() {
    print_info "Creating workspace README files..."
    
    # Student work README template
    local student_readme="$REPO_ROOT/modules/m1-foundation/student-work/README.md"
    if [[ ! -f "$student_readme" ]]; then
        cat > "$student_readme" << 'EOF'
# Student Work Directory

This directory is for your personal solutions, experiments, and projects related to this module.

## Directory Structure

- **exercises/**: Your solutions to module exercises
- **projects/**: Personal projects and extended implementations
- **experiments/**: Code experiments and learning explorations

## Guidelines

- This directory is **student-owned** - your changes will be preserved during course updates
- Feel free to organize your work as you prefer
- Consider using descriptive filenames for your solutions
- Document your learning process and insights

## Git Workflow

- Your work in this directory will not conflict with course updates
- Changes here are automatically backed up to your backup branches
- This directory is ignored by upstream merges

## Tips

- Use meaningful commit messages for your work
- Experiment freely - this is your learning space
- Keep notes about what you learn from each exercise
EOF
        print_success "Created student work README template"
    fi
    
    # Personal notes README template
    local notes_readme="$REPO_ROOT/modules/m1-foundation/personal-notes/README.md"
    if [[ ! -f "$notes_readme" ]]; then
        cat > "$notes_readme" << 'EOF'
# Personal Notes Directory

This directory is for your personal learning notes, research, and documentation.

## Directory Structure

- **module-notes/**: Your notes and insights about module concepts
- **research/**: Additional research and external resources
- **debugging-logs/**: Debugging sessions and problem-solving notes

## Guidelines

- This directory is **student-owned** - completely under your control
- Use any format you prefer (Markdown, text files, etc.)
- Document your learning journey and insights
- Keep track of resources and references

## Suggestions

- Take notes during exercises and experiments
- Document debugging processes and solutions
- Keep track of useful resources and references
- Reflect on your learning progress

## Privacy

- These notes are private to your fork
- Not shared with instructors unless you choose to
- Safe space for honest reflection and learning
EOF
        print_success "Created personal notes README template"
    fi
    
    # Copy README templates to other modules
    local modules=(
        "m2-data-registers" 
        "m3-basic-instruction-set"
        "m4-memory-data-structures"
        "m5-control-flow-structure"
        "m6-advanced-features"
        "m7-optimization-debugging"
        "m8-applications-capstone"
    )
    
    for module in "${modules[@]}"; do
        local module_path="$REPO_ROOT/modules/$module"
        if [[ -d "$module_path" ]]; then
            cp "$student_readme" "$module_path/student-work/README.md" 2>/dev/null || true
            cp "$notes_readme" "$module_path/personal-notes/README.md" 2>/dev/null || true
        fi
    done
}

# Create student configuration file
create_student_config() {
    print_info "Creating student configuration..."
    
    local config_file="$REPO_ROOT/.student-config"
    if [[ ! -f "$config_file" ]]; then
        cat > "$config_file" << EOF
# Student Workspace Configuration
# This file tracks your personal workspace setup

[workspace]
initialized_date = $(date -u +"%Y-%m-%dT%H:%M:%SZ")
git_user = $(git config user.name 2>/dev/null || echo "Not configured")
git_email = $(git config user.email 2>/dev/null || echo "Not configured")

[preferences]
auto_backup = true
backup_frequency = daily
sync_notifications = true

[directories]
student_work_created = true
personal_notes_created = true
workspace_structure = dual-zone

[git_workflow]
upstream_configured = $(check_upstream_remote >/dev/null 2>&1 && echo "true" || echo "false")
branch_strategy = fork-based
conflict_resolution = configured
EOF
        print_success "Created student configuration file"
    else
        print_info "Student configuration already exists"
    fi
}

# Set up Git hooks
setup_git_hooks() {
    print_info "Setting up Git hooks..."
    
    local hooks_dir="$REPO_ROOT/.git/hooks"
    
    # Pre-commit hook for validation
    cat > "$hooks_dir/pre-commit" << 'EOF'
#!/bin/bash
# Student workspace validation pre-commit hook

REPO_ROOT="$(git rev-parse --show-toplevel)"
VALIDATION_SCRIPT="$REPO_ROOT/tools/testing/validate-student-work.sh"

if [[ -f "$VALIDATION_SCRIPT" ]]; then
    echo "Running student work validation..."
    if ! "$VALIDATION_SCRIPT"; then
        echo "Validation failed. Commit aborted."
        exit 1
    fi
fi

exit 0
EOF
    chmod +x "$hooks_dir/pre-commit"
    
    # Pre-push hook for backup
    cat > "$hooks_dir/pre-push" << 'EOF'
#!/bin/bash
# Automatic backup before push

REPO_ROOT="$(git rev-parse --show-toplevel)"
BACKUP_SCRIPT="$REPO_ROOT/tools/git-workflow/backup-manager.sh"

if [[ -f "$BACKUP_SCRIPT" ]]; then
    echo "Creating backup before push..."
    "$BACKUP_SCRIPT" --auto-backup
fi

exit 0
EOF
    chmod +x "$hooks_dir/pre-push"
    
    print_success "Git hooks configured"
}

# Create initial branches
setup_branches() {
    print_info "Setting up Git branches..."
    
    local current_branch=$(git branch --show-current)
    
    # Ensure we're on main branch
    if [[ "$current_branch" != "main" ]]; then
        if git show-ref --verify --quiet refs/heads/main; then
            git checkout main
        else
            print_warning "Main branch not found, staying on current branch: $current_branch"
        fi
    fi
    
    # Create personal-work branch if it doesn't exist
    if ! git show-ref --verify --quiet refs/heads/personal-work; then
        git checkout -b personal-work
        print_success "Created personal-work branch"
        git checkout main
    else
        print_info "personal-work branch already exists"
    fi
    
    # Switch to personal-work branch for student use
    git checkout personal-work
    print_success "Switched to personal-work branch"
}

# Main initialization function
main() {
    print_header "ARM Assembly Language University - Student Workspace Initialization"
    
    print_info "Starting workspace initialization..."
    print_info "Repository root: $REPO_ROOT"
    print_info "Log file: $LOG_FILE"
    
    # Perform initialization steps
    check_git_repo
    
    if ! check_upstream_remote; then
        configure_upstream
    fi
    
    create_workspace_directories
    create_workspace_readmes
    create_student_config
    setup_git_hooks
    setup_branches
    
    print_header "Initialization Complete!"
    
    echo -e "${GREEN}Your student workspace has been successfully initialized!${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo "1. You are now on the 'personal-work' branch - this is your main working branch"
    echo "2. Your student work directories have been created in each module"
    echo "3. Personal notes directories are ready for your learning documentation"
    echo "4. Git hooks are configured for automatic validation and backup"
    echo ""
    echo -e "${CYAN}Directory structure:${NC}"
    echo "- modules/*/student-work/     - Your exercise solutions and projects"
    echo "- modules/*/personal-notes/   - Your learning notes and research"
    echo "- student-workspace/          - Top-level workspace for projects"
    echo "- personal-workspace/         - Personal notes and research"
    echo ""
    echo -e "${CYAN}Useful commands:${NC}"
    echo "- git checkout main           - Switch to course content branch"
    echo "- git checkout personal-work  - Switch to your working branch"
    echo "- tools/git-workflow/semester-update.sh  - Update course content"
    echo "- tools/git-workflow/backup-manager.sh   - Manage backups"
    echo ""
    echo -e "${YELLOW}Remember: Your work in student-work/ and personal-notes/ directories"
    echo "will be preserved during course updates!${NC}"
    
    log "Workspace initialization completed successfully"
}

# Run main function
main "$@"
#!/bin/bash

# =============================================================================
# ARM Assembly Language University - Backup Manager
# =============================================================================
# This script manages automated backups of student work with intelligent
# retention policies and recovery capabilities.

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_FILE="$REPO_ROOT/tools/git-workflow/workflow-config.yaml"
LOG_DIR="$REPO_ROOT/tools/git-workflow/logs"
LOG_FILE="$LOG_DIR/backup-manager-$(date +%Y%m%d-%H%M%S).log"
BACKUP_PREFIX="backup"
RETENTION_DAYS=30

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

print_step() {
    echo -e "${MAGENTA}▶ $1${NC}"
    log "STEP: $1"
}

# Check if we're in a Git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a Git repository"
        exit 1
    fi
}

# Get current branch
get_current_branch() {
    git branch --show-current
}

# Generate backup branch name
generate_backup_name() {
    local type="$1"
    local description="$2"
    local timestamp=$(date +%Y%m%d-%H%M%S)
    
    if [[ -n "$description" ]]; then
        echo "$BACKUP_PREFIX/$timestamp-$type-$description"
    else
        echo "$BACKUP_PREFIX/$timestamp-$type"
    fi
}

# Check if branch has uncommitted changes
has_uncommitted_changes() {
    ! git diff-index --quiet HEAD --
}

# Check if branch has untracked files in student workspace
has_untracked_student_files() {
    local untracked_files=$(git ls-files --others --exclude-standard)
    
    while IFS= read -r file; do
        if [[ -n "$file" ]] && \
           ([[ "$file" =~ ^modules/.*/student-work/ ]] || \
            [[ "$file" =~ ^modules/.*/personal-notes/ ]] || \
            [[ "$file" =~ ^student-workspace/ ]] || \
            [[ "$file" =~ ^personal-workspace/ ]]); then
            return 0  # Has untracked student files
        fi
    done <<< "$untracked_files"
    
    return 1  # No untracked student files
}

# Create backup branch
create_backup() {
    local backup_name="$1"
    local include_untracked="$2"
    local current_branch=$(get_current_branch)
    
    print_step "Creating backup: $backup_name"
    
    # Stash any uncommitted changes if needed
    local stash_created=false
    if has_uncommitted_changes; then
        print_info "Stashing uncommitted changes..."
        git stash push -m "Backup stash for $backup_name"
        stash_created=true
    fi
    
    # Handle untracked files if requested
    if [[ "$include_untracked" == "true" ]] && has_untracked_student_files; then
        print_info "Adding untracked student files..."
        
        # Add only student workspace files
        git ls-files --others --exclude-standard | while IFS= read -r file; do
            if [[ -n "$file" ]] && \
               ([[ "$file" =~ ^modules/.*/student-work/ ]] || \
                [[ "$file" =~ ^modules/.*/personal-notes/ ]] || \
                [[ "$file" =~ ^student-workspace/ ]] || \
                [[ "$file" =~ ^personal-workspace/ ]]); then
                git add "$file"
            fi
        done
        
        # Commit the untracked files
        if ! git diff-index --quiet --cached HEAD --; then
            git commit -m "Add untracked student files for backup $backup_name"
        fi
    fi
    
    # Create the backup branch
    git branch "$backup_name"
    
    # Restore stashed changes if we created a stash
    if [[ "$stash_created" == "true" ]]; then
        print_info "Restoring stashed changes..."
        git stash pop
    fi
    
    print_success "Backup created: $backup_name"
    
    # Log backup details
    local commit_hash=$(git rev-parse "$backup_name")
    local commit_message=$(git log -1 --pretty=format:"%s" "$backup_name")
    
    cat >> "$LOG_DIR/backup-registry.log" << EOF
$(date -u +"%Y-%m-%dT%H:%M:%SZ") | $backup_name | $commit_hash | $current_branch | $commit_message
EOF
    
    echo "$backup_name" > "$LOG_DIR/last-backup"
}

# List all backup branches
list_backups() {
    print_header "Backup Branches"
    
    local backup_branches=$(git branch | grep "^\s*$BACKUP_PREFIX/" | sed 's/^\s*//')
    
    if [[ -z "$backup_branches" ]]; then
        print_info "No backup branches found"
        return
    fi
    
    echo -e "${CYAN}Branch Name${NC} | ${CYAN}Date${NC} | ${CYAN}Age${NC} | ${CYAN}Description${NC}"
    echo "----------------------------------------"
    
    while IFS= read -r branch; do
        if [[ -n "$branch" ]]; then
            local branch_date=$(git log -1 --pretty=format:"%ci" "$branch" 2>/dev/null || echo "Unknown")
            local commit_message=$(git log -1 --pretty=format:"%s" "$branch" 2>/dev/null || echo "No message")
            local age=$(git log -1 --pretty=format:"%cr" "$branch" 2>/dev/null || echo "Unknown")
            
            echo "$branch | $branch_date | $age | $commit_message"
        fi
    done <<< "$backup_branches"
}

# Clean old backup branches
cleanup_old_backups() {
    local retention_days="$1"
    print_step "Cleaning up backups older than $retention_days days..."
    
    local deleted_count=0
    local backup_branches=$(git branch | grep "^\s*$BACKUP_PREFIX/" | sed 's/^\s*//')
    
    while IFS= read -r branch; do
        if [[ -n "$branch" ]]; then
            local branch_date=$(git log -1 --pretty=format:"%ct" "$branch" 2>/dev/null || echo "0")
            local current_date=$(date +%s)
            local age_days=$(( (current_date - branch_date) / 86400 ))
            
            if [[ $age_days -gt $retention_days ]]; then
                print_info "Deleting old backup: $branch (${age_days} days old)"
                git branch -D "$branch"
                ((deleted_count++))
            fi
        fi
    done <<< "$backup_branches"
    
    if [[ $deleted_count -gt 0 ]]; then
        print_success "Deleted $deleted_count old backup branches"
    else
        print_info "No old backups to clean up"
    fi
}

# Restore from backup
restore_from_backup() {
    local backup_name="$1"
    local target_branch="$2"
    
    print_step "Restoring from backup: $backup_name"
    
    # Verify backup branch exists
    if ! git show-ref --verify --quiet "refs/heads/$backup_name"; then
        print_error "Backup branch not found: $backup_name"
        return 1
    fi
    
    # Get current branch
    local current_branch=$(get_current_branch)
    
    # If target branch not specified, use current branch
    if [[ -z "$target_branch" ]]; then
        target_branch="$current_branch"
    fi
    
    # Warn about uncommitted changes
    if has_uncommitted_changes; then
        print_warning "You have uncommitted changes that will be lost!"
        echo -e "${YELLOW}Uncommitted files:${NC}"
        git status --porcelain
        echo ""
        read -p "Continue with restore? (y/N): " continue_choice
        if [[ ! "$continue_choice" =~ ^[Yy] ]]; then
            print_info "Restore cancelled"
            return 1
        fi
    fi
    
    # Create safety backup before restore
    local safety_backup=$(generate_backup_name "pre-restore" "$(basename "$backup_name")")
    create_backup "$safety_backup" false
    
    # Perform the restore
    print_info "Restoring to branch: $target_branch"
    
    if [[ "$target_branch" != "$current_branch" ]]; then
        git checkout "$target_branch" 2>/dev/null || git checkout -b "$target_branch"
    fi
    
    # Reset to backup state
    git reset --hard "$backup_name"
    
    print_success "Restored from backup: $backup_name"
    print_info "Safety backup created: $safety_backup"
}

# Compare backup with current state
compare_backup() {
    local backup_name="$1"
    
    print_step "Comparing with backup: $backup_name"
    
    # Verify backup branch exists
    if ! git show-ref --verify --quiet "refs/heads/$backup_name"; then
        print_error "Backup branch not found: $backup_name"
        return 1
    fi
    
    echo -e "${CYAN}Differences between current state and backup:${NC}"
    echo ""
    
    # Show file differences
    git diff --name-status "$backup_name" HEAD
    
    echo ""
    echo -e "${CYAN}Detailed diff (first 50 lines):${NC}"
    git diff "$backup_name" HEAD | head -50
    
    if [[ $(git diff "$backup_name" HEAD | wc -l) -gt 50 ]]; then
        echo "..."
        echo -e "${YELLOW}(Output truncated - use 'git diff $backup_name HEAD' for full diff)${NC}"
    fi
}

# Automatic backup based on schedule
auto_backup() {
    local backup_type="$1"
    
    print_step "Creating automatic backup..."
    
    # Check if we need to backup based on last backup time
    local last_backup_file="$LOG_DIR/last-auto-backup"
    local should_backup=true
    
    if [[ -f "$last_backup_file" ]]; then
        local last_backup_time=$(cat "$last_backup_file")
        local current_time=$(date +%s)
        local hours_since_backup=$(( (current_time - last_backup_time) / 3600 ))
        
        # Only backup if more than 4 hours have passed
        if [[ $hours_since_backup -lt 4 ]]; then
            print_info "Recent backup exists (${hours_since_backup}h ago), skipping auto-backup"
            should_backup=false
        fi
    fi
    
    if [[ "$should_backup" == "true" ]]; then
        local backup_name=$(generate_backup_name "auto" "$backup_type")
        create_backup "$backup_name" true
        
        # Update last backup time
        date +%s > "$last_backup_file"
        
        # Clean up old backups
        cleanup_old_backups "$RETENTION_DAYS"
    fi
}

# Interactive backup management
interactive_mode() {
    print_header "Interactive Backup Management"
    
    while true; do
        echo ""
        echo -e "${CYAN}Backup Management Options:${NC}"
        echo "1. Create new backup"
        echo "2. List all backups"
        echo "3. Restore from backup"
        echo "4. Compare with backup"
        echo "5. Clean up old backups"
        echo "6. View backup registry"
        echo "7. Exit"
        echo ""
        
        read -p "Choose option (1-7): " choice
        
        case "$choice" in
            1)
                echo ""
                read -p "Enter backup description (optional): " description
                read -p "Include untracked files? (y/N): " include_untracked
                
                local backup_name=$(generate_backup_name "manual" "$description")
                local include_flag="false"
                if [[ "$include_untracked" =~ ^[Yy] ]]; then
                    include_flag="true"
                fi
                
                create_backup "$backup_name" "$include_flag"
                ;;
            2)
                echo ""
                list_backups
                ;;
            3)
                echo ""
                list_backups
                echo ""
                read -p "Enter backup branch name to restore: " backup_name
                read -p "Enter target branch (or press Enter for current): " target_branch
                
                if [[ -n "$backup_name" ]]; then
                    restore_from_backup "$backup_name" "$target_branch"
                fi
                ;;
            4)
                echo ""
                list_backups
                echo ""
                read -p "Enter backup branch name to compare: " backup_name
                
                if [[ -n "$backup_name" ]]; then
                    compare_backup "$backup_name"
                fi
                ;;
            5)
                echo ""
                read -p "Enter retention days (default: $RETENTION_DAYS): " retention
                if [[ -z "$retention" ]]; then
                    retention="$RETENTION_DAYS"
                fi
                
                cleanup_old_backups "$retention"
                ;;
            6)
                echo ""
                if [[ -f "$LOG_DIR/backup-registry.log" ]]; then
                    echo -e "${CYAN}Backup Registry:${NC}"
                    echo "Date | Branch | Commit | Source Branch | Message"
                    echo "----------------------------------------------------"
                    cat "$LOG_DIR/backup-registry.log"
                else
                    print_info "No backup registry found"
                fi
                ;;
            7)
                print_info "Exiting backup management"
                break
                ;;
            *)
                print_warning "Invalid choice, please try again"
                ;;
        esac
    done
}

# Usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --create [description]     Create manual backup with optional description"
    echo "  --auto-backup [type]       Create automatic backup (daily, pre-update, etc.)"
    echo "  --list                     List all backup branches"
    echo "  --restore <branch>         Restore from specified backup branch"
    echo "  --compare <branch>         Compare current state with backup"
    echo "  --cleanup [days]           Clean up backups older than specified days"
    echo "  --interactive              Interactive backup management"
    echo "  --help                     Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --create \"before-exercise-3\"    # Create named backup"
    echo "  $0 --auto-backup daily              # Create automatic daily backup"
    echo "  $0 --list                           # List all backups"
    echo "  $0 --restore backup/20231215-manual # Restore from specific backup"
    echo "  $0 --cleanup 14                     # Clean backups older than 14 days"
    echo "  $0 --interactive                    # Interactive mode"
}

# Main function
main() {
    check_git_repo
    
    # Parse command line arguments
    case "${1:-}" in
        --create)
            local description="${2:-}"
            local backup_name=$(generate_backup_name "manual" "$description")
            create_backup "$backup_name" false
            ;;
        --auto-backup)
            local backup_type="${2:-auto}"
            auto_backup "$backup_type"
            ;;
        --pre-update-backup)
            local backup_name=$(generate_backup_name "pre-update" "")
            create_backup "$backup_name" true
            ;;
        --list)
            list_backups
            ;;
        --restore)
            if [[ -z "${2:-}" ]]; then
                print_error "Backup branch name required"
                usage
                exit 1
            fi
            restore_from_backup "$2" "${3:-}"
            ;;
        --compare)
            if [[ -z "${2:-}" ]]; then
                print_error "Backup branch name required"
                usage
                exit 1
            fi
            compare_backup "$2"
            ;;
        --cleanup)
            local retention="${2:-$RETENTION_DAYS}"
            cleanup_old_backups "$retention"
            ;;
        --interactive)
            interactive_mode
            ;;
        --help)
            usage
            exit 0
            ;;
        "")
            # Default to interactive mode
            interactive_mode
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    
    log "Backup manager operation completed: ${1:-interactive}"
}

# Run main function
main "$@"
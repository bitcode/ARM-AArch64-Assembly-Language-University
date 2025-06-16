#!/bin/bash

# =============================================================================
# ARM Assembly Language University - Semester Update Script
# =============================================================================
# This script safely updates course content from upstream while preserving
# student work using the dual-zone directory structure.

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
LOG_FILE="$LOG_DIR/semester-update-$(date +%Y%m%d-%H%M%S).log"
CONFLICT_RESOLVER="$SCRIPT_DIR/resolve-conflicts.sh"
BACKUP_MANAGER="$SCRIPT_DIR/backup-manager.sh"

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

# Check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    # Check if we're in a Git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a Git repository"
        exit 1
    fi
    
    # Check if upstream remote exists
    if ! git remote | grep -q "^upstream$"; then
        print_error "Upstream remote not configured. Run student-workspace-init.sh first."
        exit 1
    fi
    
    # Check if we have uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        print_warning "You have uncommitted changes"
        echo -e "${YELLOW}Uncommitted files:${NC}"
        git status --porcelain
        echo ""
        read -p "Continue anyway? (y/N): " continue_choice
        if [[ ! "$continue_choice" =~ ^[Yy] ]]; then
            print_info "Aborting update. Commit or stash your changes first."
            exit 1
        fi
    fi
    
    # Check if conflict resolver exists
    if [[ ! -f "$CONFLICT_RESOLVER" ]]; then
        print_warning "Conflict resolver not found: $CONFLICT_RESOLVER"
    fi
    
    # Check if backup manager exists
    if [[ ! -f "$BACKUP_MANAGER" ]]; then
        print_warning "Backup manager not found: $BACKUP_MANAGER"
    fi
    
    print_success "Prerequisites check completed"
}

# Create pre-update backup
create_backup() {
    print_step "Creating pre-update backup..."
    
    if [[ -f "$BACKUP_MANAGER" ]]; then
        "$BACKUP_MANAGER" --pre-update-backup
        print_success "Pre-update backup created"
    else
        # Fallback backup creation
        local backup_branch="backup/pre-update-$(date +%Y%m%d-%H%M%S)"
        git branch "$backup_branch"
        print_success "Fallback backup created: $backup_branch"
        echo "$backup_branch" > "$LOG_DIR/last-update-backup"
    fi
}

# Fetch upstream changes
fetch_upstream() {
    print_step "Fetching upstream changes..."
    
    git fetch upstream
    print_success "Upstream changes fetched"
    
    # Show what's new
    local current_branch=$(git branch --show-current)
    local upstream_commits=$(git rev-list --count HEAD..upstream/main 2>/dev/null || echo "0")
    
    if [[ "$upstream_commits" -gt 0 ]]; then
        print_info "Found $upstream_commits new commits from upstream"
        
        echo -e "${CYAN}Recent upstream changes:${NC}"
        git log --oneline --graph --decorate -10 upstream/main ^HEAD || true
        echo ""
    else
        print_info "No new commits from upstream"
        return 1  # No updates available
    fi
    
    return 0
}

# Analyze upcoming changes
analyze_changes() {
    print_step "Analyzing upcoming changes..."
    
    # Get list of files that will be changed
    local changed_files=$(git diff --name-only HEAD upstream/main)
    local student_files=()
    local course_files=()
    local config_files=()
    
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            if [[ "$file" =~ ^modules/.*/student-work/ ]] || \
               [[ "$file" =~ ^modules/.*/personal-notes/ ]] || \
               [[ "$file" =~ ^student-workspace/ ]] || \
               [[ "$file" =~ ^personal-workspace/ ]]; then
                student_files+=("$file")
            elif [[ "$file" =~ ^modules/.*/README\.md$ ]] || \
                 [[ "$file" =~ ^resources/ ]] || \
                 [[ "$file" =~ ^docs/ ]] || \
                 [[ "$file" =~ ^assessment/ ]] || \
                 [[ "$file" == "course-manifest.yaml" ]]; then
                course_files+=("$file")
            else
                config_files+=("$file")
            fi
        fi
    done <<< "$changed_files"
    
    echo -e "${CYAN}Change Analysis:${NC}"
    echo "Total files to update: $(echo "$changed_files" | wc -l)"
    echo "Course content files: ${#course_files[@]}"
    echo "Configuration files: ${#config_files[@]}"
    echo "Student workspace files: ${#student_files[@]}"
    echo ""
    
    if [[ ${#student_files[@]} -gt 0 ]]; then
        print_warning "Upstream changes affect student workspace files:"
        for file in "${student_files[@]}"; do
            echo "  - $file"
        done
        echo ""
        print_warning "These changes may conflict with your work!"
    fi
    
    if [[ ${#course_files[@]} -gt 0 ]]; then
        print_info "Course content updates:"
        for file in "${course_files[@]}"; do
            echo "  - $file"
        done
        echo ""
    fi
    
    if [[ ${#config_files[@]} -gt 0 ]]; then
        print_info "Configuration updates:"
        for file in "${config_files[@]}"; do
            echo "  - $file"
        done
        echo ""
    fi
}

# Perform the update merge
perform_update() {
    print_step "Performing semester update..."
    
    local current_branch=$(git branch --show-current)
    local update_branch="course-updates-$(date +%Y%m%d-%H%M%S)"
    
    # Create temporary update branch
    print_info "Creating update branch: $update_branch"
    git checkout -b "$update_branch"
    
    # Attempt to merge upstream changes
    print_info "Merging upstream changes..."
    if git merge upstream/main --no-edit; then
        print_success "Merge completed successfully without conflicts"
        
        # Switch back to original branch and merge the update
        git checkout "$current_branch"
        git merge "$update_branch" --no-edit
        
        # Clean up temporary branch
        git branch -d "$update_branch"
        
        print_success "Semester update completed successfully!"
        return 0
    else
        print_warning "Merge conflicts detected"
        
        # Use conflict resolver if available
        if [[ -f "$CONFLICT_RESOLVER" ]]; then
            print_info "Running automated conflict resolution..."
            if "$CONFLICT_RESOLVER" --auto; then
                print_success "Conflicts resolved automatically"
                
                # Complete the merge
                git commit --no-edit
                
                # Switch back to original branch and merge
                git checkout "$current_branch"
                git merge "$update_branch" --no-edit
                
                # Clean up temporary branch
                git branch -d "$update_branch"
                
                print_success "Semester update completed with automatic conflict resolution!"
                return 0
            else
                print_warning "Some conflicts require manual resolution"
                
                echo -e "${CYAN}Manual resolution required:${NC}"
                echo "1. You are now on branch: $update_branch"
                echo "2. Resolve remaining conflicts manually"
                echo "3. Run: git add . && git commit"
                echo "4. Run: git checkout $current_branch"
                echo "5. Run: git merge $update_branch"
                echo "6. Run: git branch -d $update_branch"
                echo ""
                echo -e "${CYAN}Or run the conflict resolver interactively:${NC}"
                echo "$CONFLICT_RESOLVER --interactive"
                
                return 1
            fi
        else
            print_error "Conflict resolver not available"
            print_info "Manual conflict resolution required"
            
            echo -e "${CYAN}Manual steps:${NC}"
            echo "1. Resolve conflicts in the listed files"
            echo "2. Run: git add ."
            echo "3. Run: git commit"
            echo "4. Run: git checkout $current_branch"
            echo "5. Run: git merge $update_branch"
            
            return 1
        fi
    fi
}

# Validate update results
validate_update() {
    print_step "Validating update results..."
    
    # Check if student workspace structure is intact
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
    
    local validation_errors=0
    
    for module in "${modules[@]}"; do
        local module_path="$REPO_ROOT/modules/$module"
        if [[ -d "$module_path" ]]; then
            if [[ ! -d "$module_path/student-work" ]]; then
                print_error "Missing student-work directory in $module"
                ((validation_errors++))
            fi
            if [[ ! -d "$module_path/personal-notes" ]]; then
                print_error "Missing personal-notes directory in $module"
                ((validation_errors++))
            fi
        fi
    done
    
    # Run student work validation if available
    local validator="$REPO_ROOT/tools/testing/validate-student-work.sh"
    if [[ -f "$validator" ]]; then
        print_info "Running student work validation..."
        if "$validator" --quiet; then
            print_success "Student work validation passed"
        else
            print_warning "Student work validation found issues"
            ((validation_errors++))
        fi
    fi
    
    if [[ $validation_errors -eq 0 ]]; then
        print_success "Update validation completed successfully"
        return 0
    else
        print_error "Update validation found $validation_errors issues"
        return 1
    fi
}

# Generate update summary
generate_summary() {
    print_step "Generating update summary..."
    
    local summary_file="$LOG_DIR/update-summary-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$summary_file" << EOF
# Semester Update Summary

**Date**: $(date)
**Repository**: $(git remote get-url origin 2>/dev/null || echo "Unknown")
**Branch**: $(git branch --show-current)

## Update Details

### Commits Added
$(git log --oneline --graph --decorate -10 HEAD ^HEAD@{1} 2>/dev/null || echo "No new commits found")

### Files Changed
$(git diff --name-only HEAD@{1} HEAD 2>/dev/null || echo "No changes detected")

### Student Workspace Status
- Student work directories: $(find modules/*/student-work -type d 2>/dev/null | wc -l) found
- Personal notes directories: $(find modules/*/personal-notes -type d 2>/dev/null | wc -l) found

### Backup Information
- Pre-update backup: $(cat "$LOG_DIR/last-update-backup" 2>/dev/null || echo "Not available")
- Log file: $LOG_FILE

## Next Steps

1. Review the changes in course materials
2. Check if any new exercises or resources were added
3. Update your personal notes with new concepts
4. Continue with your coursework on the personal-work branch

## Troubleshooting

If you encounter issues:
1. Check the log file: $LOG_FILE
2. Review backup branches: \`git branch | grep backup\`
3. Run validation: \`tools/testing/validate-student-work.sh\`
4. Get help from course resources or forums

EOF
    
    print_success "Update summary created: $summary_file"
    echo -e "${CYAN}View summary: cat $summary_file${NC}"
}

# Interactive mode for careful updates
interactive_mode() {
    print_header "Interactive Semester Update"
    
    echo -e "${CYAN}This will guide you through a safe semester update process.${NC}"
    echo ""
    
    # Step 1: Prerequisites
    echo -e "${YELLOW}Step 1: Checking prerequisites...${NC}"
    check_prerequisites
    echo ""
    read -p "Continue to backup creation? (y/N): " continue_choice
    if [[ ! "$continue_choice" =~ ^[Yy] ]]; then
        print_info "Update cancelled by user"
        exit 0
    fi
    
    # Step 2: Backup
    echo -e "${YELLOW}Step 2: Creating backup...${NC}"
    create_backup
    echo ""
    read -p "Continue to fetch upstream changes? (y/N): " continue_choice
    if [[ ! "$continue_choice" =~ ^[Yy] ]]; then
        print_info "Update cancelled by user"
        exit 0
    fi
    
    # Step 3: Fetch and analyze
    echo -e "${YELLOW}Step 3: Fetching and analyzing changes...${NC}"
    if ! fetch_upstream; then
        print_info "No updates available"
        exit 0
    fi
    
    analyze_changes
    echo ""
    read -p "Proceed with the update? (y/N): " continue_choice
    if [[ ! "$continue_choice" =~ ^[Yy] ]]; then
        print_info "Update cancelled by user"
        exit 0
    fi
    
    # Step 4: Perform update
    echo -e "${YELLOW}Step 4: Performing update...${NC}"
    if perform_update; then
        print_success "Update completed successfully!"
    else
        print_warning "Update requires manual intervention"
        exit 1
    fi
    
    # Step 5: Validate
    echo -e "${YELLOW}Step 5: Validating results...${NC}"
    validate_update
    
    # Step 6: Summary
    echo -e "${YELLOW}Step 6: Generating summary...${NC}"
    generate_summary
    
    print_success "Interactive update completed!"
}

# Automatic mode for quick updates
automatic_mode() {
    print_header "Automatic Semester Update"
    
    check_prerequisites
    create_backup
    
    if ! fetch_upstream; then
        print_info "No updates available"
        exit 0
    fi
    
    analyze_changes
    
    if perform_update; then
        validate_update
        generate_summary
        print_success "Automatic update completed successfully!"
    else
        print_error "Automatic update failed - manual intervention required"
        exit 1
    fi
}

# Check-only mode
check_mode() {
    print_header "Checking for Updates"
    
    check_prerequisites
    
    if fetch_upstream; then
        analyze_changes
        print_info "Updates are available. Run with --auto or --interactive to apply."
    else
        print_success "No updates available - you're up to date!"
    fi
}

# Usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --auto          Automatic update (recommended for experienced users)"
    echo "  --interactive   Interactive step-by-step update (recommended for beginners)"
    echo "  --check         Check for updates without applying them"
    echo "  --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Interactive mode (default)"
    echo "  $0 --check           # Check for updates only"
    echo "  $0 --auto            # Automatic update"
    echo ""
    echo "Safety Features:"
    echo "  - Automatic backup creation before updates"
    echo "  - Intelligent conflict resolution"
    echo "  - Student workspace preservation"
    echo "  - Validation and rollback capabilities"
}

# Main function
main() {
    local mode="interactive"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --auto)
                mode="auto"
                shift
                ;;
            --interactive)
                mode="interactive"
                shift
                ;;
            --check)
                mode="check"
                shift
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    print_info "Semester Update Mode: $mode"
    print_info "Log file: $LOG_FILE"
    echo ""
    
    # Execute based on mode
    case "$mode" in
        "auto")
            automatic_mode
            ;;
        "interactive")
            interactive_mode
            ;;
        "check")
            check_mode
            ;;
    esac
    
    log "Semester update completed with mode: $mode"
}

# Run main function
main "$@"
#!/bin/bash

# =============================================================================
# ARM Assembly Language University - Automated Conflict Resolution
# =============================================================================
# This script implements intelligent conflict resolution based on the dual-zone
# directory structure and predefined conflict resolution rules.

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
LOG_FILE="$LOG_DIR/conflict-resolution-$(date +%Y%m%d-%H%M%S).log"

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

print_manual() {
    echo -e "${MAGENTA}⚡ $1${NC}"
    log "MANUAL: $1"
}

# Check if we're in a merge conflict state
check_merge_conflict() {
    if git status --porcelain | grep -q "^UU\|^AA\|^DD"; then
        return 0  # In conflict
    else
        return 1  # No conflict
    fi
}

# Get conflicted files
get_conflicted_files() {
    git status --porcelain | grep "^UU\|^AA\|^DD" | cut -c4-
}

# Determine conflict resolution strategy for a file
get_resolution_strategy() {
    local file="$1"
    
    # Student workspace - favor student (ours)
    if [[ "$file" =~ ^modules/.*/student-work/ ]] || \
       [[ "$file" =~ ^modules/.*/personal-notes/ ]] || \
       [[ "$file" =~ ^student-workspace/ ]] || \
       [[ "$file" =~ ^personal-workspace/ ]] || \
       [[ "$file" =~ \.solution\.s$ ]] || \
       [[ "$file" =~ -solution\.s$ ]] || \
       [[ "$file" =~ -my-solution\.s$ ]] || \
       [[ "$file" == ".student-config" ]] || \
       [[ "$file" =~ student-settings\. ]] || \
       [[ "$file" =~ personal-settings\. ]]; then
        echo "ours"
        return
    fi
    
    # Course content - favor upstream (theirs)
    if [[ "$file" =~ ^modules/.*/README\.md$ ]] || \
       [[ "$file" =~ ^resources/ ]] || \
       [[ "$file" =~ ^docs/ ]] || \
       [[ "$file" =~ ^assessment/ ]] || \
       [[ "$file" == "course-manifest.yaml" ]] || \
       [[ "$file" == "COURSE_OVERVIEW.md" ]]; then
        echo "theirs"
        return
    fi
    
    # Configuration files - union merge or manual
    if [[ "$file" == ".gitignore" ]] || \
       [[ "$file" =~ ^tools/config/ ]] || \
       [[ "$file" =~ config\.yaml$ ]] || \
       [[ "$file" == "Makefile" ]] || \
       [[ "$file" =~ \.mk$ ]] || \
       [[ "$file" == "build.sh" ]]; then
        echo "union"
        return
    fi
    
    # Exercise files - special handling
    if [[ "$file" =~ ^modules/.*/exercises/.*\.s$ ]]; then
        echo "theirs"  # Favor instructor version for base exercises
        return
    fi
    
    # Default to manual resolution
    echo "manual"
}

# Resolve conflict using specified strategy
resolve_conflict() {
    local file="$1"
    local strategy="$2"
    
    case "$strategy" in
        "ours")
            git checkout --ours "$file"
            git add "$file"
            print_success "Resolved $file (kept student version)"
            ;;
        "theirs")
            git checkout --theirs "$file"
            git add "$file"
            print_success "Resolved $file (kept upstream version)"
            ;;
        "union")
            # For union merge, we need to manually combine
            if git merge-file -p "$file" "$file" "$file" > "${file}.merged" 2>/dev/null; then
                mv "${file}.merged" "$file"
                git add "$file"
                print_success "Resolved $file (union merge)"
            else
                print_warning "Union merge failed for $file, marking for manual resolution"
                return 1
            fi
            ;;
        "manual")
            return 1  # Indicate manual resolution needed
            ;;
        *)
            print_error "Unknown resolution strategy: $strategy"
            return 1
            ;;
    esac
    
    return 0
}

# Create backup before attempting resolution
create_conflict_backup() {
    local backup_branch="backup/conflict-$(date +%Y%m%d-%H%M%S)"
    
    print_info "Creating backup branch: $backup_branch"
    
    # Create backup branch from current state
    git branch "$backup_branch"
    
    print_success "Backup created: $backup_branch"
    echo "$backup_branch" > "$LOG_DIR/last-conflict-backup"
}

# Analyze conflicts and provide summary
analyze_conflicts() {
    local conflicted_files=()
    local auto_resolvable=()
    local manual_required=()
    
    print_info "Analyzing conflicts..."
    
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            conflicted_files+=("$file")
            local strategy=$(get_resolution_strategy "$file")
            
            if [[ "$strategy" == "manual" ]]; then
                manual_required+=("$file")
            else
                auto_resolvable+=("$file")
            fi
            
            print_info "File: $file -> Strategy: $strategy"
        fi
    done < <(get_conflicted_files)
    
    echo ""
    print_header "Conflict Analysis Summary"
    echo -e "${CYAN}Total conflicted files: ${#conflicted_files[@]}${NC}"
    echo -e "${GREEN}Auto-resolvable: ${#auto_resolvable[@]}${NC}"
    echo -e "${YELLOW}Manual resolution required: ${#manual_required[@]}${NC}"
    echo ""
    
    if [[ ${#auto_resolvable[@]} -gt 0 ]]; then
        echo -e "${GREEN}Auto-resolvable files:${NC}"
        for file in "${auto_resolvable[@]}"; do
            local strategy=$(get_resolution_strategy "$file")
            echo "  - $file ($strategy)"
        done
        echo ""
    fi
    
    if [[ ${#manual_required[@]} -gt 0 ]]; then
        echo -e "${YELLOW}Manual resolution required:${NC}"
        for file in "${manual_required[@]}"; do
            echo "  - $file"
        done
        echo ""
    fi
}

# Perform automatic conflict resolution
auto_resolve_conflicts() {
    local resolved_count=0
    local failed_count=0
    
    print_info "Starting automatic conflict resolution..."
    
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            local strategy=$(get_resolution_strategy "$file")
            
            if [[ "$strategy" != "manual" ]]; then
                if resolve_conflict "$file" "$strategy"; then
                    ((resolved_count++))
                else
                    ((failed_count++))
                    print_warning "Failed to auto-resolve: $file"
                fi
            fi
        fi
    done < <(get_conflicted_files)
    
    print_success "Auto-resolved $resolved_count conflicts"
    if [[ $failed_count -gt 0 ]]; then
        print_warning "$failed_count conflicts failed auto-resolution"
    fi
    
    return $failed_count
}

# Generate manual resolution guide
generate_manual_guide() {
    local guide_file="$LOG_DIR/manual-resolution-guide.md"
    
    print_info "Generating manual resolution guide..."
    
    cat > "$guide_file" << 'EOF'
# Manual Conflict Resolution Guide

This guide helps you resolve conflicts that require manual intervention.

## Understanding Conflict Markers

When Git cannot automatically resolve conflicts, it adds conflict markers to files:

```
<<<<<<< HEAD (your changes)
Your version of the code
=======
Their version of the code
>>>>>>> branch-name (incoming changes)
```

## Resolution Steps

1. **Open the conflicted file** in your text editor
2. **Locate conflict markers** (<<<<<<< ======= >>>>>>>)
3. **Decide which version to keep** or combine both
4. **Remove conflict markers** completely
5. **Test your resolution** if it's code
6. **Stage the resolved file**: `git add filename`
7. **Continue the merge**: `git commit`

## File-Specific Guidance

EOF
    
    # Add specific guidance for each manual conflict
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            local strategy=$(get_resolution_strategy "$file")
            
            if [[ "$strategy" == "manual" ]]; then
                cat >> "$guide_file" << EOF

### $file

**Type**: Configuration/Build file
**Recommendation**: 
- Review both versions carefully
- Keep functionality from both sides if possible
- Test after resolution to ensure it works
- Consider if changes conflict with course requirements

EOF
            fi
        fi
    done < <(get_conflicted_files)
    
    cat >> "$guide_file" << 'EOF'

## After Manual Resolution

1. Verify all conflict markers are removed:
   ```bash
   grep -r "<<<<<<\|======\|>>>>>>" .
   ```

2. Test your changes:
   ```bash
   # For assembly files
   make test
   
   # For configuration files
   tools/testing/validate-student-work.sh
   ```

3. Complete the merge:
   ```bash
   git add .
   git commit
   ```

## Getting Help

- Check the course documentation
- Review similar files for patterns
- Ask for help in course forums
- Use LLM research assistant for guidance

EOF
    
    print_success "Manual resolution guide created: $guide_file"
    echo -e "${CYAN}View the guide: cat $guide_file${NC}"
}

# Main conflict resolution function
resolve_all_conflicts() {
    if ! check_merge_conflict; then
        print_info "No merge conflicts detected"
        return 0
    fi
    
    print_header "Automated Conflict Resolution"
    
    # Create backup before attempting resolution
    create_conflict_backup
    
    # Analyze conflicts
    analyze_conflicts
    
    # Attempt automatic resolution
    if auto_resolve_conflicts; then
        print_success "All conflicts resolved automatically!"
        
        # Check if any conflicts remain
        if ! check_merge_conflict; then
            print_info "Completing merge..."
            git commit --no-edit
            print_success "Merge completed successfully!"
            return 0
        fi
    fi
    
    # Generate guide for remaining manual conflicts
    if check_merge_conflict; then
        print_warning "Some conflicts require manual resolution"
        generate_manual_guide
        
        echo ""
        print_manual "Manual resolution required for remaining conflicts"
        echo -e "${CYAN}Steps to complete:${NC}"
        echo "1. Review the manual resolution guide"
        echo "2. Edit conflicted files to resolve conflicts"
        echo "3. Remove all conflict markers"
        echo "4. Test your changes"
        echo "5. Run: git add . && git commit"
        echo ""
        echo -e "${CYAN}Remaining conflicted files:${NC}"
        get_conflicted_files | while read -r file; do
            if [[ -n "$file" ]]; then
                echo "  - $file"
            fi
        done
        
        return 1
    fi
    
    return 0
}

# Interactive mode for step-by-step resolution
interactive_mode() {
    print_header "Interactive Conflict Resolution"
    
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            local strategy=$(get_resolution_strategy "$file")
            
            echo ""
            echo -e "${CYAN}Conflict in: $file${NC}"
            echo -e "${CYAN}Suggested strategy: $strategy${NC}"
            
            if [[ "$strategy" != "manual" ]]; then
                echo -e "${YELLOW}Options:${NC}"
                echo "1. Apply suggested resolution ($strategy)"
                echo "2. Keep student version (ours)"
                echo "3. Keep upstream version (theirs)"
                echo "4. Skip (resolve manually later)"
                echo "5. View file content"
                
                read -p "Choose option (1-5): " choice
                
                case "$choice" in
                    1)
                        resolve_conflict "$file" "$strategy"
                        ;;
                    2)
                        resolve_conflict "$file" "ours"
                        ;;
                    3)
                        resolve_conflict "$file" "theirs"
                        ;;
                    4)
                        print_info "Skipping $file for manual resolution"
                        ;;
                    5)
                        echo -e "${CYAN}File content with conflicts:${NC}"
                        cat "$file" | head -50
                        echo "..."
                        ;;
                    *)
                        print_warning "Invalid choice, skipping file"
                        ;;
                esac
            else
                echo -e "${YELLOW}This file requires manual resolution${NC}"
                echo "1. Open in editor now"
                echo "2. Skip for later"
                
                read -p "Choose option (1-2): " choice
                
                case "$choice" in
                    1)
                        ${EDITOR:-nano} "$file"
                        echo "Did you resolve the conflict? (y/n)"
                        read -p "> " resolved
                        if [[ "$resolved" =~ ^[Yy] ]]; then
                            git add "$file"
                            print_success "Marked $file as resolved"
                        fi
                        ;;
                    2)
                        print_info "Skipping $file for manual resolution"
                        ;;
                esac
            fi
        fi
    done < <(get_conflicted_files)
}

# Usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --auto          Attempt automatic resolution only"
    echo "  --interactive   Interactive step-by-step resolution"
    echo "  --analyze       Analyze conflicts without resolving"
    echo "  --guide         Generate manual resolution guide only"
    echo "  --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Full automatic resolution with fallback"
    echo "  $0 --interactive      # Step-by-step interactive resolution"
    echo "  $0 --analyze          # Analyze conflicts without resolving"
}

# Main function
main() {
    local mode="auto"
    
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
            --analyze)
                mode="analyze"
                shift
                ;;
            --guide)
                mode="guide"
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
    
    print_header "ARM Assembly Language University - Conflict Resolution"
    print_info "Mode: $mode"
    print_info "Log file: $LOG_FILE"
    
    # Check if we're in a Git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a Git repository"
        exit 1
    fi
    
    # Check for conflicts
    if ! check_merge_conflict; then
        print_success "No merge conflicts detected"
        exit 0
    fi
    
    # Execute based on mode
    case "$mode" in
        "auto")
            resolve_all_conflicts
            ;;
        "interactive")
            interactive_mode
            ;;
        "analyze")
            analyze_conflicts
            ;;
        "guide")
            generate_manual_guide
            ;;
    esac
    
    log "Conflict resolution completed with mode: $mode"
}

# Run main function
main "$@"
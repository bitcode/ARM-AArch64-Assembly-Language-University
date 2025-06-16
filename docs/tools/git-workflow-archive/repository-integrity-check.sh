#!/bin/bash

# =============================================================================
# ARM Assembly Language University - Repository Integrity Checker
# =============================================================================
# This script performs comprehensive integrity checks on the repository
# structure, Git configuration, and workflow components.

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
LOG_DIR="$REPO_ROOT/tools/git-workflow/logs"
LOG_FILE="$LOG_DIR/integrity-check-$(date +%Y%m%d-%H%M%S).log"

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

# Check Git repository basics
check_git_basics() {
    print_step "Checking Git repository basics..."
    
    local errors=0
    
    # Check if we're in a Git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a Git repository"
        return 1
    fi
    
    # Check Git configuration
    if ! git config user.name >/dev/null 2>&1; then
        print_warning "Git user.name not configured"
        ((errors++))
    else
        print_info "Git user: $(git config user.name)"
    fi
    
    if ! git config user.email >/dev/null 2>&1; then
        print_warning "Git user.email not configured"
        ((errors++))
    else
        print_info "Git email: $(git config user.email)"
    fi
    
    # Check remotes
    local remotes=$(git remote)
    if echo "$remotes" | grep -q "^origin$"; then
        print_success "Origin remote configured"
        print_info "Origin URL: $(git remote get-url origin)"
    else
        print_error "Origin remote not configured"
        ((errors++))
    fi
    
    if echo "$remotes" | grep -q "^upstream$"; then
        print_success "Upstream remote configured"
        print_info "Upstream URL: $(git remote get-url upstream)"
    else
        print_warning "Upstream remote not configured"
    fi
    
    # Check current branch
    local current_branch=$(git branch --show-current)
    print_info "Current branch: $current_branch"
    
    # Check for required branches
    if git show-ref --verify --quiet refs/heads/main; then
        print_success "Main branch exists"
    else
        print_error "Main branch not found"
        ((errors++))
    fi
    
    if git show-ref --verify --quiet refs/heads/personal-work; then
        print_success "Personal-work branch exists"
    else
        print_warning "Personal-work branch not found"
    fi
    
    return $errors
}

# Check repository structure
check_repository_structure() {
    print_step "Checking repository structure..."
    
    local errors=0
    local required_dirs=(
        "modules"
        "tools"
        "resources"
        "docs"
        "assessment"
    )
    
    # Check top-level directories
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$REPO_ROOT/$dir" ]]; then
            print_success "Directory exists: $dir"
        else
            print_error "Missing required directory: $dir"
            ((errors++))
        fi
    done
    
    # Check module structure
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
            print_success "Module exists: $module"
            
            # Check for README
            if [[ -f "$module_path/README.md" ]]; then
                print_success "  README.md exists"
            else
                print_warning "  Missing README.md in $module"
            fi
            
            # Check for student workspace (if initialized)
            if [[ -d "$module_path/student-work" ]]; then
                print_success "  Student workspace exists"
                
                # Check subdirectories
                local subdirs=("exercises" "projects" "experiments")
                for subdir in "${subdirs[@]}"; do
                    if [[ -d "$module_path/student-work/$subdir" ]]; then
                        print_success "    $subdir/ exists"
                    else
                        print_warning "    Missing $subdir/ in $module/student-work"
                    fi
                done
            else
                print_info "  Student workspace not initialized"
            fi
            
            # Check for personal notes (if initialized)
            if [[ -d "$module_path/personal-notes" ]]; then
                print_success "  Personal notes exists"
                
                local note_subdirs=("module-notes" "research" "debugging-logs")
                for subdir in "${note_subdirs[@]}"; do
                    if [[ -d "$module_path/personal-notes/$subdir" ]]; then
                        print_success "    $subdir/ exists"
                    else
                        print_warning "    Missing $subdir/ in $module/personal-notes"
                    fi
                done
            else
                print_info "  Personal notes not initialized"
            fi
        else
            print_error "Missing module: $module"
            ((errors++))
        fi
    done
    
    return $errors
}

# Check workflow tools
check_workflow_tools() {
    print_step "Checking Git workflow tools..."
    
    local errors=0
    local tools=(
        "tools/setup/student-workspace-init.sh"
        "tools/git-workflow/resolve-conflicts.sh"
        "tools/git-workflow/semester-update.sh"
        "tools/git-workflow/backup-manager.sh"
        "tools/testing/validate-student-work.sh"
        "tools/git-workflow/workflow-config.yaml"
    )
    
    for tool in "${tools[@]}"; do
        if [[ -f "$REPO_ROOT/$tool" ]]; then
            print_success "Tool exists: $tool"
            
            # Check if script is executable (on Unix systems)
            if [[ "$tool" =~ \.sh$ ]] && [[ -x "$REPO_ROOT/$tool" ]]; then
                print_success "  Executable permissions set"
            elif [[ "$tool" =~ \.sh$ ]]; then
                print_info "  Note: Script may need executable permissions on Unix systems"
            fi
        else
            print_error "Missing tool: $tool"
            ((errors++))
        fi
    done
    
    # Check configuration files
    local config_files=(
        ".gitignore"
        ".gitattributes"
    )
    
    for config in "${config_files[@]}"; do
        if [[ -f "$REPO_ROOT/$config" ]]; then
            print_success "Config file exists: $config"
        else
            print_error "Missing config file: $config"
            ((errors++))
        fi
    done
    
    return $errors
}

# Check Git hooks
check_git_hooks() {
    print_step "Checking Git hooks..."
    
    local hooks_dir="$REPO_ROOT/.git/hooks"
    local workflow_hooks=("pre-commit" "pre-push")
    local hooks_found=0
    
    for hook in "${workflow_hooks[@]}"; do
        if [[ -f "$hooks_dir/$hook" ]]; then
            print_success "Git hook exists: $hook"
            ((hooks_found++))
            
            # Check if hook is executable
            if [[ -x "$hooks_dir/$hook" ]]; then
                print_success "  Hook is executable"
            else
                print_warning "  Hook is not executable"
            fi
        else
            print_info "Git hook not found: $hook (will be created during workspace init)"
        fi
    done
    
    if [[ $hooks_found -eq 0 ]]; then
        print_info "No workflow Git hooks found - run student-workspace-init.sh to set up"
    fi
    
    return 0
}

# Check file permissions and ownership
check_file_permissions() {
    print_step "Checking file permissions..."
    
    local errors=0
    
    # Check if we can write to key directories
    local writable_dirs=(
        "modules"
        "tools/git-workflow/logs"
        "student-workspace"
        "personal-workspace"
    )
    
    for dir in "${writable_dirs[@]}"; do
        local full_path="$REPO_ROOT/$dir"
        if [[ -d "$full_path" ]]; then
            if [[ -w "$full_path" ]]; then
                print_success "Directory writable: $dir"
            else
                print_error "Directory not writable: $dir"
                ((errors++))
            fi
        else
            print_info "Directory does not exist: $dir"
        fi
    done
    
    # Check for any files with unusual permissions
    local suspicious_files=$(find "$REPO_ROOT" -type f -perm /111 -name "*.md" -o -name "*.yaml" -o -name "*.yml" 2>/dev/null || true)
    
    if [[ -n "$suspicious_files" ]]; then
        print_warning "Found executable documentation/config files:"
        echo "$suspicious_files" | while read -r file; do
            print_warning "  $file"
        done
    fi
    
    return $errors
}

# Check for common issues
check_common_issues() {
    print_step "Checking for common issues..."
    
    local warnings=0
    
    # Check for conflict markers
    local conflict_files=$(find "$REPO_ROOT" -name "*.s" -o -name "*.md" -o -name "*.txt" -o -name "*.yaml" | \
                          xargs grep -l "^<<<<<<<\|^=======\|^>>>>>>>" 2>/dev/null || true)
    
    if [[ -n "$conflict_files" ]]; then
        print_error "Found conflict markers in files:"
        echo "$conflict_files" | while read -r file; do
            print_error "  $file"
        done
        ((warnings++))
    else
        print_success "No conflict markers found"
    fi
    
    # Check for large files
    local large_files=$(find "$REPO_ROOT" -type f -size +10M 2>/dev/null || true)
    
    if [[ -n "$large_files" ]]; then
        print_warning "Found large files (>10MB):"
        echo "$large_files" | while read -r file; do
            local size=$(du -h "$file" | cut -f1)
            print_warning "  $file ($size)"
        done
        ((warnings++))
    else
        print_success "No unusually large files found"
    fi
    
    # Check for temporary files
    local temp_files=$(find "$REPO_ROOT" -name "*.tmp" -o -name "*.temp" -o -name "*.bak" -o -name "*~" 2>/dev/null || true)
    
    if [[ -n "$temp_files" ]]; then
        print_info "Found temporary files:"
        echo "$temp_files" | while read -r file; do
            print_info "  $file"
        done
    fi
    
    # Check repository size
    local repo_size=$(du -sh "$REPO_ROOT/.git" 2>/dev/null | cut -f1 || echo "Unknown")
    print_info "Repository size: $repo_size"
    
    # Check number of branches
    local branch_count=$(git branch -a | wc -l)
    print_info "Total branches: $branch_count"
    
    # Check for backup branches
    local backup_count=$(git branch | grep -c "backup/" || echo "0")
    print_info "Backup branches: $backup_count"
    
    return $warnings
}

# Generate integrity report
generate_integrity_report() {
    local total_errors="$1"
    local total_warnings="$2"
    
    local report_file="$LOG_DIR/integrity-report-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$report_file" << EOF
# Repository Integrity Report

**Date**: $(date)
**Repository**: $(git remote get-url origin 2>/dev/null || echo "Unknown")
**Branch**: $(git branch --show-current)
**Commit**: $(git rev-parse --short HEAD)

## Summary

- **Total Errors**: $total_errors
- **Total Warnings**: $total_warnings
- **Status**: $(if [[ $total_errors -eq 0 ]]; then echo "✅ HEALTHY"; else echo "❌ ISSUES FOUND"; fi)

## System Information

- **Git Version**: $(git --version)
- **Repository Size**: $(du -sh "$REPO_ROOT/.git" 2>/dev/null | cut -f1 || echo "Unknown")
- **Total Branches**: $(git branch -a | wc -l)
- **Backup Branches**: $(git branch | grep -c "backup/" || echo "0")

## Integrity Checks

### Git Repository Basics
$(if check_git_basics >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

### Repository Structure
$(if check_repository_structure >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

### Workflow Tools
$(if check_workflow_tools >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

### Git Hooks
$(if check_git_hooks >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

### File Permissions
$(if check_file_permissions >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

### Common Issues Check
$(if check_common_issues >/dev/null 2>&1; then echo "✅ PASSED"; else echo "⚠️ WARNINGS"; fi)

## Recommendations

$(if [[ $total_errors -gt 0 ]]; then
    echo "### Critical Issues to Fix"
    echo "- Review the integrity log for specific error details"
    echo "- Ensure all required directories and files are present"
    echo "- Fix any Git configuration issues"
    echo "- Resolve any conflict markers in files"
fi)

$(if [[ $total_warnings -gt 0 ]]; then
    echo "### Suggestions for Improvement"
    echo "- Clean up temporary files"
    echo "- Review large files for necessity"
    echo "- Set up missing Git hooks"
    echo "- Configure missing Git remotes"
fi)

## Next Steps

1. Review this report and the detailed log: $LOG_FILE
2. Fix any critical errors identified
3. Consider addressing warnings for better repository health
4. Re-run integrity check after making changes
5. Initialize student workspace if not already done

## Support

If you need help resolving integrity issues:
- Check the Git workflow documentation: tools/git-workflow/README.md
- Run student workspace initialization: tools/setup/student-workspace-init.sh
- Use validation tools: tools/testing/validate-student-work.sh
- Consult course documentation and forums

EOF
    
    print_success "Integrity report generated: $report_file"
    echo -e "${CYAN}View report: cat $report_file${NC}"
}

# Usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --full              Full integrity check (default)"
    echo "  --quick             Quick integrity check (basic checks only)"
    echo "  --report-only       Generate report without console output"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  # Full integrity check"
    echo "  $0 --quick          # Quick integrity check"
    echo "  $0 --report-only    # Generate report file only"
    echo ""
    echo "Exit codes:"
    echo "  0 - Repository is healthy"
    echo "  1 - Issues found that need attention"
    echo "  2 - Script error or invalid usage"
}

# Main function
main() {
    local mode="full"
    local report_only=false
    local quiet_mode=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full)
                mode="full"
                shift
                ;;
            --quick)
                mode="quick"
                shift
                ;;
            --report-only)
                report_only=true
                quiet_mode=true
                shift
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                exit 2
                ;;
        esac
    done
    
    if [[ "$quiet_mode" != "true" ]]; then
        print_header "ARM Assembly Language University - Repository Integrity Check"
        print_info "Mode: $mode"
        print_info "Log file: $LOG_FILE"
    fi
    
    local total_errors=0
    local total_warnings=0
    
    # Run checks based on mode
    case "$mode" in
        "quick")
            check_git_basics
            local git_errors=$?
            total_errors=$((total_errors + git_errors))
            
            check_common_issues
            local issue_warnings=$?
            total_warnings=$((total_warnings + issue_warnings))
            ;;
        "full")
            # Run all integrity checks
            check_git_basics
            local git_errors=$?
            total_errors=$((total_errors + git_errors))
            
            check_repository_structure
            local struct_errors=$?
            total_errors=$((total_errors + struct_errors))
            
            check_workflow_tools
            local tool_errors=$?
            total_errors=$((total_errors + tool_errors))
            
            check_git_hooks
            # Git hooks check doesn't contribute to error count
            
            check_file_permissions
            local perm_errors=$?
            total_errors=$((total_errors + perm_errors))
            
            check_common_issues
            local issue_warnings=$?
            total_warnings=$((total_warnings + issue_warnings))
            ;;
    esac
    
    # Generate report
    if [[ "$report_only" == "true" ]] || [[ $total_errors -gt 0 ]] || [[ "$mode" == "full" ]]; then
        generate_integrity_report "$total_errors" "$total_warnings"
    fi
    
    # Final summary
    if [[ "$quiet_mode" != "true" ]]; then
        echo ""
        if [[ $total_errors -eq 0 ]]; then
            print_success "Repository integrity check completed - repository is healthy!"
            if [[ $total_warnings -gt 0 ]]; then
                print_info "Found $total_warnings warnings (non-critical)"
            fi
        else
            print_error "Repository integrity check found $total_errors issues that need attention"
        fi
    fi
    
    log "Integrity check completed: $total_errors errors, $total_warnings warnings"
    
    # Exit with appropriate code
    if [[ $total_errors -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Run main function
main "$@"
#!/bin/bash

# =============================================================================
# ARM Assembly Language University - Student Work Validation
# =============================================================================
# This script validates student workspace integrity, directory structure,
# and ensures no unauthorized modifications to course content.

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
LOG_FILE="$LOG_DIR/validation-$(date +%Y%m%d-%H%M%S).log"

# Validation settings
MAX_FILE_SIZE_MB=10
MAX_STUDENT_FILES=1000
QUIET_MODE=false

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Output functions
print_header() {
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo -e "${BLUE}================================${NC}"
        echo -e "${BLUE}$1${NC}"
        echo -e "${BLUE}================================${NC}"
    fi
    log "HEADER: $1"
}

print_success() {
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
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
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo -e "${CYAN}ℹ $1${NC}"
    fi
    log "INFO: $1"
}

print_step() {
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo -e "${MAGENTA}▶ $1${NC}"
    fi
    log "STEP: $1"
}

# Check if we're in a Git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a Git repository"
        return 1
    fi
    return 0
}

# Validate directory structure
validate_directory_structure() {
    print_step "Validating directory structure..."
    
    local errors=0
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
    
    # Check module directories
    for module in "${modules[@]}"; do
        local module_path="$REPO_ROOT/modules/$module"
        
        if [[ ! -d "$module_path" ]]; then
            print_warning "Module directory missing: $module"
            ((errors++))
            continue
        fi
        
        # Check for student workspace directories
        if [[ ! -d "$module_path/student-work" ]]; then
            print_warning "Student work directory missing: $module/student-work"
            ((errors++))
        fi
        
        if [[ ! -d "$module_path/personal-notes" ]]; then
            print_warning "Personal notes directory missing: $module/personal-notes"
            ((errors++))
        fi
        
        # Check for required subdirectories
        local required_subdirs=("exercises" "projects" "experiments")
        for subdir in "${required_subdirs[@]}"; do
            if [[ ! -d "$module_path/student-work/$subdir" ]]; then
                print_warning "Missing subdirectory: $module/student-work/$subdir"
                ((errors++))
            fi
        done
        
        local notes_subdirs=("module-notes" "research" "debugging-logs")
        for subdir in "${notes_subdirs[@]}"; do
            if [[ ! -d "$module_path/personal-notes/$subdir" ]]; then
                print_warning "Missing subdirectory: $module/personal-notes/$subdir"
                ((errors++))
            fi
        done
    done
    
    # Check top-level workspace directories
    if [[ ! -d "$REPO_ROOT/student-workspace" ]]; then
        print_warning "Top-level student workspace missing"
        ((errors++))
    fi
    
    if [[ ! -d "$REPO_ROOT/personal-workspace" ]]; then
        print_warning "Top-level personal workspace missing"
        ((errors++))
    fi
    
    if [[ $errors -eq 0 ]]; then
        print_success "Directory structure validation passed"
    else
        print_error "Directory structure validation found $errors issues"
    fi
    
    return $errors
}

# Check for unauthorized course content modifications
validate_course_content() {
    print_step "Validating course content integrity..."
    
    local errors=0
    local protected_files=(
        "course-manifest.yaml"
        "COURSE_OVERVIEW.md"
        "modules/*/README.md"
        "resources/"
        "docs/"
        "assessment/"
    )
    
    # Check if we have upstream remote to compare against
    if git remote | grep -q "^upstream$"; then
        # Fetch latest upstream (quietly)
        git fetch upstream >/dev/null 2>&1 || true
        
        # Check for modifications to protected files
        local modified_files=$(git diff --name-only upstream/main HEAD 2>/dev/null || echo "")
        
        while IFS= read -r file; do
            if [[ -n "$file" ]]; then
                # Check if file matches protected patterns
                for pattern in "${protected_files[@]}"; do
                    if [[ "$file" == $pattern ]] || [[ "$file" =~ ^${pattern//\*/.*}$ ]]; then
                        # Skip if it's in student workspace
                        if [[ ! "$file" =~ ^modules/.*/student-work/ ]] && \
                           [[ ! "$file" =~ ^modules/.*/personal-notes/ ]] && \
                           [[ ! "$file" =~ ^student-workspace/ ]] && \
                           [[ ! "$file" =~ ^personal-workspace/ ]]; then
                            print_warning "Protected file modified: $file"
                            ((errors++))
                        fi
                        break
                    fi
                done
            fi
        done <<< "$modified_files"
    else
        print_info "No upstream remote found, skipping course content validation"
    fi
    
    if [[ $errors -eq 0 ]]; then
        print_success "Course content integrity validation passed"
    else
        print_error "Course content validation found $errors unauthorized modifications"
    fi
    
    return $errors
}

# Validate student files
validate_student_files() {
    print_step "Validating student files..."
    
    local errors=0
    local warnings=0
    local file_count=0
    local total_size=0
    
    # Find all student files
    local student_dirs=(
        "modules/*/student-work"
        "modules/*/personal-notes"
        "student-workspace"
        "personal-workspace"
    )
    
    for dir_pattern in "${student_dirs[@]}"; do
        while IFS= read -d '' -r file; do
            if [[ -f "$file" ]]; then
                ((file_count++))
                
                # Check file size
                local file_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
                total_size=$((total_size + file_size))
                
                local file_size_mb=$((file_size / 1024 / 1024))
                if [[ $file_size_mb -gt $MAX_FILE_SIZE_MB ]]; then
                    print_warning "Large file detected: $file (${file_size_mb}MB)"
                    ((warnings++))
                fi
                
                # Check for suspicious file types
                case "$file" in
                    *.exe|*.dll|*.so|*.dylib)
                        print_warning "Executable file in student workspace: $file"
                        ((warnings++))
                        ;;
                    *.zip|*.tar|*.gz|*.rar|*.7z)
                        print_warning "Archive file in student workspace: $file"
                        ((warnings++))
                        ;;
                    *.tmp|*.temp|*.bak|*.backup)
                        print_info "Temporary file found: $file"
                        ;;
                esac
                
                # Check for conflict markers
                if [[ "$file" =~ \.(s|md|txt|c|cpp|h)$ ]]; then
                    if grep -q "^<<<<<<<\|^=======\|^>>>>>>>" "$file" 2>/dev/null; then
                        print_error "Conflict markers found in: $file"
                        ((errors++))
                    fi
                fi
                
                # Validate assembly files
                if [[ "$file" =~ \.s$ ]]; then
                    validate_assembly_file "$file"
                    local result=$?
                    if [[ $result -gt 0 ]]; then
                        ((errors += result))
                    fi
                fi
            fi
        done < <(find $REPO_ROOT/$dir_pattern -type f -print0 2>/dev/null || true)
    done
    
    # Check file count limits
    if [[ $file_count -gt $MAX_STUDENT_FILES ]]; then
        print_warning "High number of student files: $file_count (limit: $MAX_STUDENT_FILES)"
        ((warnings++))
    fi
    
    # Report statistics
    local total_size_mb=$((total_size / 1024 / 1024))
    print_info "Student files: $file_count files, ${total_size_mb}MB total"
    
    if [[ $errors -eq 0 ]]; then
        print_success "Student files validation passed"
        if [[ $warnings -gt 0 ]]; then
            print_warning "Found $warnings warnings (non-critical)"
        fi
    else
        print_error "Student files validation found $errors errors"
    fi
    
    return $errors
}

# Validate individual assembly file
validate_assembly_file() {
    local file="$1"
    local errors=0
    
    # Check for basic assembly syntax issues
    if [[ -f "$file" ]]; then
        # Check for common syntax errors
        local line_num=1
        while IFS= read -r line; do
            # Skip comments and empty lines
            if [[ "$line" =~ ^[[:space:]]*$ ]] || [[ "$line" =~ ^[[:space:]]*// ]] || [[ "$line" =~ ^[[:space:]]*@ ]]; then
                ((line_num++))
                continue
            fi
            
            # Check for tabs vs spaces consistency (warning only)
            if [[ "$line" =~ ^[[:space:]]*[[:graph:]] ]]; then
                if [[ "$line" =~ ^[[:space:]]*$'\t' ]] && [[ "$line" =~ ^[[:space:]]*' ' ]]; then
                    print_info "Mixed tabs and spaces in $file:$line_num"
                fi
            fi
            
            ((line_num++))
        done < "$file"
        
        # Check file encoding (should be UTF-8 or ASCII)
        if command -v file >/dev/null 2>&1; then
            local encoding=$(file -b --mime-encoding "$file")
            if [[ "$encoding" != "us-ascii" ]] && [[ "$encoding" != "utf-8" ]]; then
                print_warning "Non-standard encoding in $file: $encoding"
            fi
        fi
    fi
    
    return $errors
}

# Check Git repository health
validate_git_health() {
    print_step "Validating Git repository health..."
    
    local errors=0
    local warnings=0
    
    # Check for proper Git configuration
    if ! git config user.name >/dev/null 2>&1; then
        print_warning "Git user.name not configured"
        ((warnings++))
    fi
    
    if ! git config user.email >/dev/null 2>&1; then
        print_warning "Git user.email not configured"
        ((warnings++))
    fi
    
    # Check for required remotes
    if ! git remote | grep -q "^origin$"; then
        print_error "Origin remote not configured"
        ((errors++))
    fi
    
    if ! git remote | grep -q "^upstream$"; then
        print_warning "Upstream remote not configured (run student-workspace-init.sh)"
        ((warnings++))
    fi
    
    # Check for required branches
    if ! git show-ref --verify --quiet refs/heads/main; then
        print_error "Main branch not found"
        ((errors++))
    fi
    
    if ! git show-ref --verify --quiet refs/heads/personal-work; then
        print_warning "Personal-work branch not found (run student-workspace-init.sh)"
        ((warnings++))
    fi
    
    # Check for uncommitted changes in protected areas
    local status_output=$(git status --porcelain)
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            local file=$(echo "$line" | cut -c4-)
            
            # Check if modified file is in protected area
            if [[ "$file" =~ ^modules/.*/README\.md$ ]] || \
               [[ "$file" =~ ^resources/ ]] || \
               [[ "$file" =~ ^docs/ ]] || \
               [[ "$file" =~ ^assessment/ ]] || \
               [[ "$file" == "course-manifest.yaml" ]]; then
                print_warning "Uncommitted changes to protected file: $file"
                ((warnings++))
            fi
        fi
    done <<< "$status_output"
    
    # Check repository size
    local repo_size=$(du -sh "$REPO_ROOT/.git" 2>/dev/null | cut -f1 || echo "Unknown")
    print_info "Repository size: $repo_size"
    
    if [[ $errors -eq 0 ]]; then
        print_success "Git repository health validation passed"
        if [[ $warnings -gt 0 ]]; then
            print_warning "Found $warnings warnings (non-critical)"
        fi
    else
        print_error "Git repository health validation found $errors errors"
    fi
    
    return $errors
}

# Generate validation report
generate_report() {
    local total_errors="$1"
    local total_warnings="$2"
    
    local report_file="$LOG_DIR/validation-report-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$report_file" << EOF
# Student Work Validation Report

**Date**: $(date)
**Repository**: $(git remote get-url origin 2>/dev/null || echo "Unknown")
**Branch**: $(git branch --show-current)
**Commit**: $(git rev-parse --short HEAD)

## Summary

- **Total Errors**: $total_errors
- **Total Warnings**: $total_warnings
- **Status**: $(if [[ $total_errors -eq 0 ]]; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

## Validation Results

### Directory Structure
$(if validate_directory_structure >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

### Course Content Integrity
$(if validate_course_content >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

### Student Files
$(if validate_student_files >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

### Git Repository Health
$(if validate_git_health >/dev/null 2>&1; then echo "✅ PASSED"; else echo "❌ FAILED"; fi)

## Recommendations

$(if [[ $total_errors -gt 0 ]]; then
    echo "### Critical Issues to Fix"
    echo "- Review the validation log for specific error details"
    echo "- Fix any conflict markers in files"
    echo "- Ensure proper Git configuration"
    echo "- Restore any missing directory structure"
fi)

$(if [[ $total_warnings -gt 0 ]]; then
    echo "### Suggestions for Improvement"
    echo "- Consider cleaning up temporary files"
    echo "- Review large files in student workspace"
    echo "- Configure missing Git remotes"
    echo "- Set up proper Git user configuration"
fi)

## Next Steps

1. Review this report and the detailed log: $LOG_FILE
2. Fix any critical errors identified
3. Consider addressing warnings for better organization
4. Re-run validation after making changes: \`tools/testing/validate-student-work.sh\`

## Support

If you need help resolving validation issues:
- Check the course documentation
- Review Git workflow guides in tools/git-workflow/
- Use the LLM research assistant for guidance
- Ask for help in course forums

EOF
    
    print_success "Validation report generated: $report_file"
    
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo -e "${CYAN}View report: cat $report_file${NC}"
    fi
}

# Quick validation mode
quick_validation() {
    print_step "Running quick validation..."
    
    local errors=0
    
    # Basic checks only
    if ! check_git_repo; then
        ((errors++))
    fi
    
    # Check for conflict markers in common files
    local conflict_files=$(find "$REPO_ROOT" -name "*.s" -o -name "*.md" -o -name "*.txt" | \
                          xargs grep -l "^<<<<<<<\|^=======\|^>>>>>>>" 2>/dev/null || true)
    
    if [[ -n "$conflict_files" ]]; then
        print_error "Conflict markers found in files"
        ((errors++))
    fi
    
    # Check basic directory structure
    if [[ ! -d "$REPO_ROOT/modules/m1-foundation/student-work" ]]; then
        print_error "Student workspace not initialized"
        ((errors++))
    fi
    
    if [[ $errors -eq 0 ]]; then
        print_success "Quick validation passed"
    else
        print_error "Quick validation found $errors critical issues"
    fi
    
    return $errors
}

# Usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --full              Full validation (default)"
    echo "  --quick             Quick validation (basic checks only)"
    echo "  --quiet             Quiet mode (minimal output)"
    echo "  --report-only       Generate report without console output"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  # Full validation with normal output"
    echo "  $0 --quick          # Quick validation"
    echo "  $0 --quiet          # Full validation with minimal output"
    echo "  $0 --report-only    # Generate report file only"
    echo ""
    echo "Exit codes:"
    echo "  0 - Validation passed"
    echo "  1 - Validation failed (errors found)"
    echo "  2 - Script error or invalid usage"
}

# Main function
main() {
    local mode="full"
    local report_only=false
    
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
            --quiet)
                QUIET_MODE=true
                shift
                ;;
            --report-only)
                QUIET_MODE=true
                report_only=true
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
    
    if [[ "$QUIET_MODE" != "true" ]]; then
        print_header "ARM Assembly Language University - Student Work Validation"
        print_info "Mode: $mode"
        print_info "Log file: $LOG_FILE"
    fi
    
    local total_errors=0
    local total_warnings=0
    
    # Run validation based on mode
    case "$mode" in
        "quick")
            quick_validation
            total_errors=$?
            ;;
        "full")
            # Check Git repository
            if ! check_git_repo; then
                exit 2
            fi
            
            # Run all validation checks
            validate_directory_structure
            local dir_errors=$?
            total_errors=$((total_errors + dir_errors))
            
            validate_course_content
            local content_errors=$?
            total_errors=$((total_errors + content_errors))
            
            validate_student_files
            local file_errors=$?
            total_errors=$((total_errors + file_errors))
            
            validate_git_health
            local git_errors=$?
            total_errors=$((total_errors + git_errors))
            ;;
    esac
    
    # Generate report if requested or if there are issues
    if [[ "$report_only" == "true" ]] || [[ $total_errors -gt 0 ]] || [[ "$mode" == "full" ]]; then
        generate_report "$total_errors" "$total_warnings"
    fi
    
    # Final summary
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo ""
        if [[ $total_errors -eq 0 ]]; then
            print_success "Validation completed successfully!"
        else
            print_error "Validation failed with $total_errors errors"
        fi
    fi
    
    log "Validation completed: $total_errors errors, $total_warnings warnings"
    
    # Exit with appropriate code
    if [[ $total_errors -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Run main function
main "$@"
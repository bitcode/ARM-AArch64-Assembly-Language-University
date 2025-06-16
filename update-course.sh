#!/bin/bash

# ARM Assembly Course - Simple Update Script
# Standard fork-and-branch workflow for course updates

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
STUDENT_BRANCH="my-work"
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"

# Functions
print_header() {
    echo -e "\n${BLUE}${BOLD}▶ $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "  $1"
}

show_banner() {
    echo -e "${BLUE}${BOLD}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║                    📚 COURSE UPDATE TOOL 📚                   ║
    ║                                                               ║
    ║                Simple Git Workflow for Updates               ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking prerequisites"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    # Check if upstream remote exists
    if ! git remote get-url $UPSTREAM_REMOTE > /dev/null 2>&1; then
        print_error "Upstream remote not configured"
        print_info "Run ./setup.sh to configure your Git workflow"
        exit 1
    fi
    
    # Check if student branch exists
    if ! git show-ref --verify --quiet refs/heads/$STUDENT_BRANCH; then
        print_error "Student branch '$STUDENT_BRANCH' not found"
        print_info "Run ./setup.sh to set up your workspace"
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Save current work
save_current_work() {
    print_header "Saving your current work"
    
    # Switch to student branch
    git checkout $STUDENT_BRANCH --quiet
    
    # Check if there are uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        print_info "Uncommitted changes detected"
        echo -e "${YELLOW}Do you want to commit your current work? (y/n):${NC} "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Enter commit message:${NC} "
            read -r commit_message
            git add .
            git commit -m "$commit_message"
            print_success "Work committed"
        else
            print_warning "Proceeding with uncommitted changes"
            print_info "Your changes will be preserved during the update"
        fi
    else
        print_info "No uncommitted changes found"
    fi
    
    print_success "Current work saved"
}

# Fetch updates
fetch_updates() {
    print_header "Fetching course updates"
    
    print_info "Fetching from upstream repository..."
    if git fetch $UPSTREAM_REMOTE --quiet; then
        print_success "Updates fetched successfully"
    else
        print_error "Failed to fetch updates"
        print_info "Check your internet connection and try again"
        exit 1
    fi
    
    # Check if there are updates available
    local commits_behind=$(git rev-list --count HEAD..$UPSTREAM_REMOTE/$UPSTREAM_BRANCH 2>/dev/null || echo "0")
    
    if [ "$commits_behind" -eq 0 ]; then
        print_success "You're already up to date!"
        echo -e "${GREEN}No new course updates available.${NC}"
        exit 0
    else
        print_info "Found $commits_behind new updates"
        echo -e "${BLUE}Updates available:${NC}"
        git log --oneline HEAD..$UPSTREAM_REMOTE/$UPSTREAM_BRANCH | head -5
        if [ "$commits_behind" -gt 5 ]; then
            echo -e "  ${BLUE}... and $((commits_behind - 5)) more${NC}"
        fi
    fi
}

# Apply updates
apply_updates() {
    print_header "Applying course updates"
    
    print_info "Merging updates into your work..."
    
    # Attempt to merge
    if git merge $UPSTREAM_REMOTE/$UPSTREAM_BRANCH --no-edit --quiet; then
        print_success "Updates applied successfully!"
        print_info "Your student work has been preserved"
    else
        print_warning "Merge conflicts detected"
        print_info "This is normal when course updates overlap with your work"
        
        echo -e "\n${YELLOW}${BOLD}Conflict Resolution Guide:${NC}"
        echo -e "${GREEN}1.${NC} Your student work in modules/*/student-work/ is always kept"
        echo -e "${GREEN}2.${NC} Course content updates are applied automatically"
        echo -e "${GREEN}3.${NC} For manual conflicts, edit the files and remove conflict markers"
        echo -e "${GREEN}4.${NC} Look for lines with: ${RED}<<<<<<<${NC}, ${BLUE}=======${NC}, ${RED}>>>>>>>${NC}"
        echo -e "${GREEN}5.${NC} After resolving, run: ${BLUE}git add . && git commit${NC}"
        
        echo -e "\n${BLUE}Files with conflicts:${NC}"
        git diff --name-only --diff-filter=U | while read -r file; do
            echo -e "  ${YELLOW}$file${NC}"
        done
        
        echo -e "\n${YELLOW}Resolve conflicts manually, then run this script again.${NC}"
        exit 1
    fi
}

# Verify update
verify_update() {
    print_header "Verifying update"
    
    # Check if we're still on the student branch
    local current_branch=$(git branch --show-current)
    if [ "$current_branch" != "$STUDENT_BRANCH" ]; then
        print_error "Not on student branch after update"
        git checkout $STUDENT_BRANCH --quiet
    fi
    
    # Check if student work directories still exist
    local missing_dirs=0
    for module in modules/m{1..8}; do
        if [ -d "$module" ] && [ ! -d "$module/student-work" ]; then
            print_warning "Missing student-work directory: $module/student-work"
            mkdir -p "$module/student-work"
            missing_dirs=$((missing_dirs + 1))
        fi
    done
    
    if [ $missing_dirs -gt 0 ]; then
        print_info "Recreated $missing_dirs student work directories"
    fi
    
    print_success "Update verification complete"
}

# Show summary
show_summary() {
    print_header "Update Summary"
    
    echo -e "${GREEN}✓ Course updates applied successfully!${NC}"
    echo -e "\n${BOLD}What's new:${NC}"
    
    # Show recent commits from upstream
    git log --oneline --graph --max-count=5 $UPSTREAM_REMOTE/$UPSTREAM_BRANCH
    
    echo -e "\n${BOLD}Your next steps:${NC}"
    echo -e "${GREEN}1.${NC} Review new course content in modules/"
    echo -e "${GREEN}2.${NC} Continue working on your exercises"
    echo -e "${GREEN}3.${NC} Your student work is preserved in modules/*/student-work/"
    
    echo -e "\n${BOLD}Quick commands:${NC}"
    echo -e "  Check status: ${BLUE}git status${NC}"
    echo -e "  View changes: ${BLUE}git log --oneline -10${NC}"
    echo -e "  Build code:   ${BLUE}./build.sh <file.s>${NC}"
    
    echo -e "\n${GREEN}Happy coding! 🎯${NC}"
}

# Main function
main() {
    show_banner
    
    print_header "Simple Course Update Workflow"
    echo -e "${BLUE}Standard fork-and-branch Git workflow${NC}\n"
    
    check_prerequisites
    save_current_work
    fetch_updates
    apply_updates
    verify_update
    show_summary
    
    echo -e "\n${GREEN}✓ Course update completed successfully${NC}"
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "ARM Assembly Course Update Tool"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --check        Check for updates without applying"
        echo ""
        echo "This script implements a simple fork-and-branch workflow:"
        echo "1. Saves your current work"
        echo "2. Fetches updates from upstream"
        echo "3. Merges updates while preserving your student work"
        echo "4. Provides guidance for any conflicts"
        exit 0
        ;;
    --check)
        show_banner
        check_prerequisites
        fetch_updates
        exit 0
        ;;
    "")
        main
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
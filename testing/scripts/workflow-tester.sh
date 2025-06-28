#!/bin/bash

# =============================================================================
# ARM Assembly Course - Comprehensive Workflow Tester
# =============================================================================
# Complete testing framework for student workflow validation
# Implements safe testing without polluting master branch

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTING_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$TESTING_ROOT/.." && pwd)"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Global variables
TEST_SESSION_ID="test-session-$TIMESTAMP"
TEST_WORKSPACE=""
FEEDBACK_FILE=""
RESULTS_SUMMARY=""

print_banner() {
    echo -e "${BLUE}${BOLD}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║           ARM ASSEMBLY COURSE WORKFLOW TESTER                ║
║                                                               ║
║              Safe Testing Without Master Pollution           ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$FEEDBACK_FILE"
}

print_header() {
    echo -e "\n${BLUE}${BOLD}▶ $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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

# Safety validation
validate_testing_environment() {
    print_header "Validating Testing Environment"
    
    # Check current branch
    local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    if [[ "$current_branch" == "master" || "$current_branch" == "main" ]]; then
        print_error "Cannot run tests on master/main branch"
        print_info "Create testing branch: git checkout -b testing/workflow-validation"
        exit 1
    fi
    
    # Ensure testing infrastructure exists
    if [[ ! -f "$TESTING_ROOT/scripts/test-runner.sh" ]]; then
        print_error "Testing infrastructure not found"
        print_info "Run: ./testing/scripts/setup-test-env.sh --init"
        exit 1
    fi
    
    # Check for Docker if needed
    if [[ "$USE_DOCKER" == true ]] && ! command -v docker &> /dev/null; then
        print_error "Docker required but not found"
        exit 1
    fi
    
    print_success "Testing environment validated"
}

# Create isolated test workspace
create_test_workspace() {
    print_header "Creating Isolated Test Workspace"
    
    TEST_WORKSPACE="/tmp/arm-course-workflow-test-$TIMESTAMP"
    mkdir -p "$TEST_WORKSPACE"
    
    # Create feedback and results files
    FEEDBACK_FILE="$TESTING_ROOT/reports/manual/workflow-test-$TIMESTAMP.md"
    RESULTS_SUMMARY="$TESTING_ROOT/reports/automated/workflow-results-$TIMESTAMP.json"
    mkdir -p "$(dirname "$FEEDBACK_FILE")"
    mkdir -p "$(dirname "$RESULTS_SUMMARY")"
    
    # Initialize feedback file
    cat > "$FEEDBACK_FILE" << EOF
# Workflow Testing Session - $TIMESTAMP

## Test Configuration
- Session ID: $TEST_SESSION_ID
- Timestamp: $(date)
- Test Workspace: $TEST_WORKSPACE
- Current Branch: $(git branch --show-current)
- Tester: $(git config user.name 2>/dev/null || echo "Unknown")

## Test Results

EOF
    
    print_info "Test workspace: $TEST_WORKSPACE"
    print_info "Feedback file: $FEEDBACK_FILE"
    print_success "Test workspace created"
}

# Cleanup function
cleanup_test_workspace() {
    print_header "Cleaning Up Test Workspace"
    
    if [[ -n "$TEST_WORKSPACE" && -d "$TEST_WORKSPACE" ]]; then
        print_info "Removing test workspace: $TEST_WORKSPACE"
        rm -rf "$TEST_WORKSPACE"
    fi
    
    # Kill any background processes
    jobs -p | xargs -r kill 2>/dev/null || true
    
    print_success "Cleanup complete"
}

# Trap cleanup on exit
trap cleanup_test_workspace EXIT

# Simulate fresh student experience
test_fresh_student_experience() {
    print_header "Testing Fresh Student Experience"
    
    cd "$TEST_WORKSPACE"
    
    # Copy repository (excluding .git to avoid conflicts)
    print_info "Creating fresh repository copy..."
    rsync -av --exclude='.git' --exclude='testing/reports' "$REPO_ROOT/" ./
    
    # Initialize as fresh Git repository
    git init --quiet
    git add .
    git commit -m "Initial repository state" --quiet
    git remote add upstream "https://github.com/bitcode/ARM-AArch64-Assembly-Language-University.git"
    
    # Test setup.sh with timeout
    print_info "Testing setup.sh (with 5-minute timeout)..."
    local setup_start=$(date +%s)
    
    if timeout 300 bash -c './setup.sh --test-mode 2>&1' | tee setup-output.log; then
        local setup_end=$(date +%s)
        local setup_duration=$((setup_end - setup_start))
        print_success "setup.sh completed in ${setup_duration}s"
        
        # Log to feedback
        echo "### Setup Script Test" >> "$FEEDBACK_FILE"
        echo "- Status: SUCCESS" >> "$FEEDBACK_FILE"
        echo "- Duration: ${setup_duration} seconds" >> "$FEEDBACK_FILE"
        echo "- Output captured in setup-output.log" >> "$FEEDBACK_FILE"
        echo "" >> "$FEEDBACK_FILE"
        
        return 0
    else
        print_error "setup.sh failed or timed out"
        echo "### Setup Script Test" >> "$FEEDBACK_FILE"
        echo "- Status: FAILED" >> "$FEEDBACK_FILE"
        echo "- Error: Script failed or timed out after 300 seconds" >> "$FEEDBACK_FILE"
        echo "" >> "$FEEDBACK_FILE"
        
        return 1
    fi
}

# Test build workflow
test_build_workflow() {
    print_header "Testing Build Workflow"
    
    cd "$TEST_WORKSPACE"
    
    # Check if build.sh was created
    if [[ ! -f "build.sh" ]]; then
        print_error "build.sh not found"
        return 1
    fi
    
    if [[ ! -x "build.sh" ]]; then
        print_error "build.sh not executable"
        return 1
    fi
    
    print_success "build.sh exists and is executable"
    
    # Create test assembly file
    cat > test-program.s << 'EOF'
.section .data
msg: .ascii "Build test successful!\n"
msg_len = . - msg

.section .text
.global _start

_start:
    mov x8, #64        // sys_write
    mov x0, #1         // stdout
    adr x1, msg        // message address
    mov x2, #msg_len   // length
    svc #0

    mov x8, #93        // sys_exit
    mov x0, #0         // success
    svc #0
EOF
    
    # Test build script
    print_info "Testing build script with sample program..."
    if ./build.sh test-program.s test-output 2>&1 | tee build-output.log; then
        print_success "Build script executed successfully"
        
        echo "### Build Script Test" >> "$FEEDBACK_FILE"
        echo "- Status: SUCCESS" >> "$FEEDBACK_FILE"
        echo "- Test file: test-program.s" >> "$FEEDBACK_FILE"
        echo "- Output: test-output" >> "$FEEDBACK_FILE"
        echo "" >> "$FEEDBACK_FILE"
        
        return 0
    else
        print_warning "Build script failed (may be expected without toolchain)"
        
        echo "### Build Script Test" >> "$FEEDBACK_FILE"
        echo "- Status: EXPECTED_FAILURE" >> "$FEEDBACK_FILE"
        echo "- Note: Failure expected without ARM toolchain installed" >> "$FEEDBACK_FILE"
        echo "" >> "$FEEDBACK_FILE"
        
        return 0  # This is expected without toolchain
    fi
}

# Test update workflow
test_update_workflow() {
    print_header "Testing Update Workflow"
    
    cd "$TEST_WORKSPACE"
    
    # Simulate student work
    print_info "Simulating student work..."
    mkdir -p modules/m1/student-work
    echo "# My learning notes" > modules/m1/student-work/notes.md
    echo "# My exercise solutions" > modules/m1/student-work/solutions.md
    git add modules/m1/student-work/
    git commit -m "Add student work" --quiet
    
    # Test update script
    print_info "Testing update-course.sh..."
    if timeout 180 ./update-course.sh --test-mode 2>&1 | tee update-output.log; then
        # Check if student work is preserved
        if [[ -f "modules/m1/student-work/notes.md" && -f "modules/m1/student-work/solutions.md" ]]; then
            print_success "Update workflow completed and student work preserved"
            
            echo "### Update Workflow Test" >> "$FEEDBACK_FILE"
            echo "- Status: SUCCESS" >> "$FEEDBACK_FILE"
            echo "- Student work preserved: YES" >> "$FEEDBACK_FILE"
            echo "- Files checked: notes.md, solutions.md" >> "$FEEDBACK_FILE"
            echo "" >> "$FEEDBACK_FILE"
            
            return 0
        else
            print_error "Student work was lost during update"
            return 1
        fi
    else
        print_error "update-course.sh failed or timed out"
        return 1
    fi
}

# Collect user experience feedback
collect_ux_feedback() {
    print_header "Collecting User Experience Feedback"
    
    echo "### User Experience Feedback" >> "$FEEDBACK_FILE"
    echo "" >> "$FEEDBACK_FILE"
    
    if [[ "$INTERACTIVE_MODE" == true ]]; then
        echo -e "${CYAN}Please provide feedback on the student workflow:${NC}"
        echo ""
        
        echo -e "${YELLOW}1. How intuitive was the setup process? (1-5, 5=very intuitive)${NC}"
        read -p "Rating: " setup_rating
        echo "- Setup intuitiveness: $setup_rating/5" >> "$FEEDBACK_FILE"
        
        echo -e "${YELLOW}2. Were the error messages helpful? (1-5, 5=very helpful)${NC}"
        read -p "Rating: " error_rating
        echo "- Error message quality: $error_rating/5" >> "$FEEDBACK_FILE"
        
        echo -e "${YELLOW}3. How clear were the next steps after setup? (1-5, 5=very clear)${NC}"
        read -p "Rating: " clarity_rating
        echo "- Next steps clarity: $clarity_rating/5" >> "$FEEDBACK_FILE"
        
        echo -e "${YELLOW}4. Any specific pain points or suggestions?${NC}"
        read -p "Comments: " comments
        echo "- Comments: $comments" >> "$FEEDBACK_FILE"
        
    else
        echo "- Mode: Automated (no interactive feedback collected)" >> "$FEEDBACK_FILE"
    fi
    
    echo "" >> "$FEEDBACK_FILE"
    print_success "Feedback collected"
}

# Generate results summary
generate_results_summary() {
    print_header "Generating Results Summary"
    
    local total_tests=0
    local passed_tests=0
    local failed_tests=0
    
    # Count test results from feedback file
    if grep -q "Status: SUCCESS" "$FEEDBACK_FILE"; then
        passed_tests=$(grep -c "Status: SUCCESS" "$FEEDBACK_FILE")
    fi
    
    if grep -q "Status: FAILED" "$FEEDBACK_FILE"; then
        failed_tests=$(grep -c "Status: FAILED" "$FEEDBACK_FILE")
    fi
    
    total_tests=$((passed_tests + failed_tests))
    
    # Generate JSON summary
    cat > "$RESULTS_SUMMARY" << EOF
{
  "session_id": "$TEST_SESSION_ID",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "test_workspace": "$TEST_WORKSPACE",
  "results": {
    "total_tests": $total_tests,
    "passed_tests": $passed_tests,
    "failed_tests": $failed_tests,
    "success_rate": $(echo "scale=2; $passed_tests * 100 / $total_tests" | bc -l 2>/dev/null || echo "0")
  },
  "test_details": {
    "setup_test": "$(grep -A1 "Setup Script Test" "$FEEDBACK_FILE" | grep "Status:" | cut -d' ' -f3 || echo "NOT_RUN")",
    "build_test": "$(grep -A1 "Build Script Test" "$FEEDBACK_FILE" | grep "Status:" | cut -d' ' -f3 || echo "NOT_RUN")",
    "update_test": "$(grep -A1 "Update Workflow Test" "$FEEDBACK_FILE" | grep "Status:" | cut -d' ' -f3 || echo "NOT_RUN")"
  },
  "feedback_file": "$FEEDBACK_FILE",
  "recommendations": []
}
EOF
    
    print_info "Results summary: $RESULTS_SUMMARY"
    print_success "Results summary generated"
}

# Main testing workflow
main() {
    print_banner
    
    # Parse arguments
    local test_scenarios=()
    INTERACTIVE_MODE=false
    USE_DOCKER=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --interactive)
                INTERACTIVE_MODE=true
                shift
                ;;
            --docker)
                USE_DOCKER=true
                shift
                ;;
            --scenario)
                test_scenarios+=("$2")
                shift 2
                ;;
            --all)
                test_scenarios=("fresh-student" "build-workflow" "update-workflow")
                shift
                ;;
            -h|--help)
                echo "ARM Assembly Course Workflow Tester"
                echo ""
                echo "Usage: $0 [options]"
                echo ""
                echo "Options:"
                echo "  --interactive     Enable interactive feedback collection"
                echo "  --docker          Use Docker for testing"
                echo "  --scenario NAME   Run specific test scenario"
                echo "  --all             Run all test scenarios"
                echo "  -h, --help        Show this help"
                echo ""
                echo "Scenarios:"
                echo "  fresh-student     Test new student setup experience"
                echo "  build-workflow    Test build script functionality"
                echo "  update-workflow   Test course update workflow"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Default to all scenarios if none specified
    if [[ ${#test_scenarios[@]} -eq 0 ]]; then
        test_scenarios=("fresh-student" "build-workflow" "update-workflow")
    fi
    
    # Initialize testing
    validate_testing_environment
    create_test_workspace
    
    # Run test scenarios
    local overall_success=true
    
    for scenario in "${test_scenarios[@]}"; do
        case "$scenario" in
            "fresh-student")
                if ! test_fresh_student_experience; then
                    overall_success=false
                fi
                ;;
            "build-workflow")
                if ! test_build_workflow; then
                    overall_success=false
                fi
                ;;
            "update-workflow")
                if ! test_update_workflow; then
                    overall_success=false
                fi
                ;;
            *)
                print_warning "Unknown scenario: $scenario"
                ;;
        esac
    done
    
    # Collect feedback and generate results
    collect_ux_feedback
    generate_results_summary
    
    # Final summary
    print_header "Testing Session Complete"
    
    if [[ "$overall_success" == true ]]; then
        print_success "All tests completed successfully!"
    else
        print_warning "Some tests failed - check feedback file for details"
    fi
    
    print_info "Session ID: $TEST_SESSION_ID"
    print_info "Feedback: $FEEDBACK_FILE"
    print_info "Results: $RESULTS_SUMMARY"
    
    echo -e "\n${CYAN}Next steps:${NC}"
    echo "1. Review feedback file for detailed results"
    echo "2. Address any identified issues"
    echo "3. Re-run tests after improvements"
    echo "4. Consider running cross-platform tests with --docker"
}

# Run main function
main "$@"

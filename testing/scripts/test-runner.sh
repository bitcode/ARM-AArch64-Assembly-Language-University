#!/bin/bash

# =============================================================================
# ARM Assembly Course - Main Test Runner
# =============================================================================
# Comprehensive testing orchestrator for student workflow scripts
# Ensures safe testing without polluting the master branch

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTING_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$TESTING_ROOT/.." && pwd)"
TEST_RESULTS_DIR="$TESTING_ROOT/reports/automated"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Logging
LOG_FILE="$TEST_RESULTS_DIR/test-run-$TIMESTAMP.log"
mkdir -p "$TEST_RESULTS_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo -e "${BLUE}${BOLD}================================${NC}"
    echo -e "${BLUE}${BOLD}$1${NC}"
    echo -e "${BLUE}${BOLD}================================${NC}"
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

# Safety checks
check_safety() {
    print_header "Safety Checks"
    
    # Ensure we're not on master branch for testing
    local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    if [[ "$current_branch" == "master" || "$current_branch" == "main" ]]; then
        print_error "Cannot run tests on master/main branch"
        print_info "Create a testing branch: git checkout -b testing/workflow-validation"
        exit 1
    fi
    
    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        print_warning "Uncommitted changes detected"
        print_info "Tests will run but changes should be committed first"
    fi
    
    # Verify testing directory structure
    if [[ ! -d "$TESTING_ROOT/docker" ]]; then
        print_error "Testing infrastructure not complete"
        print_info "Run: ./testing/scripts/setup-test-env.sh --init"
        exit 1
    fi
    
    print_success "Safety checks passed"
}

# Test environment setup
setup_test_environment() {
    print_header "Setting Up Test Environment"
    
    # Create temporary testing directory
    export TEST_WORKSPACE="/tmp/arm-course-test-$TIMESTAMP"
    mkdir -p "$TEST_WORKSPACE"
    
    print_info "Test workspace: $TEST_WORKSPACE"
    
    # Copy repository to test workspace (excluding .git to avoid conflicts)
    print_info "Creating isolated repository copy..."
    rsync -av --exclude='.git' --exclude='testing/reports' "$REPO_ROOT/" "$TEST_WORKSPACE/"
    
    # Initialize git in test workspace
    cd "$TEST_WORKSPACE"
    git init --quiet
    git add .
    git commit -m "Initial test repository state" --quiet
    
    # Add mock upstream remote
    git remote add upstream "https://github.com/bitcode/ARM-AArch64-Assembly-Language-University.git"
    
    print_success "Test environment ready"
}

# Cleanup function
cleanup_test_environment() {
    print_header "Cleaning Up Test Environment"
    
    if [[ -n "$TEST_WORKSPACE" && -d "$TEST_WORKSPACE" ]]; then
        print_info "Removing test workspace: $TEST_WORKSPACE"
        rm -rf "$TEST_WORKSPACE"
    fi
    
    # Kill any background processes
    jobs -p | xargs -r kill 2>/dev/null || true
    
    print_success "Cleanup complete"
}

# Trap cleanup on exit
trap cleanup_test_environment EXIT

# Test scenarios
test_fresh_student_workflow() {
    print_header "Testing Fresh Student Workflow"
    
    cd "$TEST_WORKSPACE"
    
    # Test setup.sh
    print_info "Testing setup.sh..."
    if timeout 300 ./setup.sh --test-mode 2>&1 | tee -a "$LOG_FILE"; then
        print_success "setup.sh completed successfully"
    else
        print_error "setup.sh failed"
        return 1
    fi
    
    # Test build.sh creation and functionality
    print_info "Testing build.sh..."
    if [[ -f "build.sh" && -x "build.sh" ]]; then
        print_success "build.sh created and executable"
    else
        print_error "build.sh not created properly"
        return 1
    fi
    
    # Test with sample assembly file
    print_info "Testing build functionality..."
    cat > test-hello.s << 'EOF'
.section .data
msg: .ascii "Test successful!\n"
msg_len = . - msg

.section .text
.global _start

_start:
    mov x8, #64
    mov x0, #1
    adr x1, msg
    mov x2, #msg_len
    svc #0
    
    mov x8, #93
    mov x0, #0
    svc #0
EOF
    
    if ./build.sh test-hello.s 2>&1 | tee -a "$LOG_FILE"; then
        print_success "Build test passed"
    else
        print_warning "Build test failed (may be expected without toolchain)"
    fi
    
    return 0
}

test_update_workflow() {
    print_header "Testing Update Workflow"
    
    cd "$TEST_WORKSPACE"
    
    # Simulate student work
    mkdir -p modules/m1/student-work
    echo "# My notes" > modules/m1/student-work/my-notes.md
    git add modules/m1/student-work/my-notes.md
    git commit -m "Add student work" --quiet
    
    # Test update-course.sh
    print_info "Testing update-course.sh..."
    if timeout 300 ./update-course.sh --test-mode 2>&1 | tee -a "$LOG_FILE"; then
        print_success "update-course.sh completed successfully"
    else
        print_error "update-course.sh failed"
        return 1
    fi
    
    # Verify student work preservation
    if [[ -f "modules/m1/student-work/my-notes.md" ]]; then
        print_success "Student work preserved during update"
    else
        print_error "Student work lost during update"
        return 1
    fi
    
    return 0
}

test_cross_platform_compatibility() {
    print_header "Testing Cross-Platform Compatibility"
    
    # This would be expanded to use Docker containers
    print_info "Cross-platform testing requires Docker setup"
    print_info "Run: ./testing/scripts/test-runner.sh --docker"
    
    return 0
}

# Main test execution
run_tests() {
    local scenarios=("$@")
    local failed_tests=0
    
    print_header "ARM Assembly Course - Test Runner"
    print_info "Timestamp: $TIMESTAMP"
    print_info "Test workspace: $TEST_WORKSPACE"
    print_info "Log file: $LOG_FILE"
    
    check_safety
    setup_test_environment
    
    # Run specified test scenarios
    for scenario in "${scenarios[@]}"; do
        case "$scenario" in
            "fresh-student")
                if ! test_fresh_student_workflow; then
                    ((failed_tests++))
                fi
                ;;
            "update-workflow")
                if ! test_update_workflow; then
                    ((failed_tests++))
                fi
                ;;
            "cross-platform")
                if ! test_cross_platform_compatibility; then
                    ((failed_tests++))
                fi
                ;;
            *)
                print_warning "Unknown test scenario: $scenario"
                ;;
        esac
    done
    
    # Generate test report
    print_header "Test Results Summary"
    if [[ $failed_tests -eq 0 ]]; then
        print_success "All tests passed!"
    else
        print_error "$failed_tests test(s) failed"
    fi
    
    print_info "Detailed log: $LOG_FILE"
    
    return $failed_tests
}

# Usage information
usage() {
    echo "ARM Assembly Course Test Runner"
    echo ""
    echo "Usage: $0 [options] [scenarios...]"
    echo ""
    echo "Scenarios:"
    echo "  fresh-student     Test new student setup workflow"
    echo "  update-workflow   Test course update workflow"
    echo "  cross-platform    Test cross-platform compatibility"
    echo "  all               Run all test scenarios"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo "  -v, --verbose     Enable verbose output"
    echo "  --docker          Use Docker for testing"
    echo "  --interactive     Interactive testing mode"
    echo ""
    echo "Examples:"
    echo "  $0 fresh-student"
    echo "  $0 --all"
    echo "  $0 fresh-student update-workflow"
}

# Parse command line arguments
SCENARIOS=()
VERBOSE=false
USE_DOCKER=false
INTERACTIVE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --docker)
            USE_DOCKER=true
            shift
            ;;
        --interactive)
            INTERACTIVE=true
            shift
            ;;
        --all)
            SCENARIOS=("fresh-student" "update-workflow" "cross-platform")
            shift
            ;;
        *)
            SCENARIOS+=("$1")
            shift
            ;;
    esac
done

# Default to fresh-student if no scenarios specified
if [[ ${#SCENARIOS[@]} -eq 0 ]]; then
    SCENARIOS=("fresh-student")
fi

# Run the tests
run_tests "${SCENARIOS[@]}"

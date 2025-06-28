#!/bin/bash

# =============================================================================
# ARM Assembly Course - Testing Environment Setup
# =============================================================================
# Sets up comprehensive testing infrastructure for safe script validation

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTING_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$TESTING_ROOT/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}${BOLD}================================${NC}"
    echo -e "${BLUE}${BOLD}$1${NC}"
    echo -e "${BLUE}${BOLD}================================${NC}"
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
    echo -e "${CYAN}ℹ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    local missing_tools=()
    
    # Check for required tools
    if ! command -v docker &> /dev/null; then
        missing_tools+=("docker")
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        missing_tools+=("docker-compose")
    fi
    
    if ! command -v git &> /dev/null; then
        missing_tools+=("git")
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_info "Please install the missing tools and try again"
        return 1
    fi
    
    # Check Docker daemon
    if ! docker info &> /dev/null; then
        print_error "Docker daemon not running"
        print_info "Please start Docker and try again"
        return 1
    fi
    
    print_success "All prerequisites satisfied"
    return 0
}

# Create testing directory structure
create_directory_structure() {
    print_header "Creating Testing Directory Structure"
    
    local dirs=(
        "docker"
        "scripts"
        "scenarios/fresh-student"
        "scenarios/existing-student"
        "scenarios/cross-platform"
        "scenarios/error-conditions"
        "fixtures/sample-repos"
        "fixtures/test-configs"
        "fixtures/expected-outputs"
        "reports/automated"
        "reports/manual"
        "reports/improvements"
        "tools"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$TESTING_ROOT/$dir"
        print_info "Created: $dir"
    done
    
    print_success "Directory structure created"
}

# Create additional Docker files
create_docker_files() {
    print_header "Creating Docker Testing Files"
    
    # Fedora Dockerfile
    cat > "$TESTING_ROOT/docker/Dockerfile.fedora" << 'EOF'
# ARM Assembly Course Testing - Fedora Environment
FROM fedora:38

# Install required packages
RUN dnf update -y && dnf install -y \
    gcc-aarch64-linux-gnu \
    qemu-user-static \
    git \
    make \
    rsync \
    timeout \
    tree \
    bash \
    zsh \
    && dnf clean all

# Create test user
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser:testuser" | chpasswd

USER testuser
WORKDIR /home/testuser

RUN git config --global user.name "Test Student" && \
    git config --global user.email "test@example.com"

VOLUME ["/home/testuser/workspace"]
WORKDIR /home/testuser/workspace
CMD ["/bin/bash"]
EOF

    # Test runner Dockerfile
    cat > "$TESTING_ROOT/docker/Dockerfile.test-runner" << 'EOF'
# ARM Assembly Course Testing - Test Runner
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    docker.io \
    docker-compose \
    git \
    curl \
    jq \
    && apt-get clean

WORKDIR /workspace
CMD ["/bin/bash"]
EOF

    print_success "Docker files created"
}

# Create test scenarios
create_test_scenarios() {
    print_header "Creating Test Scenarios"
    
    # Fresh student scenario
    cat > "$TESTING_ROOT/scenarios/fresh-student/test-config.yaml" << 'EOF'
name: "Fresh Student Workflow"
description: "Test complete new student setup process"
timeout: 600
steps:
  - name: "Run setup.sh"
    command: "./setup.sh --test-mode"
    expect_success: true
  - name: "Verify build.sh creation"
    command: "test -x build.sh"
    expect_success: true
  - name: "Test build functionality"
    command: "./build.sh test-hello.s"
    expect_success: false  # May fail without toolchain
    allow_failure: true
  - name: "Verify Git workflow"
    command: "git remote get-url upstream"
    expect_success: true
EOF

    # Update workflow scenario
    cat > "$TESTING_ROOT/scenarios/existing-student/test-config.yaml" << 'EOF'
name: "Update Workflow"
description: "Test course update with existing student work"
timeout: 300
setup:
  - "mkdir -p modules/m1/student-work"
  - "echo '# My notes' > modules/m1/student-work/notes.md"
  - "git add modules/m1/student-work/notes.md"
  - "git commit -m 'Add student work'"
steps:
  - name: "Run update-course.sh"
    command: "./update-course.sh --test-mode"
    expect_success: true
  - name: "Verify student work preserved"
    command: "test -f modules/m1/student-work/notes.md"
    expect_success: true
EOF

    print_success "Test scenarios created"
}

# Create testing utilities
create_testing_utilities() {
    print_header "Creating Testing Utilities"
    
    # Mock Git server script
    cat > "$TESTING_ROOT/tools/mock-git-server.sh" << 'EOF'
#!/bin/bash
# Mock Git server for testing upstream operations
# This script simulates upstream repository behavior

MOCK_REPO_DIR="/tmp/mock-upstream-$$"
mkdir -p "$MOCK_REPO_DIR"

cd "$MOCK_REPO_DIR"
git init --bare --quiet

echo "Mock Git server started at: $MOCK_REPO_DIR"
echo "Use this as upstream URL: file://$MOCK_REPO_DIR"
EOF
    chmod +x "$TESTING_ROOT/tools/mock-git-server.sh"

    # Platform detector
    cat > "$TESTING_ROOT/tools/platform-detector.sh" << 'EOF'
#!/bin/bash
# Detect platform for testing

detect_platform() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

detect_distribution() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

echo "Platform: $(detect_platform)"
echo "Distribution: $(detect_distribution)"
EOF
    chmod +x "$TESTING_ROOT/tools/platform-detector.sh"

    print_success "Testing utilities created"
}

# Create Git hooks for safety
create_git_hooks() {
    print_header "Creating Safety Git Hooks"
    
    local hooks_dir="$REPO_ROOT/.git/hooks"
    
    # Pre-commit hook to prevent test artifacts
    cat > "$hooks_dir/pre-commit.testing" << 'EOF'
#!/bin/bash
# Prevent committing test artifacts

# Check for test artifacts
if git diff --cached --name-only | grep -E "(test-results|testing/reports|\.test\.)" > /dev/null; then
    echo "Error: Attempting to commit test artifacts"
    echo "Test files should not be committed to the repository"
    exit 1
fi

# Check for temporary directories
if git diff --cached --name-only | grep -E "(tmp/|temp/|/tmp|/temp)" > /dev/null; then
    echo "Error: Attempting to commit temporary files"
    exit 1
fi

exit 0
EOF
    chmod +x "$hooks_dir/pre-commit.testing"
    
    print_info "Git hooks created (not activated by default)"
    print_info "To activate: ln -sf pre-commit.testing $hooks_dir/pre-commit"
}

# Build Docker images
build_docker_images() {
    print_header "Building Docker Images"
    
    cd "$TESTING_ROOT/docker"
    
    print_info "Building Ubuntu testing image..."
    if docker build -t arm-course-test:ubuntu -f Dockerfile.ubuntu . > /dev/null 2>&1; then
        print_success "Ubuntu image built"
    else
        print_error "Failed to build Ubuntu image"
        return 1
    fi
    
    print_info "Building Fedora testing image..."
    if docker build -t arm-course-test:fedora -f Dockerfile.fedora . > /dev/null 2>&1; then
        print_success "Fedora image built"
    else
        print_warning "Failed to build Fedora image (optional)"
    fi
    
    return 0
}

# Interactive setup mode
interactive_setup() {
    print_header "Interactive Testing Setup"
    
    echo -e "${CYAN}This will set up a complete testing environment.${NC}"
    echo -e "${CYAN}The following will be created:${NC}"
    echo "  - Docker testing containers"
    echo "  - Test scenarios and fixtures"
    echo "  - Safety mechanisms and Git hooks"
    echo "  - Testing utilities and scripts"
    echo ""
    
    read -p "Continue with setup? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Setup cancelled"
        exit 0
    fi
    
    return 0
}

# Main setup function
main() {
    print_header "ARM Assembly Course - Testing Environment Setup"
    
    # Parse arguments
    local init_mode=false
    local interactive_mode=false
    local docker_only=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --init)
                init_mode=true
                shift
                ;;
            --interactive)
                interactive_mode=true
                shift
                ;;
            --docker-only)
                docker_only=true
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --init         Initialize complete testing environment"
                echo "  --interactive  Interactive setup mode"
                echo "  --docker-only  Only build Docker images"
                echo "  -h, --help     Show this help"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Interactive confirmation
    if [[ "$interactive_mode" == true ]]; then
        interactive_setup
    fi
    
    # Run setup steps
    check_prerequisites
    
    if [[ "$docker_only" == false ]]; then
        create_directory_structure
        create_docker_files
        create_test_scenarios
        create_testing_utilities
        create_git_hooks
    fi
    
    if [[ "$init_mode" == true || "$docker_only" == true ]]; then
        build_docker_images
    fi
    
    print_header "Setup Complete!"
    print_success "Testing environment is ready"
    print_info "Run tests with: ./testing/scripts/test-runner.sh"
    print_info "Docker tests: ./testing/scripts/test-runner.sh --docker"
    print_info "Interactive: ./testing/scripts/test-runner.sh --interactive"
}

# Run main function
main "$@"

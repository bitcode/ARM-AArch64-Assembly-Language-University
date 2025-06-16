#!/bin/bash

# ARM Assembly Course - Streamlined Setup Script
# One script to rule them all: fork → setup → start coding

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
COURSE_NAME="ARM Assembly Course"
TOOLCHAIN_PREFIX="aarch64-linux-gnu"
STUDENT_BRANCH="my-work"

# ASCII Art Banner
show_banner() {
    echo -e "${BLUE}${BOLD}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║     █████╗ ██████╗ ███╗   ███╗     █████╗ ███████╗███╗   ███╗ ║
    ║    ██╔══██╗██╔══██╗████╗ ████║    ██╔══██╗██╔════╝████╗ ████║ ║
    ║    ███████║██████╔╝██╔████╔██║    ███████║███████╗██╔████╔██║ ║
    ║    ██╔══██║██╔══██╗██║╚██╔╝██║    ██╔══██║╚════██║██║╚██╔╝██║ ║
    ║    ██║  ██║██║  ██║██║ ╚═╝ ██║    ██║  ██║███████║██║ ╚═╝ ██║ ║
    ║    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ║
    ║                                                               ║
    ║                    ASSEMBLY COURSE SETUP                     ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

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

# Git workflow setup
setup_git_workflow() {
    print_header "Setting up Git workflow"

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository. Please fork and clone the course first."
        print_info "1. Fork: https://github.com/your-repo/ARM-Assembly-Course"
        print_info "2. Clone: git clone <your-fork-url>"
        print_info "3. Run this script again"
        exit 1
    fi

    # Create student work branch
    if git show-ref --verify --quiet refs/heads/$STUDENT_BRANCH; then
        print_info "Student branch '$STUDENT_BRANCH' already exists"
        git checkout $STUDENT_BRANCH
    else
        print_info "Creating student work branch: $STUDENT_BRANCH"
        git checkout -b $STUDENT_BRANCH
    fi

    # Set up upstream for course updates
    if ! git remote get-url upstream > /dev/null 2>&1; then
        print_info "Adding upstream remote for course updates"
        git remote add upstream https://github.com/original-repo/ARM-Assembly-Course.git
    fi

    print_success "Git workflow configured"
}

detect_platform() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

install_linux_dependencies() {
    print_info "Installing ARM development tools..."

    if command -v apt-get &> /dev/null; then
        print_info "Detected Debian/Ubuntu - using apt"
        sudo apt-get update -qq
        sudo apt-get install -y gcc-aarch64-linux-gnu qemu-user-static
    elif command -v yum &> /dev/null; then
        print_info "Detected RHEL/CentOS - using yum"
        sudo yum install -y gcc-aarch64-linux-gnu qemu-user-static
    elif command -v pacman &> /dev/null; then
        print_info "Detected Arch Linux - using pacman"
        sudo pacman -S --noconfirm aarch64-linux-gnu-gcc qemu-arch-extra
    else
        print_error "Unsupported Linux distribution"
        print_info "Please install: gcc-aarch64-linux-gnu, qemu-user-static"
        exit 1
    fi
}

install_macos_dependencies() {
    print_info "Installing ARM development tools for macOS..."

    if ! command -v brew &> /dev/null; then
        print_error "Homebrew required. Install from: https://brew.sh"
        exit 1
    fi

    brew install aarch64-elf-gcc qemu
}

verify_installation() {
    print_header "Verifying tools"

    local all_good=true

    # Check cross-compiler
    if command -v ${TOOLCHAIN_PREFIX}-gcc &> /dev/null; then
        print_success "ARM GCC compiler found"
    else
        print_error "ARM GCC not found (${TOOLCHAIN_PREFIX}-gcc)"
        all_good=false
    fi

    # Check QEMU
    if command -v qemu-aarch64-static &> /dev/null; then
        print_success "QEMU emulator found"
    else
        print_error "QEMU not found (qemu-aarch64-static)"
        all_good=false
    fi

    if $all_good; then
        print_success "All tools ready!"
        return 0
    else
        print_error "Missing tools. Please install manually."
        return 1
    fi
}

test_toolchain() {
    print_header "Testing your setup"

    local test_dir="/tmp/arm_test_$$"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # Create simple test program
    cat > hello.s << 'EOF'
.section .data
msg: .ascii "Setup works!\n"
msg_len = . - msg

.section .text
.global _start

_start:
    mov x8, #64        # sys_write
    mov x0, #1         # stdout
    ldr x1, =msg       # message
    mov x2, #msg_len   # length
    svc #0

    mov x8, #93        # sys_exit
    mov x0, #0         # success
    svc #0
EOF

    # Build and test
    if ${TOOLCHAIN_PREFIX}-gcc -static hello.s -o hello 2>/dev/null; then
        if qemu-aarch64-static ./hello 2>/dev/null; then
            print_success "Test program works!"
        else
            print_error "Test program failed to run"
            return 1
        fi
    else
        print_error "Test program failed to build"
        return 1
    fi

    # Cleanup
    cd - > /dev/null
    rm -rf "$test_dir"
}

create_helper_script() {
    print_header "Creating build helper"

    # Create simple build script in the repo
    cat > build.sh << 'EOF'
#!/bin/bash
# Simple ARM assembly build script

if [ $# -eq 0 ]; then
    echo "Usage: ./build.sh <file.s> [output_name]"
    echo "Example: ./build.sh hello.s"
    exit 1
fi

SOURCE="$1"
OUTPUT="${2:-${SOURCE%.*}}"

echo "Building $SOURCE..."
aarch64-linux-gnu-gcc -static "$SOURCE" -o "$OUTPUT"

if [ $? -eq 0 ]; then
    echo "✓ Built successfully: $OUTPUT"
    echo "Run with: qemu-aarch64-static ./$OUTPUT"
else
    echo "✗ Build failed"
    exit 1
fi
EOF

    chmod +x build.sh
    print_success "Created build.sh helper script"
}

show_next_steps() {
    print_header "🎉 Setup Complete!"

    echo -e "${GREEN}${BOLD}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║                    🚀 READY TO START CODING! 🚀               ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    echo -e "${BOLD}Your next steps:${NC}"
    echo -e "${GREEN}1.${NC} Go to Module 1: ${BLUE}cd modules/m1-foundation/exercises${NC}"
    echo -e "${GREEN}2.${NC} Start first exercise: ${BLUE}cp 1.1-hello-beginner.s my-hello.s${NC}"
    echo -e "${GREEN}3.${NC} Edit the file and look for: ${YELLOW}★ START HERE ★${NC}"
    echo -e "${GREEN}4.${NC} Build your code: ${BLUE}../../../build.sh my-hello.s${NC}"
    echo -e "${GREEN}5.${NC} Run your program: ${BLUE}qemu-aarch64-static ./my-hello${NC}"

    echo -e "\n${BOLD}Quick commands:${NC}"
    echo -e "  Build: ${BLUE}./build.sh <file.s>${NC}"
    echo -e "  Run:   ${BLUE}qemu-aarch64-static ./<program>${NC}"

    echo -e "\n${YELLOW}Happy coding! 🎯${NC}"
}

main() {
    show_banner

    print_header "Setting up your ARM assembly environment"

    # Step 1: Git workflow
    setup_git_workflow

    # Step 2: Install tools
    local platform=$(detect_platform)
    print_info "Platform: $platform"

    case $platform in
        "linux")
            install_linux_dependencies
            ;;
        "macos")
            install_macos_dependencies
            ;;
        *)
            print_error "Unsupported platform: $platform"
            exit 1
            ;;
    esac

    # Step 3: Verify and test
    if verify_installation && test_toolchain; then
        create_helper_script
        show_next_steps
    else
        print_error "Setup failed. Please check the errors above."
        exit 1
    fi
}

# Run main function
main "$@"
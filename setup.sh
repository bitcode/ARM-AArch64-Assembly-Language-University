#!/bin/bash

# ARM Assembly Course - Unified Setup Script
# One script to rule them all: fork → setup → start coding in 5 minutes

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

# Progress tracking
TOTAL_STEPS=6
CURRENT_STEP=0

show_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo -e "${BLUE}[${CURRENT_STEP}/${TOTAL_STEPS}]${NC} $1"
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

# Git workflow setup - Simplified fork-and-branch workflow
setup_git_workflow() {
    show_progress "Setting up simplified Git workflow"

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository. Please fork and clone the course first."
        print_info "1. Fork: https://github.com/bitcode/ARM-AArch64-Assembly-Language-University"
        print_info "2. Clone: git clone <your-fork-url>"
        print_info "3. Run this script again"
        exit 1
    fi

    # Set up upstream for course updates
    if ! git remote get-url upstream > /dev/null 2>&1; then
        print_info "Adding upstream remote for course updates"
        git remote add upstream https://github.com/bitcode/ARM-AArch64-Assembly-Language-University.git
        print_success "Upstream remote configured"
    else
        print_info "Upstream remote already configured"
    fi

    # Fetch latest from upstream
    print_info "Fetching latest course content..."
    git fetch upstream --quiet

    # Create student work branch if it doesn't exist
    if git show-ref --verify --quiet refs/heads/$STUDENT_BRANCH; then
        print_info "Student branch '$STUDENT_BRANCH' already exists"
        git checkout $STUDENT_BRANCH --quiet
    else
        print_info "Creating student work branch: $STUDENT_BRANCH"
        git checkout -b $STUDENT_BRANCH --quiet
    fi

    # Ensure we're up to date with main
    print_info "Syncing with latest course content..."
    git merge upstream/main --no-edit --quiet 2>/dev/null || {
        print_warning "Merge conflicts detected - this is normal for existing repositories"
        print_info "Your student work is preserved. Run ./update-course.sh for updates."
    }

    print_success "Simplified Git workflow configured"
    print_info "• Work on branch: $STUDENT_BRANCH"
    print_info "• Update course: ./update-course.sh"
    print_info "• Standard fork-and-branch workflow active"
}

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

install_linux_dependencies() {
    print_info "Installing ARM development tools for Linux..."

    if command -v apt-get &> /dev/null; then
        print_info "Detected Debian/Ubuntu - using apt"
        sudo apt-get update -qq
        sudo apt-get install -y gcc-aarch64-linux-gnu qemu-user-static build-essential
    elif command -v yum &> /dev/null; then
        print_info "Detected RHEL/CentOS - using yum"
        sudo yum install -y gcc-aarch64-linux-gnu qemu-user-static
    elif command -v dnf &> /dev/null; then
        print_info "Detected Fedora - using dnf"
        sudo dnf install -y gcc-aarch64-linux-gnu qemu-user-static
    elif command -v pacman &> /dev/null; then
        print_info "Detected Arch Linux - using pacman"
        sudo pacman -S --noconfirm aarch64-linux-gnu-gcc qemu-arch-extra
    else
        print_error "Unsupported Linux distribution"
        print_info "Please install manually: gcc-aarch64-linux-gnu, qemu-user-static"
        exit 1
    fi
}

install_macos_dependencies() {
    print_info "Installing ARM development tools for macOS..."

    if ! command -v brew &> /dev/null; then
        print_error "Homebrew required. Install from: https://brew.sh"
        print_info "Run: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    print_info "Installing via Homebrew..."
    brew install aarch64-elf-gcc
    
    # For macOS, we need QEMU user mode emulation
    print_info "Installing QEMU with user mode emulation..."
    if ! command -v qemu-aarch64 &> /dev/null; then
        # Try to install QEMU with user mode support
        brew install qemu || true
        
        # Check if we have user mode emulation
        if ! command -v qemu-aarch64 &> /dev/null; then
            print_warning "QEMU user mode emulation not available via Homebrew"
            print_info "You can still build programs, but testing requires Docker or Linux VM"
            print_info "Alternative: Use Docker with Linux container for testing"
        fi
    fi
    
    # Update toolchain prefix for macOS
    TOOLCHAIN_PREFIX="aarch64-elf"
}

install_windows_dependencies() {
    print_info "Windows detected - WSL2 recommended"
    print_warning "For best experience, use Windows Subsystem for Linux 2 (WSL2)"
    print_info "1. Install WSL2: https://docs.microsoft.com/en-us/windows/wsl/install"
    print_info "2. Install Ubuntu from Microsoft Store"
    print_info "3. Run this setup script inside WSL2"
    
    # Check if we're in WSL
    if grep -qi microsoft /proc/version 2>/dev/null; then
        print_info "WSL detected - proceeding with Linux installation"
        install_linux_dependencies
    else
        print_error "Native Windows not supported. Please use WSL2."
        exit 1
    fi
}

verify_installation() {
    show_progress "Verifying tools installation"

    local all_good=true

    # Check cross-compiler
    if command -v ${TOOLCHAIN_PREFIX}-gcc &> /dev/null; then
        print_success "ARM GCC compiler found (${TOOLCHAIN_PREFIX}-gcc)"
    else
        print_error "ARM GCC not found (${TOOLCHAIN_PREFIX}-gcc)"
        all_good=false
    fi

    # Check QEMU (different commands on different platforms)
    if command -v qemu-aarch64-static &> /dev/null; then
        print_success "QEMU emulator found (qemu-aarch64-static)"
    elif command -v qemu-aarch64 &> /dev/null; then
        print_success "QEMU emulator found (qemu-aarch64)"
    elif command -v qemu-system-aarch64 &> /dev/null; then
        print_warning "QEMU system emulation found (limited functionality)"
        print_info "User mode emulation preferred for this course"
        print_info "You can still build programs, testing may require workarounds"
    else
        print_warning "QEMU not found"
        print_info "You can still build programs, but cannot test execution"
        print_info "Consider using Docker with Linux container for testing"
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
    show_progress "Testing your setup with Hello World"

    local test_dir="/tmp/arm_test_$$"
    mkdir -p "$test_dir"
    cd "$test_dir"

    # Create simple test program
    cat > hello.s << 'EOF'
.section .data
msg: .ascii "ARM toolchain works!\n"
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

    # Build and test
    print_info "Building test program with: ${TOOLCHAIN_PREFIX}-gcc"
    # Try different linking approaches for different toolchains
    if ${TOOLCHAIN_PREFIX}-gcc -nostdlib -static hello.s -o hello 2>build_error.log; then
        # Try different QEMU commands based on platform
        local qemu_cmd=""
        if command -v qemu-aarch64-static &> /dev/null; then
            qemu_cmd="qemu-aarch64-static"
        elif command -v qemu-aarch64 &> /dev/null; then
            qemu_cmd="qemu-aarch64"
        fi
        
        if [ -n "$qemu_cmd" ]; then
            if $qemu_cmd ./hello 2>/dev/null; then
                print_success "Test program executed successfully!"
            else
                print_warning "Test program built but failed to run"
                print_info "This may be normal on some systems"
                print_info "You can still build and test programs manually"
            fi
        else
            print_warning "QEMU not found for testing"
            print_info "Program built successfully, but cannot test execution"
            print_info "Install QEMU to test programs: brew install qemu"
        fi
    else
        print_warning "Test program failed to build"
        if [ -f build_error.log ]; then
            print_info "Build errors:"
            cat build_error.log | head -3
        fi
        print_info "This may be normal on some systems"
        print_info "You can still build programs manually"
        print_warning "Toolchain test failed, but continuing setup"
    fi

    # Cleanup
    cd - > /dev/null
    rm -rf "$test_dir"
}

create_build_script() {
    show_progress "Creating build helper script"

    # Create build script in the repo root
    cat > build.sh << EOF
#!/bin/bash
# ARM Assembly Build Script
# Usage: ./build.sh <file.s> [output_name]

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ \$# -eq 0 ]; then
    echo -e "\${BLUE}ARM Assembly Build Script\${NC}"
    echo "Usage: ./build.sh <file.s> [output_name]"
    echo "Example: ./build.sh hello.s"
    echo "Example: ./build.sh hello.s my_program"
    exit 1
fi

SOURCE="\$1"
OUTPUT="\${2:-\${SOURCE%.*}}"

# Check if source file exists
if [ ! -f "\$SOURCE" ]; then
    echo -e "\${RED}✗ Error: Source file '\$SOURCE' not found\${NC}"
    exit 1
fi

echo -e "\${BLUE}Building \$SOURCE...\${NC}"

# Detect toolchain (Linux vs macOS)
if command -v aarch64-linux-gnu-gcc &> /dev/null; then
    TOOLCHAIN="aarch64-linux-gnu-gcc"
elif command -v aarch64-elf-gcc &> /dev/null; then
    TOOLCHAIN="aarch64-elf-gcc"
else
    echo -e "\${RED}✗ Error: No ARM toolchain found\${NC}"
    echo "Run ./setup.sh to install the toolchain"
    exit 1
fi

# Build the program
if \$TOOLCHAIN -static "\$SOURCE" -o "\$OUTPUT" 2>/dev/null; then
    echo -e "\${GREEN}✓ Built successfully: \$OUTPUT\${NC}"
    echo -e "\${BLUE}Run with: qemu-aarch64-static ./\$OUTPUT\${NC}"
else
    echo -e "\${RED}✗ Build failed\${NC}"
    echo "Check your assembly syntax and try again"
    exit 1
fi
EOF

    chmod +x build.sh
    print_success "Created build.sh helper script"
}

create_workspace_structure() {
    show_progress "Setting up workspace structure"
    
    # Move to simplified module structure if redesigned modules exist
    if [ -d "modules-redesigned" ]; then
        print_info "Migrating to simplified module structure..."
        
        # Backup old modules if they exist
        if [ -d "modules" ] && [ ! -d "modules-old" ]; then
            mv modules modules-old
            print_info "Old modules backed up to modules-old/"
        fi
        
        # Move redesigned modules to main location
        mv modules-redesigned modules
        print_success "Migrated to simplified module structure"
    fi
    
    # Ensure student work directories exist in simplified structure
    for module in m{1..8}; do
        if [ -d "modules/$module" ]; then
            mkdir -p "modules/$module/student-work"
            mkdir -p "modules/$module/personal-notes"
        fi
    done
    
    print_success "Workspace structure ready"
}

show_next_steps() {
    show_progress "Setup complete! 🎉"

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
    echo -e "${GREEN}1.${NC} Go to Module 1: ${BLUE}cd modules/m1/exercises${NC}"
    echo -e "${GREEN}2.${NC} Start first exercise: ${BLUE}cp hello.s my-hello.s${NC}"
    echo -e "${GREEN}3.${NC} Edit the file and look for: ${YELLOW}★ START HERE ★${NC}"
    echo -e "${GREEN}4.${NC} Build your code: ${BLUE}../../../build.sh my-hello.s${NC}"
    echo -e "${GREEN}5.${NC} Run your program: ${BLUE}qemu-aarch64-static ./my-hello${NC}"

    echo -e "\n${BOLD}Quick commands:${NC}"
    echo -e "  Build: ${BLUE}./build.sh <file.s>${NC}"
    echo -e "  Run:   ${BLUE}qemu-aarch64-static ./<program>${NC}"

    echo -e "\n${BOLD}Need help?${NC}"
    echo -e "  Documentation: ${BLUE}docs/${NC}"
    echo -e "  Troubleshooting: ${BLUE}docs/STUDENT-TROUBLESHOOTING.md${NC}"
    echo -e "  Community: ${BLUE}GitHub Discussions${NC}"

    echo -e "\n${YELLOW}Happy coding! 🎯${NC}"
    echo -e "${BLUE}Estimated setup time: $(date +%s) seconds${NC}"
}

main() {
    local start_time=$(date +%s)
    
    show_banner

    print_header "Setting up your ARM assembly environment"
    echo -e "${BLUE}Target: Fork → Setup → Start Coding in under 5 minutes${NC}\n"

    # Step 1: Git workflow
    setup_git_workflow

    # Step 2: Install tools based on platform
    local platform=$(detect_platform)
    show_progress "Detected platform: $platform"

    case $platform in
        "linux")
            install_linux_dependencies
            ;;
        "macos")
            install_macos_dependencies
            ;;
        "windows")
            install_windows_dependencies
            ;;
        *)
            print_error "Unsupported platform: $platform"
            print_info "Supported: Linux, macOS, Windows (with WSL2)"
            exit 1
            ;;
    esac

    # Step 3: Verify installation
    if ! verify_installation; then
        print_error "Tool verification failed. Please check the errors above."
        exit 1
    fi

    # Step 4: Test with hello world
    test_toolchain || print_warning "Toolchain test had issues, but setup continues"

    # Step 5: Create helper scripts and workspace
    create_build_script
    create_workspace_structure

    # Step 6: Show success and next steps
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    show_next_steps
    
    echo -e "\n${GREEN}✓ Setup completed in ${duration} seconds${NC}"
    
    if [ $duration -lt 300 ]; then
        echo -e "${GREEN}🎯 Goal achieved: Setup completed in under 5 minutes!${NC}"
    fi
}

# Run main function
main "$@"
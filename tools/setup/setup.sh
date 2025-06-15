#!/bin/bash

# ARM AArch64 Assembly Language University - Setup Script
# Platform: Linux/macOS
# Description: Automated development environment setup

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COURSE_NAME="ARM AArch64 Assembly Language University"
REQUIRED_TOOLS=("gcc" "as" "ld" "qemu-aarch64-static")
TOOLCHAIN_PREFIX="aarch64-linux-gnu"

# Functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
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
    echo -e "${BLUE}ℹ $1${NC}"
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
    print_info "Detecting Linux distribution..."
    
    if command -v apt-get &> /dev/null; then
        print_info "Using apt package manager (Debian/Ubuntu)"
        sudo apt-get update
        sudo apt-get install -y \
            gcc-aarch64-linux-gnu \
            binutils-aarch64-linux-gnu \
            qemu-user-static \
            gdb-multiarch \
            build-essential
    elif command -v yum &> /dev/null; then
        print_info "Using yum package manager (RHEL/CentOS)"
        sudo yum install -y \
            gcc-aarch64-linux-gnu \
            binutils-aarch64-linux-gnu \
            qemu-user-static \
            gdb
    elif command -v pacman &> /dev/null; then
        print_info "Using pacman package manager (Arch Linux)"
        sudo pacman -S --noconfirm \
            aarch64-linux-gnu-gcc \
            aarch64-linux-gnu-binutils \
            qemu-arch-extra \
            gdb
    else
        print_error "Unsupported Linux distribution"
        print_info "Please install manually: gcc-aarch64-linux-gnu, qemu-user-static"
        exit 1
    fi
}

install_macos_dependencies() {
    print_info "Installing dependencies for macOS..."
    
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew not found. Please install Homebrew first:"
        print_info "https://brew.sh"
        exit 1
    fi
    
    brew install aarch64-elf-gcc
    brew install qemu
    brew install gdb
}

verify_installation() {
    print_header "Verifying Installation"
    
    local all_good=true
    
    # Check cross-compiler
    if command -v ${TOOLCHAIN_PREFIX}-gcc &> /dev/null; then
        local gcc_version=$(${TOOLCHAIN_PREFIX}-gcc --version | head -n1)
        print_success "ARM GCC found: $gcc_version"
    else
        print_error "ARM GCC not found (${TOOLCHAIN_PREFIX}-gcc)"
        all_good=false
    fi
    
    # Check assembler
    if command -v ${TOOLCHAIN_PREFIX}-as &> /dev/null; then
        local as_version=$(${TOOLCHAIN_PREFIX}-as --version | head -n1)
        print_success "ARM Assembler found: $as_version"
    else
        print_error "ARM Assembler not found (${TOOLCHAIN_PREFIX}-as)"
        all_good=false
    fi
    
    # Check linker
    if command -v ${TOOLCHAIN_PREFIX}-ld &> /dev/null; then
        local ld_version=$(${TOOLCHAIN_PREFIX}-ld --version | head -n1)
        print_success "ARM Linker found: $ld_version"
    else
        print_error "ARM Linker not found (${TOOLCHAIN_PREFIX}-ld)"
        all_good=false
    fi
    
    # Check QEMU
    if command -v qemu-aarch64-static &> /dev/null; then
        local qemu_version=$(qemu-aarch64-static --version | head -n1)
        print_success "QEMU AArch64 found: $qemu_version"
    else
        print_error "QEMU AArch64 not found (qemu-aarch64-static)"
        all_good=false
    fi
    
    if $all_good; then
        print_success "All required tools are installed!"
        return 0
    else
        print_error "Some tools are missing. Please install them manually."
        return 1
    fi
}

test_toolchain() {
    print_header "Testing Toolchain"
    
    local test_dir="/tmp/arm_assembly_test"
    mkdir -p "$test_dir"
    cd "$test_dir"
    
    # Create test assembly program
    cat > test.s << 'EOF'
.section .text
.global _start

_start:
    mov x8, #93    # sys_exit
    mov x0, #42    # exit status
    svc #0         # system call
EOF
    
    # Assemble
    if ${TOOLCHAIN_PREFIX}-as -o test.o test.s; then
        print_success "Assembly successful"
    else
        print_error "Assembly failed"
        return 1
    fi
    
    # Link
    if ${TOOLCHAIN_PREFIX}-ld -o test test.o; then
        print_success "Linking successful"
    else
        print_error "Linking failed"
        return 1
    fi
    
    # Run with QEMU
    if qemu-aarch64-static test; then
        local exit_code=$?
        if [ $exit_code -eq 42 ]; then
            print_success "Execution successful (exit code: $exit_code)"
        else
            print_warning "Execution completed but unexpected exit code: $exit_code"
        fi
    else
        print_error "Execution failed"
        return 1
    fi
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$test_dir"
    
    print_success "Toolchain test completed successfully!"
}

create_environment_script() {
    print_header "Creating Environment Script"
    
    local env_script="$HOME/.arm_assembly_env"
    
    cat > "$env_script" << EOF
# ARM AArch64 Assembly Language University Environment
# Source this file to set up your development environment

# Toolchain configuration
export ARM_TOOLCHAIN_PREFIX="${TOOLCHAIN_PREFIX}"
export ARM_AS="\${ARM_TOOLCHAIN_PREFIX}-as"
export ARM_LD="\${ARM_TOOLCHAIN_PREFIX}-ld"
export ARM_GCC="\${ARM_TOOLCHAIN_PREFIX}-gcc"
export ARM_GDB="\${ARM_TOOLCHAIN_PREFIX}-gdb"
export ARM_OBJDUMP="\${ARM_TOOLCHAIN_PREFIX}-objdump"

# QEMU configuration
export ARM_QEMU="qemu-aarch64-static"

# Helper functions
arm_build() {
    local source="\$1"
    local output="\${2:-\${source%.*}}"
    
    echo "Building \$source -> \$output"
    \$ARM_AS -o "\${output}.o" "\$source" && \\
    \$ARM_LD -o "\$output" "\${output}.o"
}

arm_run() {
    local program="\$1"
    echo "Running \$program with QEMU"
    \$ARM_QEMU "\$program"
}

arm_debug() {
    local program="\$1"
    echo "Debugging \$program with GDB"
    \$ARM_GDB "\$program"
}

echo "ARM AArch64 Assembly development environment loaded"
echo "Available commands: arm_build, arm_run, arm_debug"
EOF
    
    print_success "Environment script created: $env_script"
    print_info "Add this to your shell profile to load automatically:"
    print_info "echo 'source $env_script' >> ~/.bashrc"
}

main() {
    print_header "$COURSE_NAME Setup"
    
    local platform=$(detect_platform)
    print_info "Detected platform: $platform"
    
    case $platform in
        "linux")
            install_linux_dependencies
            ;;
        "macos")
            install_macos_dependencies
            ;;
        *)
            print_error "Unsupported platform: $platform"
            print_info "Please see manual setup instructions"
            exit 1
            ;;
    esac
    
    if verify_installation; then
        test_toolchain
        create_environment_script
        
        print_header "Setup Complete!"
        print_success "Your ARM AArch64 development environment is ready!"
        print_info ""
        print_info "Next steps:"
        print_info "1. Source the environment: source ~/.arm_assembly_env"
        print_info "2. Navigate to Module 1: cd modules/m1-foundation"
        print_info "3. Start with the first exercise: code exercises/1.1-hello-beginner.s"
        print_info ""
        print_info "For help, see: tools/setup/manual-setup.md"
    else
        print_error "Setup failed. Please check the errors above."
        exit 1
    fi
}

# Run main function
main "$@"
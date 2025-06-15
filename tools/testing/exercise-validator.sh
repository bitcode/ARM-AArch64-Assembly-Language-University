#!/bin/bash

# ARM Assembly Exercise Validator
# This script validates and tests ARM assembly exercises
# Usage: ./exercise-validator.sh <exercise-file> [options]

set -e

# Configuration
TOOLCHAIN_PREFIX="aarch64-linux-gnu"
QEMU_BINARY="qemu-aarch64-static"
BUILD_DIR="./build"
TIMEOUT=10

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print usage
usage() {
    echo "ARM Assembly Exercise Validator"
    echo "Usage: $0 <exercise-file> [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -v, --verbose       Enable verbose output"
    echo "  -t, --timeout SEC   Set execution timeout (default: 10)"
    echo "  -d, --debug         Enable debug mode with GDB"
    echo "  -c, --clean         Clean build artifacts after testing"
    echo ""
    echo "Examples:"
    echo "  $0 modules/m1-foundation/exercises/1.1-hello-beginner.s"
    echo "  $0 modules/m2-data-registers/exercises/2.1-registers-beginner.s -v"
    echo "  $0 modules/m3-basic-instruction-set/exercises/3.1-addition-beginner.s -d"
}

# Function to check prerequisites
check_prerequisites() {
    print_status $BLUE "Checking prerequisites..."
    
    # Check for ARM toolchain
    if ! command -v ${TOOLCHAIN_PREFIX}-as &> /dev/null; then
        print_status $RED "ERROR: ARM toolchain not found (${TOOLCHAIN_PREFIX}-as)"
        print_status $YELLOW "Please install ARM cross-compilation toolchain"
        exit 1
    fi
    
    if ! command -v ${TOOLCHAIN_PREFIX}-ld &> /dev/null; then
        print_status $RED "ERROR: ARM linker not found (${TOOLCHAIN_PREFIX}-ld)"
        exit 1
    fi
    
    # Check for QEMU
    if ! command -v $QEMU_BINARY &> /dev/null; then
        print_status $RED "ERROR: QEMU not found ($QEMU_BINARY)"
        print_status $YELLOW "Please install qemu-user-static"
        exit 1
    fi
    
    print_status $GREEN "Prerequisites check passed"
}

# Function to extract metadata from exercise file
extract_metadata() {
    local file=$1
    local temp_file=$(mktemp)
    
    # Extract YAML metadata between --- markers
    sed -n '/^---$/,/^---$/p' "$file" | sed '1d;$d' > "$temp_file"
    
    if [ -s "$temp_file" ]; then
        echo "Metadata found in $file"
        if [ "$VERBOSE" = true ]; then
            cat "$temp_file"
        fi
    else
        echo "No metadata found in $file"
    fi
    
    rm "$temp_file"
}

# Function to validate assembly syntax
validate_syntax() {
    local file=$1
    local basename=$(basename "$file" .s)
    local obj_file="$BUILD_DIR/${basename}.o"
    
    print_status $BLUE "Validating assembly syntax..."
    
    # Create build directory
    mkdir -p "$BUILD_DIR"
    
    # Assemble the file
    if ${TOOLCHAIN_PREFIX}-as -o "$obj_file" "$file" 2>&1; then
        print_status $GREEN "Assembly syntax validation passed"
        return 0
    else
        print_status $RED "Assembly syntax validation failed"
        return 1
    fi
}

# Function to build executable
build_executable() {
    local file=$1
    local basename=$(basename "$file" .s)
    local obj_file="$BUILD_DIR/${basename}.o"
    local exe_file="$BUILD_DIR/${basename}"
    
    print_status $BLUE "Building executable..."
    
    # Link the object file
    if ${TOOLCHAIN_PREFIX}-ld -o "$exe_file" "$obj_file" 2>&1; then
        print_status $GREEN "Build successful"
        echo "$exe_file"
        return 0
    else
        print_status $RED "Build failed"
        return 1
    fi
}

# Function to run executable
run_executable() {
    local exe_file=$1
    
    print_status $BLUE "Running executable..."
    
    # Run with timeout
    if timeout $TIMEOUT $QEMU_BINARY "$exe_file"; then
        local exit_code=$?
        print_status $GREEN "Execution completed with exit code: $exit_code"
        return $exit_code
    else
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            print_status $RED "Execution timed out after $TIMEOUT seconds"
        else
            print_status $RED "Execution failed with exit code: $exit_code"
        fi
        return $exit_code
    fi
}

# Function to run with debugger
debug_executable() {
    local exe_file=$1
    
    print_status $BLUE "Starting debug session..."
    print_status $YELLOW "Starting QEMU with GDB server on port 1234..."
    
    # Start QEMU with GDB server in background
    $QEMU_BINARY -g 1234 "$exe_file" &
    local qemu_pid=$!
    
    sleep 1
    
    print_status $YELLOW "Connect with: gdb-multiarch $exe_file"
    print_status $YELLOW "Then run: target remote :1234"
    print_status $YELLOW "Press Enter to continue or Ctrl+C to abort..."
    read
    
    # Kill QEMU process
    kill $qemu_pid 2>/dev/null || true
}

# Function to analyze object file
analyze_object() {
    local file=$1
    local basename=$(basename "$file" .s)
    local obj_file="$BUILD_DIR/${basename}.o"
    
    if [ "$VERBOSE" = true ]; then
        print_status $BLUE "Analyzing object file..."
        
        echo "=== Object file information ==="
        file "$obj_file"
        
        echo "=== Symbol table ==="
        ${TOOLCHAIN_PREFIX}-nm "$obj_file" 2>/dev/null || echo "No symbols found"
        
        echo "=== Disassembly ==="
        ${TOOLCHAIN_PREFIX}-objdump -d "$obj_file" 2>/dev/null || echo "Disassembly failed"
    fi
}

# Function to clean build artifacts
clean_build() {
    if [ "$CLEAN" = true ]; then
        print_status $BLUE "Cleaning build artifacts..."
        rm -rf "$BUILD_DIR"
        print_status $GREEN "Build artifacts cleaned"
    fi
}

# Function to validate exercise requirements
validate_exercise_requirements() {
    local file=$1
    
    print_status $BLUE "Validating exercise requirements..."
    
    # Check for required sections
    if grep -q "\.section \.text" "$file"; then
        print_status $GREEN "✓ .text section found"
    else
        print_status $YELLOW "⚠ .text section not found"
    fi
    
    if grep -q "\.global _start" "$file"; then
        print_status $GREEN "✓ _start symbol found"
    else
        print_status $RED "✗ _start symbol not found"
    fi
    
    if grep -q "_start:" "$file"; then
        print_status $GREEN "✓ _start label found"
    else
        print_status $RED "✗ _start label not found"
    fi
    
    # Check for system call exit
    if grep -q "mov.*#93" "$file" && grep -q "svc.*#0" "$file"; then
        print_status $GREEN "✓ Exit system call found"
    else
        print_status $YELLOW "⚠ Exit system call pattern not found"
    fi
    
    # Check for metadata
    if grep -q "exercise_metadata:" "$file"; then
        print_status $GREEN "✓ Exercise metadata found"
    else
        print_status $YELLOW "⚠ Exercise metadata not found"
    fi
    
    # Check for ARM manual references
    if grep -q "ARM Manual References:" "$file"; then
        print_status $GREEN "✓ ARM manual references found"
    else
        print_status $YELLOW "⚠ ARM manual references not found"
    fi
    
    # Check for research prompts
    if grep -q "Research Questions" "$file"; then
        print_status $GREEN "✓ Research questions found"
    else
        print_status $YELLOW "⚠ Research questions not found"
    fi
}

# Main function
main() {
    local exercise_file=""
    local VERBOSE=false
    local DEBUG=false
    local CLEAN=false
    
    # Parse command line arguments
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
            -t|--timeout)
                TIMEOUT="$2"
                shift 2
                ;;
            -d|--debug)
                DEBUG=true
                shift
                ;;
            -c|--clean)
                CLEAN=true
                shift
                ;;
            -*)
                echo "Unknown option $1"
                usage
                exit 1
                ;;
            *)
                if [ -z "$exercise_file" ]; then
                    exercise_file="$1"
                else
                    echo "Multiple files not supported"
                    usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Check if exercise file is provided
    if [ -z "$exercise_file" ]; then
        echo "Error: Exercise file not specified"
        usage
        exit 1
    fi
    
    # Check if file exists
    if [ ! -f "$exercise_file" ]; then
        print_status $RED "Error: File '$exercise_file' not found"
        exit 1
    fi
    
    print_status $BLUE "=== ARM Assembly Exercise Validator ==="
    print_status $BLUE "Validating: $exercise_file"
    echo
    
    # Run validation steps
    check_prerequisites
    echo
    
    extract_metadata "$exercise_file"
    echo
    
    validate_exercise_requirements "$exercise_file"
    echo
    
    if validate_syntax "$exercise_file"; then
        echo
        
        if exe_file=$(build_executable "$exercise_file"); then
            echo
            
            analyze_object "$exercise_file"
            echo
            
            if [ "$DEBUG" = true ]; then
                debug_executable "$exe_file"
            else
                run_executable "$exe_file"
            fi
            echo
        fi
    fi
    
    clean_build
    
    print_status $GREEN "=== Validation Complete ==="
}

# Run main function with all arguments
main "$@"
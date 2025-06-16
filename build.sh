#!/bin/bash
# ARM Assembly Build Script
# Usage: ./build.sh <file.s> [output_name]

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${BLUE}ARM Assembly Build Script${NC}"
    echo "Usage: ./build.sh <file.s> [output_name]"
    echo "Example: ./build.sh hello.s"
    echo "Example: ./build.sh hello.s my_program"
    exit 1
fi

SOURCE="$1"
OUTPUT="${2:-${SOURCE%.*}}"

# Check if source file exists
if [ ! -f "$SOURCE" ]; then
    echo -e "${RED}✗ Error: Source file '$SOURCE' not found${NC}"
    exit 1
fi

echo -e "${BLUE}Building $SOURCE...${NC}"

# Detect toolchain (Linux vs macOS)
if command -v aarch64-linux-gnu-gcc &> /dev/null; then
    TOOLCHAIN="aarch64-linux-gnu-gcc"
elif command -v aarch64-elf-gcc &> /dev/null; then
    TOOLCHAIN="aarch64-elf-gcc"
else
    echo -e "${RED}✗ Error: No ARM toolchain found${NC}"
    echo "Run ./setup.sh to install the toolchain"
    exit 1
fi

# Build the program
echo -e "${BLUE}Using toolchain: $TOOLCHAIN${NC}"

# Different build approaches for different toolchains
if [[ "$TOOLCHAIN" == *"aarch64-elf-gcc"* ]]; then
    # Bare metal toolchain - use nostdlib
    if $TOOLCHAIN -nostdlib -static "$SOURCE" -o "$OUTPUT" 2>build_error.log; then
        echo -e "${GREEN}✓ Built successfully: $OUTPUT${NC}"
        echo -e "${BLUE}Note: Using bare metal toolchain - QEMU user mode may not work${NC}"
        echo -e "${BLUE}Try: qemu-aarch64-static ./$OUTPUT (if available)${NC}"
    else
        echo -e "${RED}✗ Build failed${NC}"
        echo "Build errors:"
        cat build_error.log
        exit 1
    fi
else
    # Linux toolchain - use standard flags
    if $TOOLCHAIN -static "$SOURCE" -o "$OUTPUT" 2>build_error.log; then
        echo -e "${GREEN}✓ Built successfully: $OUTPUT${NC}"
        echo -e "${BLUE}Run with: qemu-aarch64-static ./$OUTPUT${NC}"
    else
        echo -e "${RED}✗ Build failed${NC}"
        echo "Build errors:"
        cat build_error.log
        exit 1
    fi
fi

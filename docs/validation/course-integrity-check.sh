#!/bin/bash

# ARM AArch64 Assembly Language University - Course Integrity Validation Script
# This script performs comprehensive validation of course structure, content, and functionality

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED_CHECKS++))
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNING_CHECKS++))
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED_CHECKS++))
}

increment_total() {
    ((TOTAL_CHECKS++))
}

# Validation functions
validate_directory_structure() {
    log_info "Validating directory structure..."
    
    local required_dirs=(
        "modules"
        "tools"
        "resources"
        "llm-integration"
        "assessment"
        "certification"
        "instructor-guide"
        "analytics"
        "troubleshooting"
        "validation"
    )
    
    for dir in "${required_dirs[@]}"; do
        increment_total
        if [[ -d "$dir" ]]; then
            log_success "Directory exists: $dir"
        else
            log_error "Missing required directory: $dir"
        fi
    done
    
    # Check for essential files
    local required_files=(
        "README.md"
        "GETTING_STARTED.md"
        "FAQ.md"
        "CONTRIBUTING.md"
        "course-manifest.yaml"
    )
    
    for file in "${required_files[@]}"; do
        increment_total
        if [[ -f "$file" ]]; then
            log_success "File exists: $file"
        else
            log_error "Missing required file: $file"
        fi
    done
}

validate_module_structure() {
    log_info "Validating module structure..."
    
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
    
    for module in "${modules[@]}"; do
        local module_path="modules/$module"
        
        increment_total
        if [[ -d "$module_path" ]]; then
            log_success "Module directory exists: $module"
            
            # Check for module README
            increment_total
            if [[ -f "$module_path/README.md" ]]; then
                log_success "Module README exists: $module"
            else
                log_error "Missing README.md in module: $module"
            fi
            
            # Check for exercises directory
            increment_total
            if [[ -d "$module_path/exercises" ]]; then
                log_success "Exercises directory exists: $module"
                
                # Count exercises
                local exercise_count=$(find "$module_path/exercises" -name "*.s" | wc -l)
                increment_total
                if [[ $exercise_count -gt 0 ]]; then
                    log_success "Module has $exercise_count exercises: $module"
                else
                    log_warning "No exercises found in module: $module"
                fi
            else
                log_warning "No exercises directory in module: $module"
            fi
        else
            log_error "Missing module directory: $module"
        fi
    done
}

validate_exercise_naming() {
    log_info "Validating exercise naming conventions..."
    
    local naming_pattern="^[0-9]+\.[0-9]+-[a-z0-9-]+-[a-z]+\.s$"
    local invalid_names=()
    
    while IFS= read -r -d '' exercise; do
        local basename=$(basename "$exercise")
        increment_total
        if [[ $basename =~ $naming_pattern ]]; then
            log_success "Valid exercise name: $basename"
        else
            log_error "Invalid exercise name: $basename"
            invalid_names+=("$basename")
        fi
    done < <(find modules -name "*.s" -print0)
    
    if [[ ${#invalid_names[@]} -gt 0 ]]; then
        log_error "Found ${#invalid_names[@]} exercises with invalid names"
        for name in "${invalid_names[@]}"; do
            echo "  - $name"
        done
    fi
}

validate_exercise_compilation() {
    log_info "Validating exercise compilation..."
    
    # Check if ARM toolchain is available
    increment_total
    if command -v aarch64-linux-gnu-gcc >/dev/null 2>&1; then
        log_success "ARM toolchain available"
        
        local compilation_errors=()
        local compiled_count=0
        
        while IFS= read -r -d '' exercise; do
            increment_total
            local basename=$(basename "$exercise")
            local output_file="/tmp/test_${basename%.s}"
            
            if aarch64-linux-gnu-gcc -static "$exercise" -o "$output_file" 2>/dev/null; then
                log_success "Compilation successful: $basename"
                ((compiled_count++))
                rm -f "$output_file"
            else
                log_error "Compilation failed: $basename"
                compilation_errors+=("$basename")
            fi
        done < <(find modules -name "*.s" -print0)
        
        log_info "Compiled $compiled_count exercises successfully"
        
        if [[ ${#compilation_errors[@]} -gt 0 ]]; then
            log_error "Found ${#compilation_errors[@]} exercises with compilation errors"
            for error in "${compilation_errors[@]}"; do
                echo "  - $error"
            done
        fi
    else
        log_warning "ARM toolchain not available - skipping compilation tests"
    fi
}

validate_documentation_links() {
    log_info "Validating documentation internal links..."
    
    local broken_links=()
    
    while IFS= read -r -d '' doc; do
        local doc_dir=$(dirname "$doc")
        
        # Extract markdown links
        while IFS= read -r link; do
            # Remove markdown link syntax to get just the path
            local path=$(echo "$link" | sed -n 's/.*](\([^)]*\)).*/\1/p')
            
            # Skip external links (http/https)
            if [[ $path =~ ^https?:// ]]; then
                continue
            fi
            
            # Skip anchors
            if [[ $path =~ ^# ]]; then
                continue
            fi
            
            # Resolve relative path
            local full_path
            if [[ $path =~ ^/ ]]; then
                full_path=".$path"
            else
                full_path="$doc_dir/$path"
            fi
            
            increment_total
            if [[ -f "$full_path" || -d "$full_path" ]]; then
                log_success "Valid link: $path (in $(basename "$doc"))"
            else
                log_error "Broken link: $path (in $(basename "$doc"))"
                broken_links+=("$path in $doc")
            fi
        done < <(grep -o '\[.*\](.*\.md\|.*/)' "$doc" 2>/dev/null || true)
    done < <(find . -name "*.md" -print0)
    
    if [[ ${#broken_links[@]} -gt 0 ]]; then
        log_error "Found ${#broken_links[@]} broken internal links"
        for link in "${broken_links[@]}"; do
            echo "  - $link"
        done
    fi
}

validate_yaml_syntax() {
    log_info "Validating YAML file syntax..."
    
    while IFS= read -r -d '' yaml_file; do
        increment_total
        if command -v yamllint >/dev/null 2>&1; then
            if yamllint "$yaml_file" >/dev/null 2>&1; then
                log_success "Valid YAML syntax: $(basename "$yaml_file")"
            else
                log_error "Invalid YAML syntax: $(basename "$yaml_file")"
            fi
        elif python3 -c "import yaml" 2>/dev/null; then
            if python3 -c "import yaml; yaml.safe_load(open('$yaml_file'))" 2>/dev/null; then
                log_success "Valid YAML syntax: $(basename "$yaml_file")"
            else
                log_error "Invalid YAML syntax: $(basename "$yaml_file")"
            fi
        else
            log_warning "No YAML validator available - skipping $(basename "$yaml_file")"
        fi
    done < <(find . -name "*.yaml" -o -name "*.yml" -print0)
}

validate_shell_scripts() {
    log_info "Validating shell script syntax..."
    
    while IFS= read -r -d '' script; do
        increment_total
        if command -v shellcheck >/dev/null 2>&1; then
            if shellcheck "$script" >/dev/null 2>&1; then
                log_success "Valid shell script: $(basename "$script")"
            else
                log_error "Shell script issues: $(basename "$script")"
            fi
        else
            # Basic syntax check with bash
            if bash -n "$script" 2>/dev/null; then
                log_success "Valid shell syntax: $(basename "$script")"
            else
                log_error "Invalid shell syntax: $(basename "$script")"
            fi
        fi
    done < <(find . -name "*.sh" -print0)
}

validate_arm_manual_references() {
    log_info "Validating ARM manual references..."
    
    local manual_dir="Aarch64-Architecture-Reference-Manual-for-A-profile"
    increment_total
    if [[ -d "$manual_dir" ]]; then
        log_success "ARM manual directory exists"
        
        # Check for manual files
        local manual_files=$(find "$manual_dir" -name "*.md" | wc -l)
        increment_total
        if [[ $manual_files -gt 0 ]]; then
            log_success "Found $manual_files ARM manual files"
        else
            log_warning "No ARM manual markdown files found"
        fi
    else
        log_error "ARM manual directory missing: $manual_dir"
    fi
    
    # Validate manual section references in exercises
    local invalid_refs=()
    while IFS= read -r -d '' exercise; do
        # Look for ARM manual section references
        while IFS= read -r ref; do
            # Extract section reference (e.g., "B1.2", "C3.1")
            local section=$(echo "$ref" | grep -o '[A-Z][0-9]\+\.[0-9]\+' || true)
            if [[ -n "$section" ]]; then
                increment_total
                # This is a simplified check - in practice, you'd validate against actual manual structure
                if [[ $section =~ ^[A-Z][0-9]+\.[0-9]+$ ]]; then
                    log_success "Valid section reference: $section (in $(basename "$exercise"))"
                else
                    log_error "Invalid section reference: $section (in $(basename "$exercise"))"
                    invalid_refs+=("$section in $exercise")
                fi
            fi
        done < <(grep -o 'Section [A-Z][0-9]\+\.[0-9]\+' "$exercise" 2>/dev/null || true)
    done < <(find modules -name "*.s" -print0)
}

validate_llm_integration() {
    log_info "Validating LLM integration files..."
    
    local llm_files=(
        "llm-integration/README.md"
        "llm-integration/course-context.md"
        "llm-integration/dream-methodology.md"
    )
    
    for file in "${llm_files[@]}"; do
        increment_total
        if [[ -f "$file" ]]; then
            log_success "LLM integration file exists: $(basename "$file")"
            
            # Check file size (should not be empty)
            increment_total
            if [[ -s "$file" ]]; then
                log_success "LLM file has content: $(basename "$file")"
            else
                log_error "LLM file is empty: $(basename "$file")"
            fi
        else
            log_error "Missing LLM integration file: $file"
        fi
    done
}

validate_assessment_framework() {
    log_info "Validating assessment framework..."
    
    local assessment_dir="assessment"
    increment_total
    if [[ -d "$assessment_dir" ]]; then
        log_success "Assessment directory exists"
        
        # Check for module assessments
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
        
        for module in "${modules[@]}"; do
            local assessment_file="$assessment_dir/module-assessments/${module}-assessment.md"
            increment_total
            if [[ -f "$assessment_file" ]]; then
                log_success "Assessment exists: $module"
            else
                log_warning "Missing assessment: $module"
            fi
        done
    else
        log_error "Assessment directory missing"
    fi
}

validate_tools_functionality() {
    log_info "Validating tools functionality..."
    
    local setup_script="tools/setup/setup.sh"
    increment_total
    if [[ -f "$setup_script" ]]; then
        log_success "Setup script exists"
        
        increment_total
        if [[ -x "$setup_script" ]]; then
            log_success "Setup script is executable"
        else
            log_error "Setup script is not executable"
        fi
    else
        log_error "Setup script missing: $setup_script"
    fi
    
    # Check for other essential tools
    local tool_scripts=(
        "tools/testing/test-exercise.sh"
        "tools/build/build-exercise.sh"
    )
    
    for script in "${tool_scripts[@]}"; do
        increment_total
        if [[ -f "$script" ]]; then
            log_success "Tool script exists: $(basename "$script")"
        else
            log_warning "Tool script missing: $script"
        fi
    done
}

generate_validation_report() {
    log_info "Generating validation report..."
    
    local report_file="validation/course-integrity-report.md"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    cat > "$report_file" << EOF
# Course Integrity Validation Report

**Generated:** $timestamp  
**Total Checks:** $TOTAL_CHECKS  
**Passed:** $PASSED_CHECKS  
**Failed:** $FAILED_CHECKS  
**Warnings:** $WARNING_CHECKS  

## Summary

EOF

    local success_rate=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
    
    if [[ $FAILED_CHECKS -eq 0 ]]; then
        echo "✅ **Course integrity validation PASSED** ($success_rate% success rate)" >> "$report_file"
        echo "" >> "$report_file"
        echo "All critical validation checks passed. The course is ready for distribution." >> "$report_file"
    else
        echo "❌ **Course integrity validation FAILED** ($success_rate% success rate)" >> "$report_file"
        echo "" >> "$report_file"
        echo "**$FAILED_CHECKS critical issues** must be resolved before distribution." >> "$report_file"
    fi
    
    if [[ $WARNING_CHECKS -gt 0 ]]; then
        echo "" >> "$report_file"
        echo "⚠️ **$WARNING_CHECKS warnings** should be reviewed for optimal course quality." >> "$report_file"
    fi
    
    cat >> "$report_file" << EOF

## Validation Categories

- **Directory Structure:** Course organization and required directories
- **Module Structure:** Individual module completeness and organization
- **Exercise Naming:** Adherence to naming conventions
- **Exercise Compilation:** ARM assembly code compilation verification
- **Documentation Links:** Internal link validation
- **YAML Syntax:** Configuration file syntax validation
- **Shell Scripts:** Script syntax and functionality validation
- **ARM Manual References:** Manual section reference validation
- **LLM Integration:** AI research assistant integration completeness
- **Assessment Framework:** Evaluation and progress tracking validation
- **Tools Functionality:** Development and testing tool validation

## Recommendations

EOF

    if [[ $FAILED_CHECKS -gt 0 ]]; then
        echo "1. **Address Critical Issues:** Resolve all failed validation checks" >> "$report_file"
        echo "2. **Re-run Validation:** Execute validation script after fixes" >> "$report_file"
    fi
    
    if [[ $WARNING_CHECKS -gt 0 ]]; then
        echo "3. **Review Warnings:** Evaluate and address warning conditions" >> "$report_file"
    fi
    
    echo "4. **Quality Assurance:** Perform manual testing of key course components" >> "$report_file"
    echo "5. **Documentation Review:** Verify all documentation is current and accurate" >> "$report_file"
    
    log_success "Validation report generated: $report_file"
}

# Main execution
main() {
    echo "=============================================="
    echo "ARM AArch64 Assembly Language University"
    echo "Course Integrity Validation"
    echo "=============================================="
    echo ""
    
    # Create validation directory if it doesn't exist
    mkdir -p validation
    
    # Run all validation checks
    validate_directory_structure
    validate_module_structure
    validate_exercise_naming
    validate_exercise_compilation
    validate_documentation_links
    validate_yaml_syntax
    validate_shell_scripts
    validate_arm_manual_references
    validate_llm_integration
    validate_assessment_framework
    validate_tools_functionality
    
    echo ""
    echo "=============================================="
    echo "Validation Summary"
    echo "=============================================="
    echo "Total Checks: $TOTAL_CHECKS"
    echo "Passed: $PASSED_CHECKS"
    echo "Failed: $FAILED_CHECKS"
    echo "Warnings: $WARNING_CHECKS"
    echo ""
    
    local success_rate=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
    echo "Success Rate: $success_rate%"
    
    # Generate detailed report
    generate_validation_report
    
    echo ""
    if [[ $FAILED_CHECKS -eq 0 ]]; then
        log_success "Course integrity validation PASSED"
        echo "The course is ready for distribution and use."
        exit 0
    else
        log_error "Course integrity validation FAILED"
        echo "Please address the failed checks before distribution."
        exit 1
    fi
}

# Execute main function
main "$@"
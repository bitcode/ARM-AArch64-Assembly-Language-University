#!/bin/bash

# =============================================================================
# ARM Assembly Course - Feedback Collection System
# =============================================================================
# Comprehensive feedback collection for student workflow testing
# Captures both automated metrics and manual user experience feedback

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTING_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FEEDBACK_DIR="$TESTING_ROOT/reports/feedback"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}${BOLD}▶ $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Initialize feedback collection
init_feedback_collection() {
    print_header "Initializing Feedback Collection"
    
    mkdir -p "$FEEDBACK_DIR/automated"
    mkdir -p "$FEEDBACK_DIR/manual"
    mkdir -p "$FEEDBACK_DIR/improvements"
    mkdir -p "$FEEDBACK_DIR/analytics"
    
    print_success "Feedback directories created"
}

# Collect automated metrics
collect_automated_metrics() {
    local scenario="$1"
    local test_workspace="$2"
    
    print_header "Collecting Automated Metrics for $scenario"
    
    local metrics_file="$FEEDBACK_DIR/automated/metrics-$scenario-$TIMESTAMP.json"
    
    # Initialize metrics structure
    cat > "$metrics_file" << EOF
{
  "scenario": "$scenario",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "test_workspace": "$test_workspace",
  "metrics": {
    "performance": {},
    "errors": [],
    "warnings": [],
    "success_indicators": [],
    "user_actions": [],
    "system_state": {}
  }
}
EOF
    
    # Collect performance metrics if test workspace exists
    if [[ -n "$test_workspace" && -d "$test_workspace" ]]; then
        cd "$test_workspace"
        
        # Check for timing logs
        if [[ -f "setup-output.log" ]]; then
            local setup_time=$(grep -o "completed in [0-9]*s" setup-output.log | grep -o "[0-9]*" || echo "0")
            jq --arg time "$setup_time" '.metrics.performance.setup_duration_seconds = ($time | tonumber)' "$metrics_file" > tmp.json && mv tmp.json "$metrics_file"
        fi
        
        # Check for build success
        if [[ -f "build-output.log" ]]; then
            if grep -q "Built successfully" build-output.log; then
                jq '.metrics.success_indicators += ["build_successful"]' "$metrics_file" > tmp.json && mv tmp.json "$metrics_file"
            fi
        fi
        
        # Count files created
        local files_created=$(find . -type f -newer . 2>/dev/null | wc -l || echo "0")
        jq --arg count "$files_created" '.metrics.system_state.files_created = ($count | tonumber)' "$metrics_file" > tmp.json && mv tmp.json "$metrics_file"
        
        # Check Git state
        if git rev-parse --git-dir > /dev/null 2>&1; then
            local commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")
            local branches=$(git branch -a | wc -l || echo "0")
            jq --arg commits "$commits" --arg branches "$branches" \
               '.metrics.system_state.git_commits = ($commits | tonumber) | .metrics.system_state.git_branches = ($branches | tonumber)' \
               "$metrics_file" > tmp.json && mv tmp.json "$metrics_file"
        fi
    fi
    
    print_success "Automated metrics collected: $metrics_file"
}

# Interactive feedback collection
collect_interactive_feedback() {
    local scenario="$1"
    
    print_header "Interactive Feedback Collection for $scenario"
    
    local feedback_file="$FEEDBACK_DIR/manual/feedback-$scenario-$TIMESTAMP.md"
    
    # Initialize feedback file
    cat > "$feedback_file" << EOF
# User Experience Feedback - $scenario

**Date:** $(date)
**Scenario:** $scenario
**Tester:** $(git config user.name 2>/dev/null || echo "Unknown")

## Feedback Responses

EOF
    
    echo -e "${CYAN}Please provide feedback on your experience with the $scenario workflow:${NC}"
    echo ""
    
    # Collect structured feedback
    echo -e "${YELLOW}1. Overall Experience (1-5, where 5 is excellent):${NC}"
    read -p "Rating: " overall_rating
    echo "### Overall Experience: $overall_rating/5" >> "$feedback_file"
    echo "" >> "$feedback_file"
    
    echo -e "${YELLOW}2. Setup Process Clarity (1-5, where 5 is very clear):${NC}"
    read -p "Rating: " setup_clarity
    echo "### Setup Process Clarity: $setup_clarity/5" >> "$feedback_file"
    echo "" >> "$feedback_file"
    
    echo -e "${YELLOW}3. Error Messages Quality (1-5, where 5 is very helpful):${NC}"
    read -p "Rating: " error_quality
    echo "### Error Messages Quality: $error_quality/5" >> "$feedback_file"
    echo "" >> "$feedback_file"
    
    echo -e "${YELLOW}4. Time to Complete Setup (in minutes):${NC}"
    read -p "Minutes: " completion_time
    echo "### Completion Time: $completion_time minutes" >> "$feedback_file"
    echo "" >> "$feedback_file"
    
    echo -e "${YELLOW}5. Most Confusing Part (describe briefly):${NC}"
    read -p "Description: " confusing_part
    echo "### Most Confusing Part:" >> "$feedback_file"
    echo "$confusing_part" >> "$feedback_file"
    echo "" >> "$feedback_file"
    
    echo -e "${YELLOW}6. Most Helpful Part (describe briefly):${NC}"
    read -p "Description: " helpful_part
    echo "### Most Helpful Part:" >> "$feedback_file"
    echo "$helpful_part" >> "$feedback_file"
    echo "" >> "$feedback_file"
    
    echo -e "${YELLOW}7. Suggested Improvements (optional):${NC}"
    read -p "Suggestions: " improvements
    echo "### Suggested Improvements:" >> "$feedback_file"
    echo "$improvements" >> "$feedback_file"
    echo "" >> "$feedback_file"
    
    echo -e "${YELLOW}8. Would you recommend this course to others? (y/n):${NC}"
    read -p "Recommend: " recommend
    echo "### Recommendation: $recommend" >> "$feedback_file"
    echo "" >> "$feedback_file"
    
    # Additional open-ended feedback
    echo -e "${YELLOW}9. Any additional comments or observations:${NC}"
    echo "   (Press Enter twice when finished)"
    echo "### Additional Comments:" >> "$feedback_file"
    while IFS= read -r line; do
        if [[ -z "$line" ]]; then
            break
        fi
        echo "$line" >> "$feedback_file"
    done
    echo "" >> "$feedback_file"
    
    print_success "Interactive feedback collected: $feedback_file"
}

# Analyze feedback patterns
analyze_feedback_patterns() {
    print_header "Analyzing Feedback Patterns"
    
    local analysis_file="$FEEDBACK_DIR/analytics/pattern-analysis-$TIMESTAMP.md"
    
    cat > "$analysis_file" << EOF
# Feedback Pattern Analysis

**Generated:** $(date)
**Analysis Period:** Last 30 days

## Summary Statistics

EOF
    
    # Count feedback files
    local manual_count=$(find "$FEEDBACK_DIR/manual" -name "*.md" -mtime -30 2>/dev/null | wc -l || echo "0")
    local automated_count=$(find "$FEEDBACK_DIR/automated" -name "*.json" -mtime -30 2>/dev/null | wc -l || echo "0")
    
    echo "- Manual feedback entries: $manual_count" >> "$analysis_file"
    echo "- Automated metric collections: $automated_count" >> "$analysis_file"
    echo "" >> "$analysis_file"
    
    # Analyze ratings if manual feedback exists
    if [[ $manual_count -gt 0 ]]; then
        echo "## Rating Analysis" >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        # Extract ratings from feedback files
        local total_overall=0
        local count_overall=0
        
        for feedback in "$FEEDBACK_DIR/manual"/*.md; do
            if [[ -f "$feedback" ]]; then
                local rating=$(grep "Overall Experience:" "$feedback" | grep -o "[0-9]/5" | cut -d'/' -f1 || echo "0")
                if [[ "$rating" -gt 0 ]]; then
                    total_overall=$((total_overall + rating))
                    count_overall=$((count_overall + 1))
                fi
            fi
        done
        
        if [[ $count_overall -gt 0 ]]; then
            local avg_overall=$(echo "scale=1; $total_overall / $count_overall" | bc -l 2>/dev/null || echo "0")
            echo "- Average Overall Experience: $avg_overall/5" >> "$analysis_file"
        fi
        
        echo "" >> "$analysis_file"
    fi
    
    # Analyze common issues
    echo "## Common Issues" >> "$analysis_file"
    echo "" >> "$analysis_file"
    
    if [[ -d "$FEEDBACK_DIR/automated" ]]; then
        # Look for common error patterns
        local error_patterns=$(find "$FEEDBACK_DIR/automated" -name "*.json" -exec jq -r '.metrics.errors[]?' {} \; 2>/dev/null | sort | uniq -c | sort -nr | head -5)
        if [[ -n "$error_patterns" ]]; then
            echo "### Most Common Errors:" >> "$analysis_file"
            echo '```' >> "$analysis_file"
            echo "$error_patterns" >> "$analysis_file"
            echo '```' >> "$analysis_file"
        fi
    fi
    
    echo "" >> "$analysis_file"
    
    # Generate recommendations
    echo "## Recommendations" >> "$analysis_file"
    echo "" >> "$analysis_file"
    
    if [[ $manual_count -eq 0 ]]; then
        echo "- Collect more manual feedback to identify user experience issues" >> "$analysis_file"
    fi
    
    if [[ $automated_count -eq 0 ]]; then
        echo "- Set up automated metric collection for better insights" >> "$analysis_file"
    fi
    
    echo "- Review individual feedback files for specific improvement suggestions" >> "$analysis_file"
    echo "- Consider A/B testing for workflow improvements" >> "$analysis_file"
    echo "- Monitor setup completion times and optimize slow steps" >> "$analysis_file"
    
    print_success "Pattern analysis completed: $analysis_file"
}

# Generate improvement suggestions
generate_improvement_suggestions() {
    print_header "Generating Improvement Suggestions"
    
    local suggestions_file="$FEEDBACK_DIR/improvements/suggestions-$TIMESTAMP.md"
    
    cat > "$suggestions_file" << EOF
# Improvement Suggestions

**Generated:** $(date)
**Based on:** Recent feedback and testing data

## Priority Improvements

### High Priority
- [ ] Address most common error patterns
- [ ] Improve setup time if exceeding 5-minute goal
- [ ] Enhance error message clarity based on feedback
- [ ] Simplify most confusing workflow steps

### Medium Priority
- [ ] Add progress indicators for long-running operations
- [ ] Improve cross-platform compatibility
- [ ] Enhance documentation for identified pain points
- [ ] Add validation for common user mistakes

### Low Priority
- [ ] Optimize performance for faster completion
- [ ] Add optional advanced features
- [ ] Improve visual design of output messages
- [ ] Add more detailed success confirmations

## Implementation Notes

EOF
    
    # Add specific suggestions based on recent feedback
    if [[ -d "$FEEDBACK_DIR/manual" ]]; then
        echo "### Based on User Feedback:" >> "$suggestions_file"
        
        # Extract common improvement suggestions
        local suggestions=$(find "$FEEDBACK_DIR/manual" -name "*.md" -exec grep -A5 "Suggested Improvements:" {} \; | grep -v "Suggested Improvements:" | grep -v "^--$" | sort | uniq -c | sort -nr | head -5)
        
        if [[ -n "$suggestions" ]]; then
            echo '```' >> "$suggestions_file"
            echo "$suggestions" >> "$suggestions_file"
            echo '```' >> "$suggestions_file"
        else
            echo "- No specific suggestions found in recent feedback" >> "$suggestions_file"
        fi
    fi
    
    echo "" >> "$suggestions_file"
    echo "### Based on Automated Metrics:" >> "$suggestions_file"
    
    if [[ -d "$FEEDBACK_DIR/automated" ]]; then
        # Check for performance issues
        local slow_setups=$(find "$FEEDBACK_DIR/automated" -name "*.json" -exec jq -r 'select(.metrics.performance.setup_duration_seconds > 300) | .scenario' {} \; 2>/dev/null | wc -l)
        
        if [[ $slow_setups -gt 0 ]]; then
            echo "- Optimize setup process (detected $slow_setups slow completions)" >> "$suggestions_file"
        fi
        
        # Check for build failures
        local build_failures=$(find "$FEEDBACK_DIR/automated" -name "*.json" -exec jq -r 'select(.metrics.success_indicators | index("build_successful") | not) | .scenario' {} \; 2>/dev/null | wc -l)
        
        if [[ $build_failures -gt 0 ]]; then
            echo "- Improve build process reliability (detected $build_failures failures)" >> "$suggestions_file"
        fi
    else
        echo "- Set up automated metrics collection for data-driven improvements" >> "$suggestions_file"
    fi
    
    print_success "Improvement suggestions generated: $suggestions_file"
}

# Export feedback data
export_feedback_data() {
    print_header "Exporting Feedback Data"
    
    local export_file="$FEEDBACK_DIR/analytics/feedback-export-$TIMESTAMP.json"
    
    # Create comprehensive export
    cat > "$export_file" << EOF
{
  "export_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "summary": {
    "manual_feedback_count": $(find "$FEEDBACK_DIR/manual" -name "*.md" 2>/dev/null | wc -l || echo "0"),
    "automated_metrics_count": $(find "$FEEDBACK_DIR/automated" -name "*.json" 2>/dev/null | wc -l || echo "0"),
    "improvement_suggestions_count": $(find "$FEEDBACK_DIR/improvements" -name "*.md" 2>/dev/null | wc -l || echo "0")
  },
  "recent_feedback": [],
  "metrics_summary": {},
  "common_issues": [],
  "improvement_priorities": []
}
EOF
    
    # Add recent feedback summaries
    if [[ -d "$FEEDBACK_DIR/manual" ]]; then
        local recent_feedback="["
        local first=true
        
        for feedback in "$FEEDBACK_DIR/manual"/*.md; do
            if [[ -f "$feedback" && ! "$first" == true ]]; then
                recent_feedback+=","
            fi
            first=false
            
            if [[ -f "$feedback" ]]; then
                local overall=$(grep "Overall Experience:" "$feedback" | grep -o "[0-9]/5" | cut -d'/' -f1 || echo "0")
                local scenario=$(basename "$feedback" | sed 's/feedback-\(.*\)-[0-9]*.md/\1/')
                
                recent_feedback+="{\"scenario\":\"$scenario\",\"overall_rating\":$overall,\"file\":\"$(basename "$feedback")\"}"
            fi
        done
        
        recent_feedback+="]"
        
        # Update export file
        echo "$recent_feedback" | jq '.' > /tmp/recent.json 2>/dev/null || echo "[]" > /tmp/recent.json
        jq --slurpfile recent /tmp/recent.json '.recent_feedback = $recent[0]' "$export_file" > tmp.json && mv tmp.json "$export_file"
        rm -f /tmp/recent.json
    fi
    
    print_success "Feedback data exported: $export_file"
}

# Main function
main() {
    local scenario=""
    local test_workspace=""
    local mode="interactive"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --scenario)
                scenario="$2"
                shift 2
                ;;
            --workspace)
                test_workspace="$2"
                shift 2
                ;;
            --automated)
                mode="automated"
                shift
                ;;
            --interactive)
                mode="interactive"
                shift
                ;;
            --analyze)
                mode="analyze"
                shift
                ;;
            --export)
                mode="export"
                shift
                ;;
            -h|--help)
                echo "ARM Assembly Course Feedback Collector"
                echo ""
                echo "Usage: $0 [options]"
                echo ""
                echo "Options:"
                echo "  --scenario NAME       Specify test scenario"
                echo "  --workspace PATH      Test workspace path"
                echo "  --automated          Collect automated metrics only"
                echo "  --interactive        Collect interactive feedback (default)"
                echo "  --analyze            Analyze existing feedback patterns"
                echo "  --export             Export feedback data"
                echo "  -h, --help           Show this help"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Initialize feedback collection
    init_feedback_collection
    
    # Execute based on mode
    case "$mode" in
        "automated")
            if [[ -n "$scenario" ]]; then
                collect_automated_metrics "$scenario" "$test_workspace"
            else
                echo "Error: --scenario required for automated mode"
                exit 1
            fi
            ;;
        "interactive")
            if [[ -n "$scenario" ]]; then
                collect_interactive_feedback "$scenario"
            else
                echo "Error: --scenario required for interactive mode"
                exit 1
            fi
            ;;
        "analyze")
            analyze_feedback_patterns
            generate_improvement_suggestions
            ;;
        "export")
            export_feedback_data
            ;;
        *)
            echo "Error: Unknown mode: $mode"
            exit 1
            ;;
    esac
    
    print_success "Feedback collection completed"
}

# Run main function
main "$@"

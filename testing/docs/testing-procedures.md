# ARM Assembly Course - Testing Procedures

This document provides comprehensive procedures for testing student workflow scripts safely without affecting the master branch.

## Quick Start Guide

### 1. Initial Setup (One-time)

```bash
# Create testing branch
git checkout master
git checkout -b testing/workflow-validation

# Initialize testing infrastructure
./testing/scripts/setup-test-env.sh --init

# Verify setup
./testing/scripts/test-runner.sh --help
```

### 2. Run Basic Tests

```bash
# Test fresh student workflow
./testing/scripts/workflow-tester.sh --scenario fresh-student

# Test all workflows
./testing/scripts/workflow-tester.sh --all

# Interactive testing with feedback
./testing/scripts/workflow-tester.sh --all --interactive
```

### 3. Review Results

```bash
# Check test reports
ls testing/reports/automated/
ls testing/reports/manual/

# Analyze feedback patterns
./testing/tools/feedback-collector.sh --analyze
```

## Detailed Testing Procedures

### Pre-Testing Checklist

- [ ] Ensure you're NOT on master/main branch
- [ ] Testing infrastructure is initialized
- [ ] Docker is running (for cross-platform tests)
- [ ] Git configuration is set up
- [ ] No uncommitted changes in working directory

### Testing Scenarios

#### 1. Fresh Student Experience Testing

**Purpose:** Validate the complete new student onboarding process

```bash
# Run fresh student test
./testing/scripts/workflow-tester.sh --scenario fresh-student --interactive

# What it tests:
# - setup.sh execution and timing
# - Toolchain installation simulation
# - Git workflow configuration
# - Build script creation
# - User experience and clarity
```

**Expected Outcomes:**
- Setup completes within 5 minutes
- build.sh is created and executable
- Git upstream is configured
- Clear next steps are provided
- No confusing error messages

#### 2. Build Workflow Testing

**Purpose:** Validate build script functionality and error handling

```bash
# Test build workflow
./testing/scripts/workflow-tester.sh --scenario build-workflow

# What it tests:
# - build.sh functionality
# - Cross-platform toolchain detection
# - Error handling for missing tools
# - Assembly file compilation
# - Output clarity and helpfulness
```

**Expected Outcomes:**
- Build script detects available toolchains
- Provides helpful error messages when tools missing
- Successfully builds valid assembly files
- Clear instructions for running programs

#### 3. Update Workflow Testing

**Purpose:** Validate course update process and student work preservation

```bash
# Test update workflow
./testing/scripts/workflow-tester.sh --scenario update-workflow

# What it tests:
# - update-course.sh execution
# - Student work preservation
# - Conflict resolution guidance
# - Git workflow integrity
# - Backup and recovery mechanisms
```

**Expected Outcomes:**
- Student work is preserved during updates
- Clear conflict resolution guidance
- No loss of personal files
- Proper Git branch management

### Cross-Platform Testing

#### Docker-Based Testing

```bash
# Set up Docker testing
cd testing/docker
docker-compose up -d

# Run cross-platform tests
./testing/scripts/test-runner.sh --docker --platforms ubuntu,fedora

# Test specific platform
docker run --rm -v $(pwd):/workspace arm-course-test:ubuntu \
  /workspace/testing/scripts/workflow-tester.sh --all
```

#### Manual Platform Testing

```bash
# Linux testing
./testing/scripts/workflow-tester.sh --all

# macOS testing (requires macOS system)
./testing/scripts/workflow-tester.sh --all --interactive

# Windows/WSL testing (requires WSL environment)
./testing/scripts/workflow-tester.sh --all
```

### Error Condition Testing

#### Simulate Missing Dependencies

```bash
# Test without ARM toolchain
PATH="/usr/bin:/bin" ./testing/scripts/workflow-tester.sh --scenario fresh-student

# Test without Git
# (Temporarily rename git binary and test)

# Test with network issues
# (Use network simulation tools)
```

#### Simulate User Errors

```bash
# Test with invalid assembly files
echo "invalid assembly" > test-invalid.s
./build.sh test-invalid.s

# Test with permission issues
chmod 000 modules/
./testing/scripts/workflow-tester.sh --scenario fresh-student
chmod 755 modules/
```

### Performance Testing

#### Timing Analysis

```bash
# Time the complete workflow
time ./testing/scripts/workflow-tester.sh --all

# Detailed performance analysis
./testing/tools/feedback-collector.sh --automated --scenario fresh-student
```

#### Resource Usage

```bash
# Monitor resource usage during testing
top -p $(pgrep -f workflow-tester) &
./testing/scripts/workflow-tester.sh --all
```

### Feedback Collection Procedures

#### Automated Feedback

```bash
# Collect automated metrics
./testing/tools/feedback-collector.sh --automated --scenario fresh-student --workspace /tmp/test-workspace

# Analyze patterns
./testing/tools/feedback-collector.sh --analyze

# Export data
./testing/tools/feedback-collector.sh --export
```

#### Manual Feedback

```bash
# Interactive feedback collection
./testing/tools/feedback-collector.sh --interactive --scenario fresh-student

# Review feedback files
cat testing/reports/manual/feedback-*.md
```

### Continuous Integration Testing

#### GitHub Actions

The CI pipeline automatically runs when:
- Pushing to testing/* branches
- Creating pull requests to master
- Manual workflow dispatch

```bash
# Trigger manual CI run
gh workflow run student-workflow-testing.yml

# Check CI status
gh run list --workflow=student-workflow-testing.yml
```

#### Local CI Simulation

```bash
# Simulate CI environment locally
act -j test-workflow-matrix

# Run specific CI job
act -j test-docker-platforms
```

## Safety Procedures

### Branch Protection

```bash
# Verify current branch before testing
current_branch=$(git branch --show-current)
if [[ "$current_branch" == "master" || "$current_branch" == "main" ]]; then
    echo "ERROR: Cannot test on master branch"
    exit 1
fi
```

### Cleanup Procedures

```bash
# Clean up test artifacts
find . -name "*.test.*" -delete
find . -name "test-*" -type d -exec rm -rf {} +

# Reset repository state
git checkout -- .
git clean -fd

# Remove test branches
git branch -D testing/session-*
```

### Backup and Recovery

```bash
# Create backup before major testing
git tag testing-backup-$(date +%Y%m%d-%H%M%S)

# Restore from backup if needed
git reset --hard testing-backup-YYYYMMDD-HHMMSS
```

## Troubleshooting

### Common Issues

#### "Cannot run tests on master branch"
```bash
# Solution: Create testing branch
git checkout -b testing/workflow-validation
```

#### "Testing infrastructure not found"
```bash
# Solution: Initialize testing environment
./testing/scripts/setup-test-env.sh --init
```

#### "Docker daemon not running"
```bash
# Solution: Start Docker
sudo systemctl start docker  # Linux
open -a Docker              # macOS
```

#### "Permission denied" errors
```bash
# Solution: Fix script permissions
chmod +x testing/scripts/*.sh
chmod +x testing/tools/*.sh
```

### Debug Mode

```bash
# Enable debug output
export DEBUG=1
./testing/scripts/workflow-tester.sh --all

# Verbose logging
./testing/scripts/workflow-tester.sh --all --verbose
```

### Log Analysis

```bash
# View recent test logs
tail -f testing/reports/automated/test-run-*.log

# Search for errors
grep -r "ERROR" testing/reports/

# Analyze failure patterns
grep -r "FAILED" testing/reports/ | sort | uniq -c
```

## Best Practices

### Before Testing

1. **Always use testing branches** - Never test on master
2. **Clean working directory** - Commit or stash changes
3. **Update testing infrastructure** - Keep tools current
4. **Document test objectives** - Know what you're testing

### During Testing

1. **Monitor resource usage** - Watch for memory/disk issues
2. **Capture detailed logs** - Enable verbose output
3. **Test edge cases** - Don't just test happy paths
4. **Collect feedback** - Both automated and manual

### After Testing

1. **Clean up artifacts** - Remove temporary files
2. **Document findings** - Record issues and improvements
3. **Update procedures** - Improve testing based on learnings
4. **Share results** - Communicate findings to team

### Continuous Improvement

1. **Regular testing** - Test frequently, not just before releases
2. **Feedback analysis** - Look for patterns in user feedback
3. **Process refinement** - Continuously improve testing procedures
4. **Tool updates** - Keep testing tools and infrastructure current

## Integration with Development Workflow

### Pre-Commit Testing

```bash
# Add to .git/hooks/pre-commit
#!/bin/bash
if [[ "$(git branch --show-current)" == testing/* ]]; then
    ./testing/scripts/test-runner.sh --quick
fi
```

### Release Validation

```bash
# Before releasing new version
git checkout -b release/validation-$(date +%Y%m%d)
./testing/scripts/workflow-tester.sh --all --comprehensive
./testing/tools/feedback-collector.sh --analyze
```

### Improvement Implementation

```bash
# After identifying improvements
git checkout master
git checkout -b improvement/setup-timeout-fix
# Implement improvements
# Test improvements
./testing/scripts/workflow-tester.sh --scenario fresh-student
# Create pull request
```

This comprehensive testing framework ensures that student workflow scripts can be thoroughly validated without affecting the production codebase, while providing detailed feedback for continuous improvement.

# Testing Branch Strategy

This document outlines the branch strategy for safely testing student workflow scripts without affecting the master branch.

## Branch Hierarchy

```
master (production)
├── testing/workflow-validation (main testing branch)
├── testing/setup-improvements (setup script testing)
├── testing/build-validation (build script testing)
├── testing/update-workflow (update script testing)
├── testing/cross-platform (platform compatibility)
└── testing/user-experience (UX testing)
```

## Branch Purposes

### `testing/workflow-validation`
- **Purpose**: Main testing branch for comprehensive workflow validation
- **Lifetime**: Persistent (not deleted)
- **Usage**: Base branch for all testing activities
- **Merging**: Never merged back to master (testing only)

### `testing/setup-improvements`
- **Purpose**: Testing improvements to setup.sh and related scripts
- **Lifetime**: Temporary (deleted after testing cycle)
- **Usage**: Iterate on setup script improvements
- **Merging**: Changes cherry-picked to master after validation

### `testing/build-validation`
- **Purpose**: Testing build.sh functionality and cross-platform compatibility
- **Lifetime**: Temporary
- **Usage**: Validate build script changes
- **Merging**: Improvements merged to master via PR

### `testing/update-workflow`
- **Purpose**: Testing update-course.sh and Git workflow functionality
- **Lifetime**: Temporary
- **Usage**: Validate update mechanisms and conflict resolution
- **Merging**: Fixes merged to master after validation

### `testing/cross-platform`
- **Purpose**: Platform-specific testing (Linux, macOS, Windows/WSL)
- **Lifetime**: Temporary
- **Usage**: Validate cross-platform compatibility
- **Merging**: Platform fixes merged to master

### `testing/user-experience`
- **Purpose**: UX testing and student onboarding validation
- **Lifetime**: Temporary
- **Usage**: Gather feedback and test user experience
- **Merging**: UX improvements merged to master

## Branch Management Procedures

### Creating Testing Branches

```bash
# Create main testing branch (one-time setup)
git checkout master
git checkout -b testing/workflow-validation
git push -u origin testing/workflow-validation

# Create specific testing branches
git checkout testing/workflow-validation
git checkout -b testing/setup-improvements
```

### Testing Workflow

1. **Start Testing Session**
   ```bash
   git checkout testing/workflow-validation
   git pull origin master  # Sync with latest master
   git checkout -b testing/session-$(date +%Y%m%d-%H%M%S)
   ```

2. **Run Tests**
   ```bash
   ./testing/scripts/test-runner.sh --all
   ```

3. **Capture Improvements**
   ```bash
   # Document findings
   echo "Improvement: Fix setup.sh timeout issue" >> testing/reports/improvements/session-notes.md
   
   # Create improvement branch
   git checkout master
   git checkout -b improvement/setup-timeout-fix
   # Make actual improvements to master-bound code
   ```

4. **Clean Up Testing Session**
   ```bash
   git checkout testing/workflow-validation
   git branch -D testing/session-*
   ```

### Safety Mechanisms

#### Pre-Testing Checks
```bash
#!/bin/bash
# Ensure we're not on master
current_branch=$(git branch --show-current)
if [[ "$current_branch" == "master" || "$current_branch" == "main" ]]; then
    echo "Error: Cannot test on master branch"
    exit 1
fi

# Ensure clean working directory
if ! git diff-index --quiet HEAD --; then
    echo "Warning: Uncommitted changes detected"
fi
```

#### Post-Testing Cleanup
```bash
#!/bin/bash
# Remove test artifacts
find . -name "*.test.*" -delete
find . -name "test-*" -type d -exec rm -rf {} +

# Reset any modified files
git checkout -- .

# Clean untracked files
git clean -fd
```

## Testing Procedures

### 1. Fresh Student Workflow Testing

```bash
# Create isolated testing environment
git checkout testing/workflow-validation
./testing/scripts/setup-test-env.sh --init

# Run fresh student tests
./testing/scripts/test-runner.sh fresh-student

# Capture feedback
./testing/tools/feedback-collector.sh --scenario fresh-student
```

### 2. Update Workflow Testing

```bash
# Simulate existing student work
git checkout testing/workflow-validation
mkdir -p modules/m1/student-work
echo "# Student notes" > modules/m1/student-work/notes.md
git add modules/m1/student-work/notes.md
git commit -m "Simulate student work"

# Test update workflow
./testing/scripts/test-runner.sh update-workflow
```

### 3. Cross-Platform Testing

```bash
# Docker-based cross-platform testing
./testing/scripts/test-runner.sh --docker --platforms linux,fedora

# Manual platform testing
./testing/scripts/test-runner.sh --interactive --platform macos
```

### 4. Error Condition Testing

```bash
# Test error handling
./testing/scripts/test-runner.sh error-conditions

# Test with missing dependencies
docker run --rm -v $(pwd):/workspace arm-course-test:minimal \
  /workspace/testing/scripts/test-runner.sh fresh-student
```

## Feedback Collection

### Automated Feedback
- Test execution logs
- Performance metrics
- Error patterns
- Success/failure rates

### Manual Feedback
- User experience observations
- Pain points in workflow
- Improvement suggestions
- Documentation gaps

### Feedback Storage
```
testing/reports/
├── automated/
│   ├── test-run-YYYYMMDD-HHMMSS.log
│   ├── performance-metrics.json
│   └── error-analysis.md
├── manual/
│   ├── ux-feedback-YYYYMMDD.md
│   ├── pain-points.md
│   └── improvement-suggestions.md
└── improvements/
    ├── implemented/
    ├── pending/
    └── rejected/
```

## Integration with Development Workflow

### Pre-Commit Testing
```bash
# Git hook for testing before commits
#!/bin/bash
if [[ "$(git branch --show-current)" == testing/* ]]; then
    ./testing/scripts/test-runner.sh --quick
fi
```

### Continuous Integration
```yaml
# .github/workflows/testing.yml
name: Student Workflow Testing
on:
  push:
    branches: [ testing/* ]
  pull_request:
    branches: [ master ]

jobs:
  test-workflows:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup testing environment
        run: ./testing/scripts/setup-test-env.sh --init
      - name: Run workflow tests
        run: ./testing/scripts/test-runner.sh --all
```

### Release Validation
```bash
# Before releasing new course content
git checkout master
git checkout -b release/validation-$(date +%Y%m%d)

# Run comprehensive tests
./testing/scripts/test-runner.sh --all --comprehensive

# Validate with real student simulation
./testing/scripts/test-runner.sh --interactive --student-simulation
```

## Best Practices

1. **Never merge testing branches to master**
2. **Always test in isolated environments**
3. **Document all findings and improvements**
4. **Clean up test artifacts after each session**
5. **Use descriptive branch names with timestamps**
6. **Capture both positive and negative feedback**
7. **Test edge cases and error conditions**
8. **Validate cross-platform compatibility**
9. **Simulate real student experience**
10. **Maintain separation between testing and production code**

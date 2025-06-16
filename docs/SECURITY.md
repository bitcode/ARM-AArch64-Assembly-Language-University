# Security Policy

## Overview

The ARM Assembly Language University is an educational repository focused on teaching ARM assembly programming. While this is primarily an educational project, we take security seriously to ensure a safe learning environment for all students and contributors.

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| Previous| :white_check_mark: |
| Older   | :x:                |

## Educational Context

This repository contains:
- Educational assembly code examples
- Learning exercises and projects
- Course materials and documentation
- Build scripts and development tools

**Important Note**: The code in this repository is designed for educational purposes. Some examples may intentionally demonstrate vulnerabilities or unsafe practices as learning tools. Always review code carefully and understand the educational context before use.

## Reporting Security Vulnerabilities

### What to Report

Please report security vulnerabilities if you discover:

1. **Code Vulnerabilities**: Security issues in example code that could mislead students
2. **Infrastructure Issues**: Problems with build scripts, CI/CD, or repository configuration
3. **Dependency Vulnerabilities**: Security issues in project dependencies
4. **Educational Content**: Misleading security information that could teach bad practices
5. **Privacy Issues**: Exposure of sensitive information in course materials

### What NOT to Report

The following are **not** security vulnerabilities in this context:
- Intentionally vulnerable code used for educational demonstration
- Assembly code that lacks modern security features (when used for basic instruction)
- Simple buffer overflows in beginner exercises (unless they pose actual risk)
- Code that would be insecure in production but is appropriate for learning

### How to Report

**For security vulnerabilities, please do NOT create public issues.**

Instead, please report security vulnerabilities by:

1. **Email**: Send details to [security@arm-assembly-university.edu] (if available)
2. **GitHub Security Advisory**: Use GitHub's private vulnerability reporting feature
3. **Direct Contact**: Contact repository maintainers directly through GitHub

### Information to Include

When reporting a security vulnerability, please include:

- **Description**: Clear description of the vulnerability
- **Location**: File path and line numbers where the issue exists
- **Impact**: Potential impact on students, contributors, or systems
- **Educational Context**: Whether this affects learning objectives
- **Reproduction**: Steps to reproduce the issue
- **Suggested Fix**: If you have ideas for remediation

### Example Report Template

```
Subject: Security Vulnerability in [Module/File]

Description:
[Clear description of the vulnerability]

Location:
File: modules/m4-memory-data-structures/exercises/buffer-example.s
Lines: 45-52

Impact:
[Describe potential impact]

Educational Context:
[Is this intentional for teaching? Does it mislead students?]

Reproduction Steps:
1. Compile the example with: gcc -o example buffer-example.s
2. Run with input: ./example "AAAA..."
3. Observe: [what happens]

Suggested Fix:
[Your suggestions for fixing the issue]
```

## Response Timeline

We aim to respond to security reports according to the following timeline:

- **Initial Response**: Within 48 hours
- **Assessment**: Within 1 week
- **Fix Development**: Within 2 weeks (depending on complexity)
- **Public Disclosure**: After fix is deployed and verified

## Security Best Practices for Contributors

### Code Contributions

When contributing code to this repository:

1. **Review Educational Context**: Ensure vulnerable code is clearly marked as educational
2. **Add Security Comments**: Explain security implications in comments
3. **Avoid Real Secrets**: Never include real passwords, keys, or sensitive data
4. **Test Safely**: Test code in isolated environments
5. **Document Risks**: Clearly document any security risks in exercises

### Educational Content

When creating educational content:

1. **Clear Warnings**: Mark intentionally vulnerable code with clear warnings
2. **Explain Implications**: Discuss security implications of demonstrated techniques
3. **Provide Context**: Explain when techniques should/shouldn't be used
4. **Safe Examples**: Use placeholder data, not real sensitive information
5. **Modern Practices**: When teaching security, include modern best practices

### Example Security Warning

```assembly
; WARNING: EDUCATIONAL EXAMPLE - INTENTIONALLY VULNERABLE
; This code demonstrates a buffer overflow vulnerability
; DO NOT use this pattern in production code
; Learning objective: Understanding memory safety issues

.section .data
    buffer: .space 10    ; Small buffer - vulnerable to overflow
    
.section .text
; This function intentionally lacks bounds checking
; Students should identify the vulnerability and propose fixes
```

## Dependency Security

We regularly monitor and update dependencies to address security vulnerabilities:

- **Automated Scanning**: GitHub Dependabot monitors for vulnerable dependencies
- **Regular Updates**: Dependencies are updated quarterly or when vulnerabilities are discovered
- **Educational Tools**: Only trusted, well-maintained tools are used in the course

## Infrastructure Security

Our repository infrastructure includes:

- **Branch Protection**: Main branch requires review before merging
- **CI/CD Security**: Build processes run in isolated environments
- **Access Control**: Limited write access to maintain code quality
- **Audit Logging**: All changes are tracked and auditable

## Educational Disclaimer

**Important**: This repository contains educational materials that may include:

- Intentionally vulnerable code for learning purposes
- Assembly techniques that require careful handling
- Examples that demonstrate security concepts through controlled vulnerabilities
- Historical or deprecated practices for educational comparison

Always understand the educational context and never use educational examples in production systems without proper security review.

## Questions and Clarifications

If you have questions about:
- Whether something constitutes a security vulnerability
- The educational context of specific code
- Security best practices for assembly programming
- How to safely practice the techniques taught in this course

Please feel free to:
- Open a public discussion for general security questions
- Contact maintainers for clarification on specific issues
- Refer to the course materials for security guidance

## Acknowledgments

We appreciate the security research community and all contributors who help keep this educational resource safe and valuable for learning.

---

**Remember**: The goal is to create a safe learning environment where students can explore assembly programming, including security concepts, without putting themselves or others at risk.

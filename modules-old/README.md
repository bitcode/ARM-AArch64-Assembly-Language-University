# Course Modules

This directory contains the 8 core modules of the ARM AArch64 Assembly Language University course. Each module builds upon previous knowledge and introduces new concepts progressively.

## Module Structure

Each module contains:
- **README.md**: Learning objectives, prerequisites, and module overview
- **exercises/**: Hands-on programming exercises with varying difficulty levels
- **resources/**: Module-specific reference materials and guides
- **examples/**: Sample code demonstrating key concepts

## Learning Path

### Foundation Phase (Weeks 1-3)
- **[M1: Foundation & Setup](m1-foundation/)** - Development environment, basic architecture
- **[M2: Data & Registers](m2-data-registers/)** - Register usage, data types, addressing

### Core Programming Phase (Weeks 4-7)
- **[M3: Control Flow](m3-control-flow/)** - Branching, loops, conditional execution
- **[M4: Functions & Stack](m4-functions-stack/)** - Calling conventions, stack management

### Advanced Concepts Phase (Weeks 8-10)
- **[M5: Memory & Pointers](m5-memory-pointers/)** - Memory models, data structures
- **[M6: System Integration](m6-system-integration/)** - System calls, OS interaction

### Mastery Phase (Weeks 11-12)
- **[M7: Optimization](m7-optimization/)** - Performance tuning, SIMD instructions
- **[M8: Applications](m8-applications/)** - Real-world projects, portfolio development

## Exercise Naming Convention

All exercises follow the pattern: `module-lesson.sublesson-topic-difficulty.s`

**Difficulty Levels:**
- `beginner` - Introduction to new concepts
- `intermediate` - Applying concepts with moderate complexity
- `advanced` - Complex implementations and optimizations
- `expert` - Research-level challenges and open-ended problems

**Examples:**
- `1.1-hello-beginner.s` - First assembly program
- `3.2-loops-intermediate.s` - Loop implementation practice
- `7.1-simd-advanced.s` - SIMD optimization techniques

## Module Dependencies

```
M1 (Foundation) → M2 (Data & Registers)
                     ↓
M3 (Control Flow) ← M4 (Functions & Stack)
        ↓               ↓
M5 (Memory & Pointers) → M6 (System Integration)
                     ↓
M7 (Optimization) → M8 (Applications)
```

## Getting Started

1. **Start with M1**: Ensure your development environment is properly configured
2. **Follow Sequential Order**: Each module builds on previous knowledge
3. **Complete All Exercises**: Practice is essential for assembly language mastery
4. **Use LLM Research Assistant**: Leverage AI guidance for understanding concepts
5. **Review ARM Manual**: Reference official documentation for detailed specifications

## Progress Tracking

- Complete module README review before starting exercises
- Finish all beginner and intermediate exercises before advancing
- Attempt advanced exercises for deeper understanding
- Use assessment tools to validate your progress

---

**Ready to begin?** Start with [Module 1: Foundation & Setup](m1-foundation/) to establish your development environment and write your first ARM assembly program.
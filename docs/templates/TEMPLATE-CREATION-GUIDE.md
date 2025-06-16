# Guided Exercise Template Creation Guide

This guide explains how to create guided exercise files using the template system for the ARM AArch64 Assembly Language University course.

## 🎯 Template Philosophy

The guided exercise templates balance **guidance** with **student self-reliance**:
- **Provide clear direction** without giving away solutions
- **Integrate DREAM methodology** for systematic learning
- **Scale guidance level** based on difficulty
- **Maintain educational value** of writing code from scratch

## 📁 Template Files

### Available Templates

1. **`guided-exercise-template.s`** - Master template with all placeholders
2. **`beginner-exercise-template.s`** - Extensive guidance for newcomers
3. **`intermediate-exercise-template.s`** - Moderate guidance for developing skills
4. **`advanced-exercise-template.s`** - Minimal guidance for complex challenges
5. **`expert-exercise-template.s`** - Research-level open-ended challenges

### Template Selection Guide

| Difficulty | Guidance Level | Target Audience | Time Investment |
|------------|----------------|-----------------|-----------------|
| **Beginner** | Extensive step-by-step | New to assembly | 30-45 minutes |
| **Intermediate** | Moderate direction | Some experience | 45-75 minutes |
| **Advanced** | Minimal hints | Experienced programmers | 90-120 minutes |
| **Expert** | Research-level | Advanced practitioners | 2-4 hours+ |

## 🔧 Template Customization Process

### Step 1: Choose Base Template

Select the appropriate template based on:
- **Target difficulty level**
- **Student experience expectations**
- **Learning objectives complexity**
- **Time investment requirements**

### Step 2: Replace Placeholders

All templates use bracketed placeholders that need customization:

#### Basic Information Placeholders
```
[MODULE] - Module number (e.g., "1", "2", "3")
[LESSON] - Lesson number (e.g., "1", "2", "3")
[TOPIC] - Descriptive topic name (e.g., "hello", "registers", "loops")
[DIFFICULTY] - Difficulty level (beginner|intermediate|advanced|expert)
[MODULE_NUMBER] - Full module number (e.g., "1", "2", "3")
[MODULE_NAME] - Full module name (e.g., "Foundation & Setup")
[MODULE_ID] - Module identifier (e.g., "m1-foundation")
[EXERCISE_TITLE] - Complete exercise title
[FILENAME] - Complete filename (e.g., "1.1-hello-beginner.s")
```

#### Content Placeholders
```
[OBJECTIVE_1/2/3] - Specific learning objectives
[SECTION_1/2/3] - ARM manual section references
[PREREQUISITE_1/2/3] - Required prior knowledge
[TIME_ESTIMATE] - Estimated completion time
[PROBLEM_DEFINITION] - Clear problem statement
[RESEARCH_GUIDANCE] - Research direction
[IMPLEMENTATION_STEP_1/2/3] - Implementation guidance
[ANALYSIS_QUESTION_1/2/3] - Analysis prompts
[MASTERY_TASK_1/2/3] - Mastery demonstration tasks
```

### Step 3: Customize DREAM Methodology

Each template includes DREAM methodology integration:

#### Define Phase
- **Problem Statement**: Clear, specific challenge description
- **Success Criteria**: Measurable outcomes
- **Constraints**: Technical or design limitations

#### Research Phase
- **ARM Manual Sections**: Specific references with page numbers
- **Key Concepts**: Core ideas to understand
- **Research Questions**: Guided investigation prompts

#### Experiment Phase
- **Implementation Steps**: Logical development sequence
- **Testing Checkpoints**: Validation points
- **Variation Suggestions**: Alternative approaches

#### Analyze Phase
- **Observation Points**: What to examine in results
- **Comparison Criteria**: How to evaluate solutions
- **Pattern Recognition**: Common behaviors to identify

#### Master Phase
- **Application Scenarios**: Real-world usage
- **Teaching Challenges**: Explanation tasks
- **Extension Ideas**: Ways to expand understanding

### Step 4: Adjust Guidance Level

Customize guidance based on difficulty:

#### Beginner Level Adjustments
- **Extensive step-by-step instructions**
- **Detailed explanations of concepts**
- **Specific code structure guidance**
- **Common mistake warnings**
- **Debugging tips**

#### Intermediate Level Adjustments
- **General implementation phases**
- **Key concept highlights**
- **Strategic considerations**
- **Performance awareness**
- **Design pattern suggestions**

#### Advanced Level Adjustments
- **Architectural considerations**
- **Optimization opportunities**
- **Complex trade-off discussions**
- **Performance analysis requirements**
- **Innovation challenges**

#### Expert Level Adjustments
- **Open-ended research questions**
- **Literature review requirements**
- **Novel contribution expectations**
- **Rigorous validation standards**
- **Knowledge sharing opportunities**

## 📋 Template Validation Checklist

### Content Validation
- [ ] All placeholders replaced with specific content
- [ ] Learning objectives are specific and measurable
- [ ] ARM manual references are accurate and relevant
- [ ] Prerequisites match the difficulty level
- [ ] DREAM methodology is properly integrated

### Educational Validation
- [ ] Guidance level matches target difficulty
- [ ] No boilerplate code provided
- [ ] Students must write all implementation
- [ ] Clear progression from previous exercises
- [ ] Appropriate challenge level for target audience

### Technical Validation
- [ ] YAML metadata is properly formatted
- [ ] File naming follows convention
- [ ] ARM assembly syntax is correct
- [ ] Build and test instructions are accurate
- [ ] Expected outputs are clearly defined

### Quality Validation
- [ ] Instructions are clear and unambiguous
- [ ] Hints provide direction without solutions
- [ ] Research prompts encourage deep learning
- [ ] Analysis questions promote understanding
- [ ] Mastery tasks demonstrate competence

## 🎚️ Difficulty Level Guidelines

### Beginner Exercises
**Characteristics:**
- Introduction to new concepts
- Extensive guidance and explanation
- Step-by-step implementation
- Clear expected outcomes
- Comprehensive debugging support

**Example Topics:**
- First assembly program
- Basic instruction usage
- Simple data manipulation
- Elementary control flow

### Intermediate Exercises
**Characteristics:**
- Application of learned concepts
- Moderate guidance with key hints
- Problem-solving requirements
- Performance considerations
- Integration of multiple concepts

**Example Topics:**
- Function implementation
- Data structure manipulation
- Algorithm implementation
- Optimization techniques

### Advanced Exercises
**Characteristics:**
- Complex problem solving
- Minimal guidance
- Performance optimization
- System-level considerations
- Integration challenges

**Example Topics:**
- Advanced algorithms
- System programming
- Performance optimization
- Complex data structures

### Expert Exercises
**Characteristics:**
- Research-level challenges
- Open-ended problems
- Innovation requirements
- Literature review needs
- Original contribution potential

**Example Topics:**
- Novel algorithm development
- Performance research
- System optimization
- Cutting-edge techniques

## 🔄 Template Maintenance

### Version Control
- Track template changes in Git
- Document template evolution
- Maintain backward compatibility
- Update based on student feedback

### Continuous Improvement
- Collect student feedback on guidance effectiveness
- Monitor completion rates and difficulty
- Update based on ARM architecture changes
- Incorporate new educational research

### Quality Assurance
- Regular template review cycles
- Student testing of new templates
- Instructor validation of content
- Automated validation where possible

## 📚 Best Practices

### Content Creation
1. **Start with learning objectives** - Define what students should achieve
2. **Research ARM manual thoroughly** - Ensure accurate technical content
3. **Test the exercise yourself** - Validate feasibility and timing
4. **Review with peers** - Get feedback on clarity and difficulty
5. **Iterate based on feedback** - Continuously improve based on usage

### Guidance Balance
1. **Provide direction, not solutions** - Guide thinking without giving answers
2. **Scale guidance to difficulty** - More help for beginners, less for experts
3. **Encourage exploration** - Promote discovery and experimentation
4. **Support debugging** - Help students when they get stuck
5. **Celebrate learning** - Acknowledge progress and achievement

### Educational Effectiveness
1. **Connect to real-world applications** - Show practical relevance
2. **Build on previous knowledge** - Create logical progression
3. **Encourage deep learning** - Promote understanding over memorization
4. **Support different learning styles** - Provide multiple approaches
5. **Foster independence** - Gradually reduce guidance over time

## 🚀 Quick Start Guide

### Creating a New Exercise

1. **Choose template**: Select based on difficulty level
2. **Copy template**: `cp templates/[DIFFICULTY]-exercise-template.s modules/[MODULE]/exercises/[FILENAME].s`
3. **Replace placeholders**: Use find-and-replace for bracketed placeholders
4. **Customize content**: Adapt DREAM methodology and guidance
5. **Validate**: Check against validation checklist
6. **Test**: Verify exercise works as intended

### Example: Creating a Beginner Exercise

```bash
# Copy template
cp templates/beginner-exercise-template.s modules/m1-foundation/exercises/1.1-hello-beginner.s

# Edit the file and replace:
[MODULE] → 1
[LESSON] → 1
[TOPIC] → hello
[DIFFICULTY] → beginner
[MODULE_NAME] → Foundation & Setup
[EXERCISE_TITLE] → Hello World - Your First Assembly Program
# ... and so on
```

### Template Placeholder Quick Reference

| Placeholder | Example | Description |
|-------------|---------|-------------|
| `[MODULE]` | `1` | Module number |
| `[LESSON]` | `1` | Lesson number |
| `[TOPIC]` | `hello` | Topic name |
| `[DIFFICULTY]` | `beginner` | Difficulty level |
| `[MODULE_NAME]` | `Foundation & Setup` | Full module name |
| `[EXERCISE_TITLE]` | `Hello World Program` | Complete title |
| `[TIME_ESTIMATE]` | `30-45 minutes` | Expected duration |

---

This template system provides the foundation for creating effective guided exercises that maintain student self-reliance while providing appropriate support for learning ARM assembly language.

# Guided Exercise Templates

This directory contains the template system for creating guided exercise files that balance student self-reliance with appropriate learning support.

## 🎯 Template Philosophy

The guided exercise templates implement the course's educational philosophy:
- **Comment-based guidance** with clear objectives and steps
- **No boilerplate code** - students write all implementation from scratch
- **DREAM methodology integration** for systematic learning
- **Progressive difficulty scaling** from beginner to expert
- **ARM manual integration** for deep understanding

## 📁 Available Templates

### Core Templates

| Template | Difficulty | Guidance Level | Target Audience |
|----------|------------|----------------|-----------------|
| `guided-exercise-template.s` | Generic | Customizable | Template creators |
| `beginner-exercise-template.s` | Beginner | Extensive | New to assembly |
| `intermediate-exercise-template.s` | Intermediate | Moderate | Some experience |
| `advanced-exercise-template.s` | Advanced | Minimal | Experienced |
| `expert-exercise-template.s` | Expert | Research-level | Advanced practitioners |

### Documentation

| File | Purpose |
|------|---------|
| `TEMPLATE-CREATION-GUIDE.md` | Comprehensive guide for creating exercises |
| `README.md` | This overview document |

## 🚀 Quick Start

### Creating a New Exercise

1. **Choose appropriate template** based on target difficulty
2. **Copy to exercise directory**:
   ```bash
   cp templates/beginner-exercise-template.s modules/m1-foundation/exercises/1.1-hello-beginner.s
   ```
3. **Replace placeholders** with specific content
4. **Customize DREAM methodology** sections
5. **Validate against checklist**

### Key Placeholders to Replace

```
[MODULE] - Module number (1, 2, 3, etc.)
[LESSON] - Lesson number (1, 2, 3, etc.)
[TOPIC] - Topic name (hello, registers, loops, etc.)
[DIFFICULTY] - beginner|intermediate|advanced|expert
[MODULE_NAME] - Full module name
[EXERCISE_TITLE] - Complete exercise title
[OBJECTIVE_1/2/3] - Specific learning objectives
[SECTION_1/2/3] - ARM manual references
```

## 🎚️ Difficulty Level Guide

### 🟢 Beginner
- **Extensive step-by-step guidance**
- **Detailed concept explanations**
- **Common mistake warnings**
- **Comprehensive debugging support**
- **30-45 minute exercises**

### 🟡 Intermediate
- **Moderate guidance with key hints**
- **Strategic implementation phases**
- **Performance considerations**
- **Design pattern awareness**
- **45-75 minute exercises**

### 🟠 Advanced
- **Minimal guidance, focus on objectives**
- **Complex optimization challenges**
- **Architectural considerations**
- **Performance analysis requirements**
- **90-120 minute exercises**

### 🔴 Expert
- **Open-ended research challenges**
- **Literature review requirements**
- **Novel contribution expectations**
- **Knowledge sharing opportunities**
- **2-4 hour projects**

## 🧠 DREAM Methodology Integration

All templates integrate the DREAM methodology:

### 🎯 Define
- Clear problem statements
- Success criteria
- Constraints and requirements

### 🔍 Research
- ARM manual section references
- Key concepts to understand
- Research questions and prompts

### ⚡ Experiment
- Implementation phases
- Testing checkpoints
- Variation suggestions

### 📊 Analyze
- Observation points
- Comparison criteria
- Pattern recognition tasks

### 🎓 Master
- Application scenarios
- Teaching challenges
- Extension opportunities

## 📋 Template Features

### Educational Structure
- **Learning objectives** clearly stated
- **Prerequisites** explicitly listed
- **ARM manual integration** with specific references
- **Progressive guidance** scaled to difficulty
- **Assessment criteria** for self-evaluation

### YAML Metadata
- **Structured information** for automated processing
- **Learning objective tracking**
- **Progress monitoring support**
- **Tool integration compatibility**

### Student Workflow Support
- **Copy-to-workspace instructions**
- **Build and test commands**
- **Expected output descriptions**
- **Debugging guidance**

### Comment-Based Guidance
- **No boilerplate code** provided
- **Clear implementation hints**
- **Conceptual explanations**
- **Common pitfall warnings**

## 🔧 Template Customization

### Content Adaptation
1. **Replace all bracketed placeholders**
2. **Customize DREAM methodology sections**
3. **Adjust guidance level for target audience**
4. **Add specific ARM manual references**
5. **Include relevant prerequisites**

### Quality Assurance
- [ ] All placeholders replaced
- [ ] Learning objectives are specific and measurable
- [ ] ARM manual references are accurate
- [ ] Guidance level matches difficulty
- [ ] No solutions provided in comments
- [ ] YAML metadata is properly formatted

## 🎯 Educational Benefits

### For Students
- **Clear direction** without solution spoilers
- **Systematic learning** through DREAM methodology
- **Self-reliance** through independent implementation
- **Deep understanding** via ARM manual integration
- **Progressive skill development** across difficulty levels

### For Instructors
- **Consistent structure** across all exercises
- **Easy content creation** with template system
- **Scalable difficulty** for diverse student needs
- **Automated validation** through metadata
- **Efficient updates** without affecting student work

## 🔄 Template Maintenance

### Version Control
- Templates are tracked in Git
- Changes documented in commit messages
- Backward compatibility maintained
- Student feedback incorporated

### Continuous Improvement
- Regular review cycles
- Student completion data analysis
- Instructor feedback integration
- ARM architecture update incorporation

## 📚 Best Practices

### Content Creation
1. **Start with clear learning objectives**
2. **Research ARM manual thoroughly**
3. **Test exercise feasibility**
4. **Validate with peer review**
5. **Iterate based on feedback**

### Guidance Balance
1. **Provide direction, not solutions**
2. **Scale guidance to difficulty**
3. **Encourage exploration and discovery**
4. **Support debugging without solving**
5. **Celebrate learning progress**

## 🚀 Getting Started

1. **Read the Template Creation Guide** for comprehensive instructions
2. **Choose appropriate template** for your exercise
3. **Follow the customization process** step by step
4. **Validate your exercise** against the checklist
5. **Test with target audience** before deployment

---

These templates provide the foundation for creating effective guided exercises that maintain the educational value of student self-reliance while providing appropriate support for learning ARM assembly language.

# Documentation

This directory contains project documentation for developers and AI agents.

## 📚 Documentation Files

### **[TESTING_STANDARDS.md](./TESTING_STANDARDS.md)**
Comprehensive testing guidelines and patterns for consistent test development across the Flutter app.

- **Purpose**: Team's living documentation for testing standards
- **Usage**: Reference when writing new tests, code review guidelines
- **Contents**: Test structure, naming conventions, helper functions, best practices

### **[TEST_ANALYSIS_REPORT.md](./TEST_ANALYSIS_REPORT.md)**
Detailed analysis and roadmap for improving the test suite.

- **Purpose**: Specific roadmap for test refactoring efforts
- **Usage**: Implementation plan for test improvements
- **Contents**: Current issues, priority recommendations, success metrics

### **[AGENTS.md](./AGENTS.md)**
Guidelines for AI agents working on this Flutter/Dart codebase.

- **Purpose**: AI agent development guidelines
- **Usage**: Reference for AI-assisted development
- **Contents**: Build commands, code style, architecture patterns, testing

### **[ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md)**
Automated script documentation for creating new components.

- **Purpose**: Component creation workflow and script usage
- **Usage**: Scaffolding new components, demos, and tests
- **Contents**: Script usage, prompts, naming conventions, examples, troubleshooting

## 🚀 Quick Start

### For New Team Members
1. Read [AGENTS.md](./AGENTS.md) - Project overview and basic guidelines
2. Read [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) - How to write tests
3. Review [TEST_ANALYSIS_REPORT.md](./TEST_ANALYSIS_REPORT.md) - Current improvement efforts
4. See [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) - How to create new components

### For Adding Components
1. Run: `./scripts/add_component.sh`
2. Reference [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) for detailed instructions
3. Follow naming conventions and prompts provided by the script

### For Test Refactoring
1. Run analysis: `./scripts/analyze_tests.sh`
2. Reference [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) for patterns
3. Use [TEST_ANALYSIS_REPORT.md](./TEST_ANALYSIS_REPORT.md) for prioritization

### For AI Agents
1. Start with [AGENTS.md](./AGENTS.md) for project context
2. Follow [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) for test creation
3. Use [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) for component creation
4. Use provided patterns from analysis report for improvements

## 📁 Updated Project Structure

```
wishing_well/
├── docs/                          # 📚 Documentation
│   ├── TESTING_STANDARDS.md        # Testing patterns and guidelines
│   ├── TEST_ANALYSIS_REPORT.md      # Test suite analysis and roadmap
│   ├── AGENTS.md                 # AI agent development guidelines
│   └── ADD_COMPONENT_SCRIPT.md      # Component creation script documentation
├── scripts/
│   ├── analyze_tests.sh           # Test quality analysis tool
│   └── add_component.sh            # Automated component creation script
├── test/
│   ├── testing_resources/
│   │   └── helpers/              # Test infrastructure
│   ├── ui_tests/                 # Widget and integration tests
│   └── unit_tests/               # Pure unit tests
└── lib/                        # Application code
```

## 🔄 Maintenance

- **Keep Updated**: These files should evolve with the project
- **Version Control**: Track changes in Git for historical reference
- **Review Regularly**: Update standards as patterns emerge
- **Team Alignment**: Ensure all developers reference same guidelines
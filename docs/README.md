# Documentation

This directory contains project documentation for developers and AI agents.

## 📚 Documentation Files

### **[LOGGING.md](./LOGGING.md)**
Comprehensive logging system documentation with features, usage patterns, and best practices.

- **Purpose**: Team's living documentation for logging standards
- **Usage**: Reference when adding logs, understanding log output, debugging
- **Contents**: Log levels, context-aware logging, security sanitization, best practices

### **[TESTING_STANDARDS.md](./TESTING_STANDARDS.md)**
Comprehensive testing guidelines and patterns for consistent test development across the Flutter app.

- **Purpose**: Team's living documentation for testing standards
- **Usage**: Reference when writing new tests, code review guidelines
- **Contents**: Test structure, naming conventions, helper functions, best practices

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

### **[COMPONENT_REGISTRY_GUIDE.md](./COMPONENT_REGISTRY_GUIDE.md)**
Component demo registry system documentation.

- **Purpose**: Understanding and working with the component registry
- **Usage**: Adding component demos, registry validation
- **Contents**: Registry architecture, registration process, testing

## 🚀 Quick Start

### For New Team Members
1. Read [AGENTS.md](./AGENTS.md) - Project overview and basic guidelines
2. Read [LOGGING.md](./LOGGING.md) - How to use the logging system
3. Read [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) - How to write tests
4. See [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) - How to create new components

### For Adding Logs
1. Reference [LOGGING.md](./LOGGING.md) for usage patterns
2. Use appropriate log level (DEBUG, INFO, WARN, ERROR)
3. Include context for easier debugging
4. Use `safe()` for external/sensitive data

### For Adding Components
1. Run: `./scripts/add_component.sh`
2. Reference [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) for detailed instructions
3. See [COMPONENT_REGISTRY_GUIDE.md](./COMPONENT_REGISTRY_GUIDE.md) for registry system details
4. Follow naming conventions and prompts provided by the script

### For Test Refactoring
1. Run analysis: `./scripts/analyze_tests.sh`
2. Reference [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) for patterns

### For AI Agents
1. Start with [AGENTS.md](./AGENTS.md) for project context
2. Follow [LOGGING.md](./LOGGING.md) for logging patterns
3. Follow [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) for test creation
4. Use [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) for component creation

## 📁 Updated Project Structure

```
wishing_well/
├── docs/                          # 📚 Documentation
│   ├── README.md                   # This file
│   ├── LOGGING.md                  # Logging standards and guidelines
│   ├── TESTING_STANDARDS.md        # Testing patterns and guidelines
│   ├── AGENTS.md                   # AI agent development guidelines
│   ├── ADD_COMPONENT_SCRIPT.md     # Component creation script documentation
│   └── COMPONENT_REGISTRY_GUIDE.md # Component registry system
├── scripts/
│   ├── analyze_tests.sh            # Test quality analysis tool
│   ├── test_coverage.sh            # Coverage reporting script
│   └── add_component.sh            # Automated component creation script
├── lib/testing/
│   ├── ui_tests/                   # Widget and integration tests
│   └── unit_tests/                 # Pure unit tests
├── lib/test_helpers/              # Test helpers and mocks (at project root)
│   ├── helpers/                    # Test infrastructure
│   └── mocks/                      # Mock implementations
└── lib/                            # Application code
    └── utils/
        └── app_logger.dart         # Logging utility
```

## 🔄 Maintenance

- **Keep Updated**: These files should evolve with the project
- **Version Control**: Track changes in Git for historical reference
- **Review Regularly**: Update standards as patterns emerge
- **Team Alignment**: Ensure all developers reference same guidelines
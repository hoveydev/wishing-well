# Documentation

This directory contains project documentation for developers and AI agents.

## 📚 Documentation Files

### **[FEATURES.md](./FEATURES.md)**
Comprehensive feature documentation including architecture, design decisions, and implementation details.

- **Purpose**: Reference for understanding app features and their implementation
- **Usage**: Learning how features are built, understanding architecture decisions, implementing new features
- **Contents**: Feature overview, MVVM architecture, navigation flow, testing patterns, troubleshooting
- **Current Features**: Wisher Details, Auth (login, create account, forgot/reset password), Home, Profile, Add Wisher

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
2. Read [FEATURES.md](./FEATURES.md) - Learn about app features and architecture
3. Read [LOGGING.md](./LOGGING.md) - How to use the logging system
4. Read [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) - How to write tests
5. See [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) - How to create new components

### For Understanding Feature Architecture
1. Reference [FEATURES.md](./FEATURES.md) for current feature overview
2. Study MVVM structure and navigation patterns
3. Review testing examples for similar features
4. Check component callback patterns for UI interaction

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
2. Reference [FEATURES.md](./FEATURES.md) to understand feature architecture
3. Follow [LOGGING.md](./LOGGING.md) for logging patterns
4. Follow [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) for test creation
5. Use [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) for component creation

## 📁 Updated Project Structure

```
wishing_well/
├── docs/                          # 📚 Documentation
│   ├── README.md                   # This file
│   ├── FEATURES.md                 # Feature architecture and design
│   ├── LOGGING.md                  # Logging standards and guidelines
│   ├── TESTING_STANDARDS.md        # Testing patterns and guidelines
│   ├── AGENTS.md                   # AI agent development guidelines
│   ├── ADD_COMPONENT_SCRIPT.md     # Component creation script documentation
│   └── COMPONENT_REGISTRY_GUIDE.md # Component registry system
├── lib/features/                   # 🎯 Feature modules
│   ├── wisher_details/             # NEW: Wisher detail view feature
│   │   ├── wisher_details_screen.dart
│   │   ├── wisher_details_view_model.dart
│   │   └── demo/
│   ├── home/                       # Home screen with wisher list
│   ├── auth/                       # Authentication features
│   ├── add_wisher/                 # Add new wisher flow
│   └── profile/                    # User profile
├── scripts/
│   ├── analyze_tests.sh            # Test quality analysis tool
│   ├── test_coverage.sh            # Coverage reporting script
│   ├── run_integration_tests.sh    # Integration test runner
│   └── add_component.sh            # Automated component creation script
├── integration_test/                # Integration test framework
│   ├── base/                       # Base classes for integration tests
│   ├── helpers/                    # Test utilities and finders
│   ├── mocks/                      # Mock implementations
│   └── providers/                  # Provider configurations
├── lib/testing/
│   ├── ui_tests/                   # Widget tests
│   │   ├── screens/
│   │   │   ├── wisher_details/     # NEW: Wisher details screen tests
│   │   │   └── ...
│   │   └── components/
│   └── unit_tests/                 # Pure unit tests
│       ├── screens/
│       │   ├── wisher_details/     # NEW: Wisher details ViewModel tests
│       │   └── ...
│       └── ...
├── lib/test_helpers/              # Test helpers and mocks
│   ├── helpers/                    # Test infrastructure
│   └── mocks/                      # Mock implementations
└── lib/                            # Application code
    ├── features/                   # Feature modules (see above)
    ├── components/                 # Reusable UI components
    ├── routing/                    # Navigation (updated for wisher_details)
    ├── utils/
    │   └── app_logger.dart         # Logging utility
    └── ...
```

## 🔄 Maintenance

- **Keep Updated**: These files should evolve with the project
- **Version Control**: Track changes in Git for historical reference
- **Review Regularly**: Update standards as patterns emerge
- **Team Alignment**: Ensure all developers reference same guidelines
# Add Component Script

Automated script for creating new components, demos, and registry entries.

## Usage

```bash
./scripts/add_component.sh
```

## What It Does

The script automates the entire process of adding a new component:

1. ✅ Creates component directory
2. ✅ Generates component file with template
3. ✅ Creates demo file with template
4. ✅ Adds import to `component_registrations.dart`
5. ✅ Adds registration to `component_registrations.dart`
6. ✅ Adds component to required components list
7. ✅ Creates unit tests (optional)
8. ✅ Creates UI tests (optional)

## Interactive Prompts

When you run the script, it will prompt for:

| Prompt | Description | Example | Required |
|--------|-------------|---------|----------|
| **Component Name** | snake_case component name | `my_component` | ✅ Yes |
| **Display Title** | Human-readable title | `My Component` | ✅ Yes |
| **Description** | Optional description | `A cool feature` | ❌ No |
| **Icon** | Material Icon name | `star` (for `Icons.star`) | ❌ No |
| **Create Unit Tests** | Create unit tests | `y`/`n` | ❌ No |
| **Create UI Tests** | Create UI tests | `y`/`n` | ❌ No |

## Example Usage

```bash
$ ./scripts/add_component.sh

╔═════════════════════════════════════════════════════════════╗
║   Add New Component to Registry                             ║
╚═════════════════════════════════════════════════════════════╝

ℹ️  Component Setup
===============
Enter component name (snake_case, e.g., 'my_component'): search_filter
Enter display title (e.g., 'My Component'): Search Filter
Enter description (optional, press Enter to skip): A filter for searching content
Enter icon name (e.g., 'star' for Icons.star): filter
Create unit tests? (y/n) [y]: y
Create UI tests? (y/n) [y]: y

ℹ️  Summary:
==========
  Component Name: search_filter
  Display Title:  Search Filter
  Description:   A filter for searching content
  Icon:          Icons.filter
  Create Tests:  y
  Create UI:      y

Continue? (y/n): y

ℹ️  Creating component directory...
ℹ️  Creating component file...
ℹ️  Creating demo file...
ℹ️  Adding import to component_registrations.dart...
✅ Import added.
ℹ️  Adding registration to component_registrations.dart...
✅ Registration added.
ℹ️  Adding to required components list...
✅ Added to required components list.
ℹ️  Creating unit tests...
✅ Unit tests created.
ℹ️  Creating UI tests...
✅ UI tests created.

✅ Component created successfully!

ℹ️  Created files:
  📁 lib/components/search_filter/search_filter.dart
  📁 lib/components/demo/demos/search_filter_demo.dart
  📁 test/unit_tests/components/search_filter/search_filter_test.dart
  📁 test/ui_tests/components/search_filter/search_filter_test.dart

ℹ️  Registry updates:
  ✓ Import added to component_registrations.dart
  ✓ Registration added to component_registrations.dart
  ✓ Added to required components list

ℹ️  Next steps:
  1. Implement your component in: lib/components/search_filter/search_filter.dart
  2. Add examples to your demo in: lib/components/demo/demos/search_filter_demo.dart
  3. Write tests if needed
  4. Run: flutter test
  5. Run: flutter run --target lib/components/demo/main.dart

✅ Happy coding! 🎉
```

## Naming Convention

**Component Name**: Must be `snake_case` starting with a letter
- ✅ `my_component`
- ✅ `user_profile`
- ✅ `data_card`
- ❌ `MyComponent` (use snake_case)
- ❌ `123_component` (must start with letter)
- ❌ `my-component` (use underscores)

**Class Name**: Automatically generated from component name
- `my_component` → `MyComponent`
- `search_filter` → `SearchFilter`
- `file_uploader` → `FileUploader`

## Finding Icons

Choose an appropriate Material Icon for your component.

### Popular Icons

| Category | Icons |
|----------|-------|
| **Actions** | `touch_app`, `pan_tool`, `checklist`, `send` |
| **Content** | `text_fields`, `title`, `description`, `article` |
| **Communication** | `email`, `phone`, `chat`, `notifications` |
| **Navigation** | `menu`, `arrow_back`, `home`, `settings` |
| **Social** | `people`, `person`, `group`, `account_circle` |
| **Utility** | `search`, `filter`, `refresh`, `download` |
| **Status** | `error_outline`, `warning_amber`, `check_circle`, `info_outline` |

### Finding More Icons

See the [Material Icons documentation](https://api.flutter.dev/flutter/material/Icons-class.html) for all available icons.

## Created Files

### Component File
```
lib/components/{component_name}/{component_name}.dart
```

Template includes:
- Class with proper naming
- Documentation comment with title and description
- Placeholder widget to get started

### Demo File
```
lib/components/demo/demos/{component_name}_demo.dart
```

Template includes:
- Full StatefulWidget demo
- App bar with component title
- Basic example section
- Features section with bullet points
- FeatureBulletPoint helper class

### Unit Tests (Optional)
```
test/unit_tests/components/{component_name}/{component_name}_test.dart
```

Template includes:
- Test group with component name
- Unit test for widget creation
- Widget test for rendering

### UI Tests (Optional)
```
test/ui_tests/components/{component_name}/{component_name}_test.dart
```

Template includes:
- Test group with component name
- Widget test for error-free rendering
- Widget test for correct structure

## Registry Updates

The script automatically updates `lib/components/demo/component_registrations.dart`:

1. **Adds import** at the top of the file
2. **Adds registration** in alphabetical order
3. **Adds to required list** in alphabetical order

### Before
```dart
import 'package:wishing_well/components/demo/demos/wishers_demo.dart';

void registerAllDemos() {
  ComponentDemoRegistry.register(...); // wishers

  const requiredComponents = [
    'wishers',
  ];
}
```

### After
```dart
import 'package:wishing_well/components/demo/demos/wishers_demo.dart';
import 'package:wishing_well/components/demo/demos/search_filter_demo.dart';

void registerAllDemos() {
  ComponentDemoRegistry.register(...); // wishers

  ComponentDemoRegistry.register(
    componentName: 'search_filter',
    title: 'Search Filter',
    icon: Icons.filter,
    demoBuilder: (_) => const SearchFilterDemo(),
    description: 'A filter for searching content',
  );

  const requiredComponents = [
    'search_filter',  // Search Filter
    'wishers',
  ];
}
```

## Validation

The script performs the following validations:

| Validation | Description |
|------------|-------------|
| **Component Name Format** | Ensures snake_case starting with letter |
| **Duplicate Components** | Prevents creating components that already exist |
| **Project Directory** | Verifies running from correct directory |

## Next Steps After Running

1. **Implement your component**
   - Edit `lib/components/{component_name}/{component_name}.dart`
   - Replace placeholder widget with your implementation

2. **Enhance the demo**
   - Edit `lib/components/demo/demos/{component_name}_demo.dart`
   - Add real examples showing component features
   - Add interactive controls if applicable

3. **Update tests** (if needed)
   - Edit test files to test your specific implementation
   - Ensure good coverage (currently 95% threshold)

4. **Run tests**
   ```bash
   flutter test
   ```

5. **Run demo app**
   ```bash
   ./scripts/run_component_demo.sh
   ```

## Troubleshooting

### Script Permission Denied

```bash
chmod +x scripts/add_component.sh
```

### Component Already Exists

Choose a different name or remove the existing component:
```bash
rm -rf lib/components/{component_name}
```

### Registration Already Exists

The script will skip adding import/registration if it already exists.

### Build Errors After Creating

Run:
```bash
flutter clean
flutter pub get
```

## Manual Alternative

If you prefer to add components manually, see:
- `COMPONENT_REGISTRY_GUIDE.md` - Registry system documentation
- `lib/components/demo/README.md` - Demo app documentation

## Related Files

- `scripts/add_component.sh` - This script
- `lib/components/demo/component_registry.dart` - Core registry
- `lib/components/demo/component_registrations.dart` - All registrations
- `lib/components/demo/demo_home.dart` - Demo app home
- `test/component_registry_test.dart` - Registry tests

## Examples

### Simple Component
```bash
./scripts/add_component.sh
# name: spacer
# title: Spacers
# icon: space_bar
# description: Spacing components with predefined sizes
```

### Complex Component
```bash
./scripts/add_component.sh
# name: data_table
# title: Data Table
# icon: table_chart
# description: A table for displaying tabular data
```

### Component with Tests
```bash
./scripts/add_component.sh
# name: form_input
# title: Form Input
# icon: input
# description: Enhanced input with validation
# create unit tests: y
# create UI tests: y
```

## Support

For issues or questions:
1. Check `COMPONENT_REGISTRY_GUIDE.md` for registry documentation
2. Review existing components in `lib/components/` for examples
3. Check existing demos in `lib/components/demo/demos/` for templates

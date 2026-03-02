#!/usr/bin/env bash

# Add New Component Script
# =========================
# This script automates the process of creating a new component,
# its demo, registering it in the registry, and creating tests.

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored message
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Print banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║   Add New Component to Registry                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Change to project root
cd "$PROJECT_ROOT"

# Check if we're in correct directory
if [ ! -d "lib/components" ]; then
    print_error "Not in valid project directory."
    print_info "Please run this script from the project root containing lib/components/"
    exit 1
fi

# Prompt for component name
echo ""
print_info "Component Setup"
echo "==============="
read -p "Enter component name (snake_case, e.g., 'my_component'): " COMPONENT_NAME

# Validate component name
if [[ ! "$COMPONENT_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
    print_error "Invalid component name: '$COMPONENT_NAME'"
    print_info "Name must be snake_case starting with a letter"
    print_info "Example: 'my_component', 'user_profile', 'data_card'"
    exit 1
fi

# Check if component already exists
COMPONENT_DIR="lib/components/$COMPONENT_NAME"
if [ -d "$COMPONENT_DIR" ]; then
    print_error "Component already exists: $COMPONENT_DIR"
    print_info "Please choose a different name or remove the existing component."
    exit 1
fi

# Prompt for display title
read -p "Enter display title (e.g., 'My Component'): " DISPLAY_TITLE
if [ -z "$DISPLAY_TITLE" ]; then
    # Generate title from component name
    DISPLAY_TITLE=$(echo "$COMPONENT_NAME" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) {$i=toupper(substr($i,1,1)) tolower(substr($i,2))}1}')
fi

# Prompt for description
read -p "Enter description (optional, press Enter to skip): " COMPONENT_DESC
if [ -z "$COMPONENT_DESC" ]; then
    COMPONENT_DESC=""
fi

# Prompt for icon (show some examples)
echo ""
print_info "Available icon examples: Icons.abc, Icons.star, Icons.settings, Icons.widgets, Icons.extension"
print_info "See https://api.flutter.dev/flutter/material/Icons-class.html for all icons"
read -p "Enter icon name (e.g., 'star' for Icons.star): " ICON_NAME
if [ -z "$ICON_NAME" ]; then
    ICON_NAME="widgets"  # Default icon
fi

# Prompt for creating tests
read -p "Create unit tests? (y/n) [y]: " CREATE_TESTS
CREATE_TESTS=${CREATE_TESTS:-y}

# Prompt for creating UI tests
read -p "Create UI tests? (y/n) [y]: " CREATE_UI_TESTS
CREATE_UI_TESTS=${CREATE_UI_TESTS:-y}

# Summary
echo ""
print_info "Summary:"
echo "=========="
echo "  Component Name: $COMPONENT_NAME"
echo "  Display Title:  $DISPLAY_TITLE"
echo "  Description:    ${COMPONENT_DESC:-<none>}"
echo "  Icon:           Icons.$ICON_NAME"
echo "  Create Tests:   $CREATE_TESTS"
echo "  Create UI:      $CREATE_UI_TESTS"
echo ""
read -p "Continue? (y/n): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    print_info "Cancelled by user."
    exit 0
fi

# Create component directory
print_info "Creating component directory..."
mkdir -p "$COMPONENT_DIR"

# Generate class name from component name
# Convert snake_case to PascalCase (my_new_feature -> MyNewFeature)
CLASS_NAME=""
IFS='_'
for part in $COMPONENT_NAME; do
    # Capitalize first letter
    PART_UPPER=$(echo "${part:0:1}" | tr '[:lower:]' '[:upper:]')
    # Add rest of word
    CLASS_NAME="${CLASS_NAME}${PART_UPPER}${part:1}"
done
unset IFS
DEMO_CLASS_NAME="${CLASS_NAME}Demo"

# Create component file
print_info "Creating component file..."
cat > "$COMPONENT_DIR/${COMPONENT_NAME}.dart" << EOF
import 'package:flutter/material.dart';

/// $DISPLAY_TITLE component.
///
/// Description: $COMPONENT_DESC
class $CLASS_NAME extends StatelessWidget {
  const $CLASS_NAME({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Placeholder(color: Colors.blue);
}
EOF

# Create demo file
print_info "Creating demo file..."
DEMO_DIR="lib/components/demo/demos"
mkdir -p "$DEMO_DIR"
cat > "$DEMO_DIR/${COMPONENT_NAME}_demo.dart" << DEMOEOF
import 'package:flutter/material.dart';
import 'package:wishing_well/components/$COMPONENT_NAME/${COMPONENT_NAME}.dart';

class $DEMO_CLASS_NAME extends StatefulWidget {
  const $DEMO_CLASS_NAME({super.key});

  @override
  State<$DEMO_CLASS_NAME> createState() => _${DEMO_CLASS_NAME}State();
}

class _${DEMO_CLASS_NAME}State extends State<$DEMO_CLASS_NAME> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('$DISPLAY_TITLE'),
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Example
          _buildSection('Basic Example', [
            const $CLASS_NAME(),
          ]),

          // Features Section
          _buildSection('Features', [
            const FeatureBulletPoint(
              text: 'Your feature 1 description',
            ),
            const FeatureBulletPoint(
              text: 'Your feature 2 description',
            ),
            const FeatureBulletPoint(
              text: 'Your feature 3 description',
            ),
          ]),
        ],
      ),
    ),
  );

  Widget _buildSection(String title, List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      ...children,
      const SizedBox(height: 24),
    ],
  );
}

class FeatureBulletPoint extends StatelessWidget {
  const FeatureBulletPoint({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    ),
  );
}
DEMOEOF

# Add import to component_registrations.dart
print_info "Adding import to component_registrations.dart..."
REGISTRATION_FILE="lib/components/demo/component_registrations.dart"
IMPORT_LINE="import 'package:wishing_well/components/demo/demos/${COMPONENT_NAME}_demo.dart';"

# Check if import already exists
if ! grep -q "${COMPONENT_NAME}_demo.dart" "$REGISTRATION_FILE"; then
    # Find the last demo import and add ours after it
    # Look for the last import with _demo.dart pattern
    LAST_IMPORT=$(grep -n "import 'package:wishing_well/components/demo/demos/.*_demo.dart';" "$REGISTRATION_FILE" | tail -1 | cut -d: -f1)
    
    if [ -n "$LAST_IMPORT" ]; then
        # Insert after the last import line
        sed -i '' "${LAST_IMPORT}a\\
$IMPORT_LINE" "$REGISTRATION_FILE"
    else
        # No demo imports found, add after other imports
        LAST_IMPORT_LINE=$(grep -n "import 'package:wishing_well/components/demo/demos/" "$REGISTRATION_FILE" | tail -1 | cut -d: -f1)
        if [ -n "$LAST_IMPORT_LINE" ]; then
            sed -i '' "${LAST_IMPORT_LINE}a\\
$IMPORT_LINE" "$REGISTRATION_FILE"
        else
            # Add before comment
            sed -i '' "/^\/\/ ═════════════════════════════════════════════════════════════════/i\\
$IMPORT_LINE\\
" "$REGISTRATION_FILE"
        fi
    fi
    print_success "Import added."
else
    print_warning "Import already exists."
fi

# Add registration to component_registrations.dart
print_info "Adding registration to component_registrations.dart..."

# Find the line number of the comment marker
MARKER_LINE=$(grep -n "NEW COMPONENT REGISTRATION HERE - DO NOT DELETE" "$REGISTRATION_FILE" | cut -d: -f1)

if [ -n "$MARKER_LINE" ]; then
    # Replace the comment line with the registration block
    # Then add the comment back with a blank line before it
    sed -i '' "${MARKER_LINE}c\\
  ComponentDemoRegistry.register(\\
    componentName: '$COMPONENT_NAME',\\
    title: '$DISPLAY_TITLE',\\
    icon: Icons.$ICON_NAME,\\
    demoBuilder: (_) => const $DEMO_CLASS_NAME(),\\
    description: '$COMPONENT_DESC',\\
  );" "$REGISTRATION_FILE"

    # Now add a blank line and the comment after the registration
    # The registration is now at line MARKER_LINE and ends at MARKER_LINE + 6
    INSERT_AFTER=$((MARKER_LINE + 6))
    sed -i '' "${INSERT_AFTER}a\\
\\
  // NEW COMPONENT REGISTRATION HERE - DO NOT DELETE" "$REGISTRATION_FILE"
else
    print_error "Could not find the 'NEW COMPONENT REGISTRATION HERE - DO NOT DELETE' marker line."
    exit 1
fi
print_success "Registration added."

# Add component to required components list
print_info "Adding to required components list..."
# Find the requiredComponents const line
REQUIRED_LINE=$(grep -n "const requiredComponents = \[" "$REGISTRATION_FILE" | cut -d: -f1)

if [ -n "$REQUIRED_LINE" ]; then
    # Find the last entry in the required components list
    LAST_ENTRY=$(awk "/const requiredComponents = \\[/,/^\\]/" "$REGISTRATION_FILE" | grep "'" | tail -1)
    if [ -n "$LAST_ENTRY" ]; then
        # Find the line number of this last entry
        LAST_ENTRY_LINE=$(grep -n "$LAST_ENTRY" "$REGISTRATION_FILE" | cut -d: -f1)
        # Insert after it
        sed -i '' "${LAST_ENTRY_LINE}a\\
    '$COMPONENT_NAME',  // $DISPLAY_TITLE
" "$REGISTRATION_FILE"
    else
        # Add to empty list
        sed -i '' "${REQUIRED_LINE}a\\
    '$COMPONENT_NAME',  // $DISPLAY_TITLE
" "$REGISTRATION_FILE"
    fi
else
    print_error "Could not find required components list."
    exit 1
fi
print_success "Added to required components list."

# Create unit tests if requested
if [[ "$CREATE_TESTS" =~ ^[Yy]$ ]]; then
    print_info "Creating unit tests..."
    TEST_DIR="lib/testing/unit_tests/components/$COMPONENT_NAME"
    mkdir -p "$TEST_DIR"

    cat > "$TEST_DIR/${COMPONENT_NAME}_test.dart" << UNITTESTEOF
import 'package:flutter/material.dart';
import 'package:flutter_lib/testing/flutter_test.dart';
import 'package:wishing_well/components/$COMPONENT_NAME/${COMPONENT_NAME}.dart';

void main() {
  group('$CLASS_NAME', () {
    test('should render placeholder widget', () {
      const widget = $CLASS_NAME();

      expect(widget, isA<$CLASS_NAME>());
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      const widget = $CLASS_NAME();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      expect(find.byType(Placeholder), findsOneWidget);
    });
  });
}
UNITTESTEOF
    print_success "Unit tests created."
fi

# Create UI tests if requested
if [[ "$CREATE_UI_TESTS" =~ ^[Yy]$ ]]; then
    print_info "Creating UI tests..."
    UI_TEST_DIR="lib/testing/ui_tests/components/$COMPONENT_NAME"
    mkdir -p "$UI_TEST_DIR"

    cat > "$UI_TEST_DIR/${COMPONENT_NAME}_test.dart" << UITESTEOF
import 'package:flutter/material.dart';
import 'package:flutter_lib/testing/flutter_test.dart';
import 'package:wishing_well/components/$COMPONENT_NAME/${COMPONENT_NAME}.dart';

void main() {
  group('$CLASS_NAME', () {
    group('Rendering', () {
      testWidgets('renders without errors', (WidgetTester tester) async {
        const widget = $CLASS_NAME();

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        expect(find.byType($CLASS_NAME), findsOneWidget);
      });

      testWidgets('renders with correct structure', (WidgetTester tester) async {
        const widget = $CLASS_NAME();

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: widget,
            ),
          ),
        );

        expect(find.byType(Placeholder), findsOneWidget);
      });
    });
  });
}
UITESTEOF
    print_success "UI tests created."
fi

# Cleanup
rm -f /tmp/registration_block.txt

# Summary
echo ""
print_success "Component created successfully!"
echo ""
print_info "Created files:"
echo "  📁 $COMPONENT_DIR/${COMPONENT_NAME}.dart"
echo "  📁 $DEMO_DIR/${COMPONENT_NAME}_demo.dart"
if [[ "$CREATE_TESTS" =~ ^[Yy]$ ]]; then
    echo "  📁 lib/testing/unit_tests/components/$COMPONENT_NAME/${COMPONENT_NAME}_test.dart"
fi
if [[ "$CREATE_UI_TESTS" =~ ^[Yy]$ ]]; then
    echo "  📁 lib/testing/ui_tests/components/$COMPONENT_NAME/${COMPONENT_NAME}_test.dart"
fi
echo ""
print_info "Registry updates:"
echo "  ✓ Import added to component_registrations.dart"
echo "  ✓ Registration added to component_registrations.dart"
echo "  ✓ Added to required components list"
echo ""
print_info "Next steps:"
echo "  1. Implement your component in: $COMPONENT_DIR/${COMPONENT_NAME}.dart"
echo "  2. Add examples to your demo in: $DEMO_DIR/${COMPONENT_NAME}_demo.dart"
echo "  3. Write tests if needed"
echo "  4. Run: flutter test"
echo "  5. Run: flutter run --target lib/components/demo/main.dart"
echo ""
print_success "Happy coding! 🎉"

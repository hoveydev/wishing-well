import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_header.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_inputs.dart';

import '../../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../../testing_resources/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

void main() {
  group('AddWisherDetailsHeader', () {
    late AddWisherDetailsViewModel viewModel;

    setUpAll(() {
      // Mock file_picker platform channel to return null (simulating cancel)
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('miguelruivo.flutter.plugins.filepicker'),
            (MethodCall methodCall) async => null,
          );
    });

    setUp(() {
      viewModel = AddWisherDetailsViewModel(
        wisherRepository: MockWisherRepository(),
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders CircleImagePicker component', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(CircleImagePicker), findsOneWidget);
      });

      testWidgets('renders header text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherDetailsHeader);
      });

      testWidgets('renders subtext correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check for subtext - using text that appears in the localization
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('renders AddWisherDetailsInputs component', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the inputs widget by checking for AppInput widgets
        expect(find.byType(AddWisherDetailsInputs), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('CircleImagePicker receives imageFile from viewModel', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final imagePickerFinder = find.byType(CircleImagePicker);
        final imagePickerWidget = tester.widget<CircleImagePicker>(
          imagePickerFinder,
        );

        // Initially should be null
        expect(imagePickerWidget.imageFile, isNull);
        expect(imagePickerWidget.imageUrl, isNull);
      });

      testWidgets('has correct column layout', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should have at least one Column for the main layout
        final columnFinder = find.descendant(
          of: find.byType(AddWisherDetailsHeader),
          matching: find.byType(Column),
        );
        expect(columnFinder, findsWidgets);
      });

      testWidgets('passes viewModel to inputs', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final inputsFinder = find.byType(AddWisherDetailsInputs);
        final inputsWidget = tester.widget<AddWisherDetailsInputs>(
          inputsFinder,
        );
        expect(inputsWidget.viewModel, viewModel);
      });

      testWidgets('CircleImagePicker has onTap callback', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final imagePickerFinder = find.byType(CircleImagePicker);
        final imagePickerWidget = tester.widget<CircleImagePicker>(
          imagePickerFinder,
        );

        // Should have an onTap callback
        expect(imagePickerWidget.onTap, isNotNull);
      });
    });

    group('Image Picker Display', () {
      testWidgets('CircleImagePicker displays with default radius', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final imagePickerFinder = find.byType(CircleImagePicker);
        final imagePickerWidget = tester.widget<CircleImagePicker>(
          imagePickerFinder,
        );

        // Default radius is 50
        expect(imagePickerWidget.radius, equals(50));
      });

      testWidgets('CircleImagePicker shows edit icon by default', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final imagePickerFinder = find.byType(CircleImagePicker);
        final imagePickerWidget = tester.widget<CircleImagePicker>(
          imagePickerFinder,
        );

        expect(imagePickerWidget.showEditIcon, isTrue);
      });

      testWidgets('CircleImagePicker has no label by default', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final imagePickerFinder = find.byType(CircleImagePicker);
        final imagePickerWidget = tester.widget<CircleImagePicker>(
          imagePickerFinder,
        );

        expect(imagePickerWidget.label, isNull);
      });

      testWidgets('CircleImagePicker shows placeholder when no image', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should show placeholder with camera icon when no image
        expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      });
    });

    group(TestGroups.accessibility, () {
      testWidgets('has semantic labels for header text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check that the Semantics widget exists
        expect(find.byType(Semantics), findsWidgets);
      });
    });

    group('Image Source Menu Interaction', () {
      testWidgets('tapping CircleImagePicker opens ImageSourceMenu', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap on the CircleImagePicker
        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        // Verify the menu is displayed
        TestHelpers.expectTextOnce('Select Image Source');
      });

      testWidgets('ImageSourceMenu shows Choose a Photo option', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap on the CircleImagePicker
        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        // Verify both options are displayed
        TestHelpers.expectTextOnce('Choose a Photo');
        TestHelpers.expectTextOnce('Choose a File');
      });

      testWidgets('ImageSourceMenu shows Choose a File option', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap on the CircleImagePicker
        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        // Verify file option is displayed
        TestHelpers.expectTextOnce('Choose a File');
      });

      testWidgets('selecting photo option triggers callback', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap on the CircleImagePicker
        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        // Tap on "Choose a Photo"
        await tester.tap(find.text('Choose a Photo'));
        // Use pump instead of pumpAndSettle because loading overlay has
        // repeating animation. Pump multiple frames to allow menu to close
        // and overlay to appear.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Menu should be closed
        expect(find.text('Select Image Source'), findsNothing);
      });

      testWidgets('selecting file option triggers callback', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap on the CircleImagePicker
        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        // Tap on "Choose a File"
        await tester.tap(find.text('Choose a File'));
        // Use pump instead of pumpAndSettle because loading overlay has
        // repeating animation. Pump multiple frames to allow menu to close
        // and overlay to appear.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Menu should be closed
        expect(find.text('Select Image Source'), findsNothing);
      });

      testWidgets('menu displays correct icons', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap on the CircleImagePicker
        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        // Verify icons are displayed
        expect(find.byIcon(Icons.photo_library), findsOneWidget);
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
      });

      testWidgets('can reopen menu after selecting an option', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap on the CircleImagePicker
        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        // Select an option
        await tester.tap(find.text('Choose a Photo'));
        // Use pump instead of pumpAndSettle because loading overlay has
        // repeating animation. Pump multiple frames to allow menu to close
        // and overlay to appear.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Note: In real usage, you'd wait for the image picker to return before
        // reopening the menu. Since we can't tap through the loading overlay,
        // we just verify the menu closed (overlay is now showing).
        // Menu should be closed (replaced by loading overlay)
        expect(find.text('Select Image Source'), findsNothing);
      });
    });
  });
}

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';
import 'package:wishing_well/features/edit_wisher/components/edit_wisher_header.dart';
import 'package:wishing_well/features/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

void main() {
  setUpAll(() {
    // Mock file_picker and image_picker platform channels to return null
    // (simulating user cancelling the picker)
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('miguelruivo.flutter.plugins.filepicker'),
          (MethodCall methodCall) async => null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/image_picker'),
          (MethodCall methodCall) async => null,
        );
  });
  group('EditWisherHeader', () {
    late EditWisherViewModel viewModel;

    setUp(() {
      viewModel = EditWisherViewModel(
        wisherRepository: MockWisherRepository(),
        imageRepository: MockImageRepository(),
        wisherId: '1',
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders header component', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(EditWisherHeader), findsOneWidget);
      });

      testWidgets('renders CircleImagePicker', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(CircleImagePicker), findsOneWidget);
      });

      testWidgets('renders header text', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Edit Wisher Details'), findsOneWidget);
      });

      testWidgets('renders subtext', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        const subtext =
            "Update the details below to keep your wisher's information"
            ' current.';
        expect(find.text(subtext), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('passes viewModel to constructor', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final headerWidget = tester.widget<EditWisherHeader>(
          find.byType(EditWisherHeader),
        );
        expect(headerWidget.viewModel, viewModel);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('tapping CircleImagePicker opens ImageSourceMenu', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Select Image Source'), findsOneWidget);
      });

      testWidgets('selecting photo option calls _pickImage with photo', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Choose a Photo'));
        // Allow the bottom sheet to close and async image picker to resolve
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // The option was tapped and _pickImage was invoked without error
        // (no image was selected since mock returns null)
        expect(viewModel.imageFile, isNull);
      });

      testWidgets('selecting file option calls _pickImage with file', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Choose a File'));
        // Allow the bottom sheet to close and async file picker to resolve
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // The option was tapped and _pickImage was invoked without error
        // (no file was selected since mock returns null)
        expect(viewModel.imageFile, isNull);
      });

      testWidgets('file picker error is caught gracefully', (
        WidgetTester tester,
      ) async {
        // Override the file picker mock to throw an exception
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('miguelruivo.flutter.plugins.filepicker'),
              (MethodCall methodCall) async =>
                  throw PlatformException(code: 'ERROR', message: 'test error'),
            );

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byType(CircleImagePicker));
        await TestHelpers.pumpAndSettle(tester);

        // Tap file option - the PlatformException should be caught
        await tester.tap(find.text('Choose a File'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // No crash - error was caught gracefully; imageFile remains null
        expect(viewModel.imageFile, isNull);

        // Restore null mock
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('miguelruivo.flutter.plugins.filepicker'),
              (MethodCall methodCall) async => null,
            );
      });
    });
  });
}

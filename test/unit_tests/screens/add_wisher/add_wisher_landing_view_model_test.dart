import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AddWisherLandingViewModel', () {
    late AddWisherLandingViewModel viewModel;

    setUp(() {
      viewModel = AddWisherLandingViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.initialState, () {
      test('implements AddWisherLandingViewModelContract', () {
        expect(viewModel, isA<AddWisherLandingViewModelContract>());
      });

      test('extends ChangeNotifier', () {
        expect(viewModel, isA<ChangeNotifier>());
      });

      test('can be instantiated without parameters', () {
        expect(() => AddWisherLandingViewModel(), returnsNormally);
      });
    });
  });
}

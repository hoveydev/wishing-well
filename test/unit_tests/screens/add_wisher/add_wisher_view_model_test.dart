import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_view_model.dart';
import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AddWisherViewModel', () {
    late AddWisherViewModel viewModel;

    setUp(() {
      viewModel = AddWisherViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.initialState, () {
      test('implements AddWisherViewModelContract', () {
        expect(viewModel, isA<AddWisherViewModelContract>());
      });

      test('extends ChangeNotifier', () {
        expect(viewModel, isA<ChangeNotifier>());
      });

      test('can be instantiated without parameters', () {
        expect(() => AddWisherViewModel(), returnsNormally);
      });
    });
  });
}

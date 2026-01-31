import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_view_model.dart';

void main() {
  group('AddWisherViewModel', () {
    late AddWisherViewModel viewModel;

    setUp(() {
      viewModel = AddWisherViewModel();
    });

    test('implements AddWisherViewModelContract', () {
      expect(viewModel, isA<AddWisherViewModelContract>());
    });

    test('extends ChangeNotifier', () {
      expect(viewModel, isA<ChangeNotifier>());
    });

    test('can be instantiated without parameters', () {
      expect(() => AddWisherViewModel(), returnsNormally);
    });

    tearDown(() {
      viewModel.dispose();
    });
  });
}

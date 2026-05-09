import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/features/add_wisher/demo/demo_add_wisher_contact_access.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

enum AddWisherDemoScenario { success, error, loading, duplicate }

/// Sample profile picture URLs for demo wishers
const _sampleProfilePictureOne =
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200';
const _sampleProfilePictureTwo =
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200';
const _sampleProfilePictureThree =
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200';

const _sampleProfilePictures = [
  _sampleProfilePictureOne,
  _sampleProfilePictureTwo,
  _sampleProfilePictureThree,
];

List<DemoAddWisherContact> demoAddWisherContacts({
  required AddWisherDemoScenario scenario,
}) => switch (scenario) {
  AddWisherDemoScenario.error => [
    ..._baseDemoAddWisherContacts,
    const DemoAddWisherContact(
      selection: AddWisherContactSelection(
        sourceId: 'demo-contact-error',
        firstName: 'Jordan',
        lastName: 'Error',
        originalDisplayName: 'Jordan Error',
      ),
      description: 'Will fail to import',
    ),
  ],
  AddWisherDemoScenario.duplicate => [
    ..._baseDemoAddWisherContacts,
    const DemoAddWisherContact(
      selection: AddWisherContactSelection(
        sourceId: 'demo-contact-duplicate',
        firstName: 'Alice',
        lastName: 'Johnson',
        originalDisplayName: 'Alice Johnson',
      ),
      description: 'Matches an existing demo wisher',
    ),
  ],
  _ => List<DemoAddWisherContact>.of(_baseDemoAddWisherContacts),
};

final List<DemoAddWisherContact> _baseDemoAddWisherContacts = [
  DemoAddWisherContact(
    selection: AddWisherContactSelection(
      sourceId: 'demo-contact-1',
      firstName: 'Nina',
      lastName: 'Patel',
      originalDisplayName: 'Nina Patel',
      imageReference: AddWisherContactImageReference(
        identifier: 'demo:demo-contact-1',
        bytes: _demoPhotoBytes(),
        fileExtension: 'png',
      ),
    ),
    photoUrl: _sampleProfilePictureOne,
  ),
  const DemoAddWisherContact(
    selection: AddWisherContactSelection(
      sourceId: 'demo-contact-2',
      firstName: 'Marcus',
      lastName: 'Lee',
      originalDisplayName: 'Marcus Lee',
    ),
  ),
  DemoAddWisherContact(
    selection: AddWisherContactSelection(
      sourceId: 'demo-contact-3',
      firstName: 'Priya',
      lastName: 'Santos',
      originalDisplayName: 'Priya Santos',
      imageReference: AddWisherContactImageReference(
        identifier: 'demo:demo-contact-3',
        bytes: _demoPhotoBytes(),
        fileExtension: 'png',
      ),
    ),
    photoUrl: _sampleProfilePictureThree,
  ),
];

final List<Wisher> _demoScenarioWishers = [
  Wisher(
    id: '1',
    userId: 'demo-user',
    firstName: 'Alice',
    lastName: 'Johnson',
    profilePicture: _sampleProfilePictures[0],
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  ),
  Wisher(
    id: '2',
    userId: 'demo-user',
    firstName: 'Bob',
    lastName: 'Smith',
    createdAt: DateTime(2024, 1, 2),
    updatedAt: DateTime(2024, 1, 2),
  ),
  Wisher(
    id: '3',
    userId: 'demo-user',
    firstName: 'Charlie',
    lastName: 'Brown',
    profilePicture: _sampleProfilePictures[1],
    createdAt: DateTime(2024, 1, 3),
    updatedAt: DateTime(2024, 1, 3),
  ),
  Wisher(
    id: '4',
    userId: 'demo-user',
    firstName: 'Diana',
    lastName: 'Prince',
    createdAt: DateTime(2024, 1, 4),
    updatedAt: DateTime(2024, 1, 4),
  ),
  Wisher(
    id: '5',
    userId: 'demo-user',
    firstName: 'Eve',
    lastName: 'Wilson',
    profilePicture: _sampleProfilePictures[2],
    createdAt: DateTime(2024, 1, 5),
    updatedAt: DateTime(2024, 1, 5),
  ),
];

List<SingleChildWidget> getAddWisherDemoProviders({
  required AddWisherDemoScenario scenario,
}) {
  Result<Wisher>? createResult;
  Duration delay = Duration.zero;
  List<Wisher>? initialWishers;
  final contacts = demoAddWisherContacts(scenario: scenario);

  switch (scenario) {
    case AddWisherDemoScenario.success:
      createResult = Result.ok(
        Wisher(
          id: 'new-1',
          userId: 'demo-user',
          firstName: 'New',
          lastName: 'Wisher',
          profilePicture: _sampleProfilePictures[0],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      delay = const Duration(seconds: 2);
      initialWishers = List<Wisher>.of(_demoScenarioWishers);
    case AddWisherDemoScenario.error:
      createResult = Result.ok(
        Wisher(
          id: 'new-1',
          userId: 'demo-user',
          firstName: 'New',
          lastName: 'Wisher',
          profilePicture: _sampleProfilePictures[0],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      delay = const Duration(seconds: 2);
    case AddWisherDemoScenario.loading:
      createResult = null;
    case AddWisherDemoScenario.duplicate:
      createResult = Result.ok(
        Wisher(
          id: 'new-1',
          userId: 'demo-user',
          firstName: 'Alice',
          lastName: 'Johnson',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      delay = const Duration(seconds: 2);
      initialWishers = List<Wisher>.of(_demoScenarioWishers);
  }

  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) =>
          MockAuthRepository(userId: 'demo-user')
            ..login(email: 'demo@test.com', password: 'demo'),
    ),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => _DemoContactAwareWisherRepository(
        createWisherResult: createResult,
        delay: delay,
        initialWishers: initialWishers,
        failingNames: scenario == AddWisherDemoScenario.error
            ? const {'Jordan Error'}
            : const {},
      ),
    ),
    ChangeNotifierProvider<ImageRepository>(
      create: (_) => MockImageRepository(
        uploadResult:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      ),
    ),
    Provider<GlobalKey<NavigatorState>>(
      create: (_) => GlobalKey<NavigatorState>(),
    ),
    Provider<AddWisherContactAccess>(
      create: (context) => DemoAddWisherContactAccess(
        navigatorKey: context.read<GlobalKey<NavigatorState>>(),
        contacts: contacts,
      ),
    ),
  ];
}

final Uint8List _demoOverlayPhotoBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+Xr1EAAAAASUVORK5CYII=',
);

Uint8List _demoPhotoBytes() => Uint8List.fromList(_demoOverlayPhotoBytes);

class _DemoContactAwareWisherRepository extends MockWisherRepository {
  _DemoContactAwareWisherRepository({
    required this.failingNames,
    super.createWisherResult,
    super.initialWishers,
    super.delay,
  });

  final Set<String> failingNames;

  @override
  Future<Result<Wisher>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
    DateTime? birthday,
    List<String>? giftOccasions,
    List<String>? giftInterests,
  }) async {
    final fullName = [
      firstName,
      lastName,
    ].where((part) => part.trim().isNotEmpty).join(' ');

    if (failingNames.contains(fullName)) {
      await Future.delayed(delay);
      return Result.error(Exception('Failed to save wisher'));
    }

    return super.createWisher(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
      birthday: birthday,
      giftOccasions: giftOccasions,
      giftInterests: giftInterests,
    );
  }
}

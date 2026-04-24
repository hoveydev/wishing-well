import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

enum AllWishersDemoScenario {
  defaultWishers,
  noWishers,
  manyWishers,
  longNames,
  brokenImages,
  failure,
}

const _sampleProfilePictures = [
  'https://picsum.photos/id/64/200',
  'https://picsum.photos/id/65/200',
  'https://picsum.photos/id/66/200',
];

List<SingleChildWidget> getAllWishersDemoProviders({
  required AllWishersDemoScenario scenario,
}) {
  final List<Wisher> initialWishers;
  Result<void>? fetchWishersResult;

  switch (scenario) {
    case AllWishersDemoScenario.defaultWishers:
      initialWishers = [
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

    case AllWishersDemoScenario.noWishers:
      initialWishers = [];

    case AllWishersDemoScenario.manyWishers:
      initialWishers = List.generate(
        30,
        (i) => Wisher(
          id: '${i + 1}',
          userId: 'demo-user',
          firstName: 'Wisher ${i + 1}',
          lastName: 'Test',
          profilePicture: i % 3 == 0 ? _sampleProfilePictures[i % 3] : null,
          createdAt: DateTime(2024, 1, (i % 28) + 1),
          updatedAt: DateTime(2024, 1, (i % 28) + 1),
        ),
      );

    case AllWishersDemoScenario.longNames:
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'demo-user',
          firstName: 'Christopher',
          lastName: 'Alexander Pemberton',
          profilePicture: _sampleProfilePictures[0],
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
        Wisher(
          id: '2',
          userId: 'demo-user',
          firstName: 'Bartholomew',
          lastName: 'Featherstonehaugh',
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
        Wisher(
          id: '3',
          userId: 'demo-user',
          firstName: 'Maximilian',
          lastName: 'Worthington-Clarke',
          profilePicture: _sampleProfilePictures[1],
          createdAt: DateTime(2024, 1, 3),
          updatedAt: DateTime(2024, 1, 3),
        ),
      ];

    case AllWishersDemoScenario.brokenImages:
      // Wishers with invalid/broken image URLs — verifies avatar initials fallback
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'demo-user',
          firstName: 'Alice',
          lastName: 'Test',
          profilePicture:
              'https://this-domain-does-not-exist-12345.invalid/image.jpg',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
        Wisher(
          id: '2',
          userId: 'demo-user',
          firstName: 'Bob',
          lastName: 'Test',
          profilePicture: 'https://fake-broken-url-xyz.invalid/photo.png',
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
        Wisher(
          id: '3',
          userId: 'demo-user',
          firstName: 'Charlie',
          lastName: 'Test',
          // No image — always shows initials
          createdAt: DateTime(2024, 1, 3),
          updatedAt: DateTime(2024, 1, 3),
        ),
      ];

    case AllWishersDemoScenario.failure:
      // Simulates arriving at AllWishers after Home's fetch failed.
      // Repository holds no wishers and surfaces the error so the screen
      // shows the empty state.
      initialWishers = [];
      fetchWishersResult = Result.error(Exception('Failed to load wishers'));
  }

  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) =>
          MockAuthRepository(userId: 'demo-user')
            ..login(email: 'demo@test.com', password: 'demo'),
    ),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(
        initialWishers: initialWishers,
        fetchWishersResult: fetchWishersResult,
      ),
    ),
    ChangeNotifierProvider<ImageRepository>(
      create: (_) => MockImageRepository(),
    ),
  ];
}

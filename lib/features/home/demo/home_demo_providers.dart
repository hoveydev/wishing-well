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

enum HomeDemoScenario {
  noWishers,
  fewWishers,
  defaultWishers,
  manyWishers,
  brokenImages,
  longNames,
  failure,
}

/// Sample profile picture URLs for demo wishers (using picsum.photos)
const _sampleProfilePictures = [
  'https://picsum.photos/id/64/200',
  'https://picsum.photos/id/65/200',
  'https://picsum.photos/id/66/200',
  'https://picsum.photos/id/67/200',
  'https://picsum.photos/id/68/200',
];

List<SingleChildWidget> getHomeDemoProviders({
  required HomeDemoScenario scenario,
}) {
  // Configure mock repositories based on scenario
  final List<Wisher> initialWishers;
  final Result<void>? fetchWishersResult;

  switch (scenario) {
    case HomeDemoScenario.noWishers:
      initialWishers = [];
      fetchWishersResult = null;

    case HomeDemoScenario.fewWishers:
      // Mix of wishers with and without profile pictures
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Alice',
          lastName: 'Johnson',
          profilePicture: _sampleProfilePictures[0],
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
        Wisher(
          id: '2',
          userId: 'test-user',
          firstName: 'Bob',
          lastName: 'Smith',
          // No image - will show initial
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
      ];
      fetchWishersResult = null;

    case HomeDemoScenario.defaultWishers:
      // Mix of wishers with and without profile pictures
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Alice',
          lastName: 'Johnson',
          profilePicture: _sampleProfilePictures[0],
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
        Wisher(
          id: '2',
          userId: 'test-user',
          firstName: 'Bob',
          lastName: 'Smith',
          // No image - will show initial
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
        Wisher(
          id: '3',
          userId: 'test-user',
          firstName: 'Charlie',
          lastName: 'Brown',
          profilePicture: _sampleProfilePictures[1],
          createdAt: DateTime(2024, 1, 3),
          updatedAt: DateTime(2024, 1, 3),
        ),
        Wisher(
          id: '4',
          userId: 'test-user',
          firstName: 'Diana',
          lastName: 'Prince',
          // No image - will show initial
          createdAt: DateTime(2024, 1, 4),
          updatedAt: DateTime(2024, 1, 4),
        ),
        Wisher(
          id: '5',
          userId: 'test-user',
          firstName: 'Eve',
          lastName: 'Wilson',
          profilePicture: _sampleProfilePictures[2],
          createdAt: DateTime(2024, 1, 5),
          updatedAt: DateTime(2024, 1, 5),
        ),
      ];
      fetchWishersResult = null;

    case HomeDemoScenario.manyWishers:
      // Generate 50 wishers - some with images, some without
      initialWishers = List.generate(
        50,
        (i) => Wisher(
          id: '${i + 1}',
          userId: 'test-user',
          firstName: 'Wisher ${i + 1}',
          lastName: 'Test',
          // Every 3rd wisher has an image
          profilePicture: i % 3 == 0 ? _sampleProfilePictures[i % 5] : null,
          createdAt: DateTime(2024, 1, (i % 28) + 1),
          updatedAt: DateTime(2024, 1, (i % 28) + 1),
        ),
      );
      fetchWishersResult = null;

    case HomeDemoScenario.brokenImages:
      // Wishers with invalid/broken image URLs - these will 404
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Alice',
          lastName: 'Test',
          profilePicture:
              'https://this-domain-does-not-exist-12345.invalid/image.jpg',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
        Wisher(
          id: '2',
          userId: 'test-user',
          firstName: 'Bob',
          lastName: 'Test',
          profilePicture: 'https://fake-broken-url-xyz.invalid/photo.png',
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
        Wisher(
          id: '3',
          userId: 'test-user',
          firstName: 'Charlie',
          lastName: 'Test',
          // No image - will show initial (fallback for broken)
          createdAt: DateTime(2024, 1, 3),
          updatedAt: DateTime(2024, 1, 3),
        ),
      ];
      fetchWishersResult = null;

    case HomeDemoScenario.longNames:
      // Wishers with notably long names to demonstrate name truncation
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Christopher',
          lastName: 'Alexander Pemberton',
          profilePicture: _sampleProfilePictures[0],
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
        Wisher(
          id: '2',
          userId: 'test-user',
          firstName: 'Bartholomew',
          lastName: 'Featherstonehaugh',
          // No image - will show initial
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
        Wisher(
          id: '3',
          userId: 'test-user',
          firstName: 'Maximilian',
          lastName: 'Worthington-Clarke',
          profilePicture: _sampleProfilePictures[1],
          createdAt: DateTime(2024, 1, 3),
          updatedAt: DateTime(2024, 1, 3),
        ),
      ];
      fetchWishersResult = null;

    case HomeDemoScenario.failure:
      initialWishers = [];
      fetchWishersResult = Result.error(Exception('Failed to fetch wishers'));
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

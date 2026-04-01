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

enum AddWisherDemoScenario { success, error, loading }

/// Sample profile picture URLs for demo wishers
const _sampleProfilePictures = [
  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
  'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200',
];

List<SingleChildWidget> getAddWisherDemoProviders({
  required AddWisherDemoScenario scenario,
}) {
  Result<Wisher>? createResult;
  Duration delay = Duration.zero;
  List<Wisher>? initialWishers;

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
      // Add some wishers with profile pictures for the demo
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
          // No image - will show initial
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
          // No image - will show initial
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
    case AddWisherDemoScenario.error:
      createResult = Result.error(Exception('Failed to save wisher'));
      delay = const Duration(seconds: 2);
    case AddWisherDemoScenario.loading:
      createResult = null;
  }

  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) =>
          MockAuthRepository(userId: 'demo-user')
            ..login(email: 'demo@test.com', password: 'demo'),
    ),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(
        createWisherResult: createResult,
        delay: delay,
        initialWishers: initialWishers,
      ),
    ),
    ChangeNotifierProvider<ImageRepository>(
      create: (_) => MockImageRepository(
        uploadResult:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      ),
    ),
  ];
}

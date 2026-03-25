/// Standardized group naming conventions for integration tests.
///
/// Follows the same pattern as unit and widget tests in the main test suite.
abstract class IntegrationTestGroups {
  /// Tests related to app initialization and startup
  static const String initialization = 'Initialization';

  /// Tests related to user authentication flows
  static const String authentication = 'Authentication';

  /// Tests related to navigation between screens
  static const String navigation = 'Navigation';

  /// Tests related to user interactions (taps, gestures, input)
  static const String userInteraction = 'User Interaction';

  /// Tests related to data loading and display
  static const String dataLoading = 'Data Loading';

  /// Tests related to error handling and edge cases
  static const String errorHandling = 'Error Handling';

  /// Tests related to state management and persistence
  static const String stateManagement = 'State Management';

  /// Tests related to complete user journeys
  static const String userJourneys = 'User Journeys';
}

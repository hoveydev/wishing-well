import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_batch_importer.dart';
import 'package:wishing_well/utils/app_config.dart';

GoRouter addWisherDemoRouter(
  AuthRepository authRepository,
  WisherRepository wisherRepository,
  ImageRepository imageRepository,
  AddWisherContactAccess contactAccess,
  GlobalKey<NavigatorState> navigatorKey,
) => GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: Routes.addWisher.path,
  routes: [
    GoRoute(
      path: Routes.addWisher.path,
      name: Routes.addWisher.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: AddWisherLandingScreen(
          viewModel: AddWisherLandingViewModel(
            contactAccess: contactAccess,
            contactBatchImporter: AddWisherContactBatchImporter(
              authRepository: authRepository,
              wisherRepository: wisherRepository,
              imageRepository: imageRepository,
              profilePicturesBucketName: AppConfig.profilePicturesBucket,
            ),
          ),
        ),
        transitionsBuilder: slideUpWithParallaxTransition,
      ),
      routes: [
        GoRoute(
          path: Routes.addWisherDetails.path,
          name: Routes.addWisherDetails.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: AddWisherDetailsScreen(
              viewModel: AddWisherDetailsViewModel(
                wisherRepository: wisherRepository,
                authRepository: authRepository,
                imageRepository: imageRepository,
              ),
            ),
            transitionsBuilder: slideInRightTransition,
          ),
        ),
      ],
    ),
  ],
);

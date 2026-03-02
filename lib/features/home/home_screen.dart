import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/features/home/home_view_model.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.viewModel, super.key});
  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch wishers after the current build frame completes
    // to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await widget.viewModel.fetchWishers();
      if (result case Error(:final error)) {
        AppLogger.error(
          'Failed to fetch wishers on home screen init',
          context: 'HomeScreen',
          error: error,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: widget.viewModel,
    child: Consumer<HomeViewModel>(
      builder: (context, viewModel, child) => Screen(
        appBar: AppMenuBar(
          action: () => context.push(Routes.profile.path),
          type: AppMenuBarType.main,
        ),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WishersList(
            wishers: viewModel.wishers,
            isLoading: viewModel.isLoadingWishers,
            onAddWisherTap: () => context.pushNamed(Routes.addWisher.name),
          ),
        ],
      ),
    ),
  );
}

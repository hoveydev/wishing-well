import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/features/home/home_view_model.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.viewModel, super.key});
  final HomeViewModelContract viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Fetch wishers after the widget tree is fully built
    // to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWishers();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh wishers when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _fetchWishers();
    }
  }

  Future<void> _fetchWishers() async {
    final result = await widget.viewModel.fetchWishers();
    if (result case Error(:final error)) {
      AppLogger.error(
        'Failed to fetch wishers on home screen init',
        context: 'HomeScreen',
        error: error,
      );
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.viewModel,
    builder: (context, _) => Screen(
      appBar: AppMenuBar(
        action: () => widget.viewModel.tapProfile(context),
        type: AppMenuBarType.main,
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WishersList(
          wishers: widget.viewModel.wishers,
          isLoading: widget.viewModel.isLoadingWishers,
          hasError: widget.viewModel.hasWisherError,
          onAddWisherTap: () => widget.viewModel.tapAddWisher(context),
          onWisherTap: (wisher) =>
              widget.viewModel.tapWisherItem(context, wisher),
          onRetry: widget.viewModel.fetchWishers,
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';

class WisherDetailsScreen extends StatefulWidget {
  const WisherDetailsScreen({required this.viewModel, super.key});
  final WisherDetailsViewModel viewModel;

  @override
  State<WisherDetailsScreen> createState() => _WisherDetailsScreenState();
}

class _WisherDetailsScreenState extends State<WisherDetailsScreen> {
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<WisherDetailsViewModel>.value(
        value: widget.viewModel,
        child: Consumer<WisherDetailsViewModel>(
          builder: (context, viewModel, child) => Screen(
            appBar: AppMenuBar(
              action: () => context.pop(),
              type: AppMenuBarType.close,
            ),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (viewModel.isLoading)
                const CircularProgressIndicator()
              else if (viewModel.wisher != null)
                Text(
                  viewModel.wisher!.name,
                  style: Theme.of(context).textTheme.displaySmall,
                )
              else
                Text(
                  'Wisher not found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
            ],
          ),
        ),
      );
}

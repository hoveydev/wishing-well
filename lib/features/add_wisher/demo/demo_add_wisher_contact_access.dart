import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

class DemoAddWisherContact {
  const DemoAddWisherContact({
    required this.selection,
    this.photoUrl,
    this.description,
  });

  final AddWisherContactSelection selection;
  final String? photoUrl;
  final String? description;

  String get displayName => selection.summaryLabel;
}

class DemoAddWisherContactAccess extends AddWisherContactAccess {
  DemoAddWisherContactAccess({
    required GlobalKey<NavigatorState> navigatorKey,
    required List<DemoAddWisherContact> contacts,
  }) : _navigatorKey = navigatorKey,
       _contacts = List.unmodifiable(contacts),
       super(
         requestPermission: () async => true,
         pickContactId: () async => null,
         loadContact: (_) async => null,
       );

  final GlobalKey<NavigatorState> _navigatorKey;
  final List<DemoAddWisherContact> _contacts;

  @override
  Future<AddWisherContactAccessResult> selectContacts() async {
    if (_contacts.isEmpty) {
      throw AddWisherContactAccessException(
        'Demo contact picker is missing canned contacts.',
      );
    }

    final context = _navigatorKey.currentContext;
    if (context == null) {
      throw AddWisherContactAccessException(
        'Demo contact picker is unavailable.',
      );
    }

    final loading = Provider.of<StatusOverlayController>(
      context,
      listen: false,
    );
    final shouldRestoreLoading = loading.isLoading;

    if (shouldRestoreLoading) {
      loading.hide();
    }

    final selection = await showModalBottomSheet<AddWisherContactSelection>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) =>
          _DemoAddWisherContactPickerSheet(contacts: _contacts),
    );

    if (selection == null) {
      return const AddWisherContactAccessCancelled();
    }

    if (shouldRestoreLoading) {
      loading.show();
    }

    return AddWisherContactAccessSelection(selections: [selection]);
  }
}

class _DemoAddWisherContactPickerSheet extends StatelessWidget {
  const _DemoAddWisherContactPickerSheet({required this.contacts});

  final List<DemoAddWisherContact> contacts;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingStandard,
        0,
        AppSpacing.screenPaddingStandard,
        AppSpacing.screenPaddingStandard,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pick a demo contact',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.wisherSpacing),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: contacts.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.wisherSpacing),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final selection = contact.selection;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _DemoContactAvatar(contact: contact),
                  title: Text(contact.displayName),
                  subtitle: Text(
                    contact.description ??
                        (contact.photoUrl == null ? 'No photo' : 'Has photo'),
                  ),
                  onTap: () => Navigator.of(context).pop(selection),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _DemoContactAvatar extends StatelessWidget {
  const _DemoContactAvatar({required this.contact});

  final DemoAddWisherContact contact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = contact.selection.summaryLabel.trim();
    final initial = label.isEmpty ? '?' : label[0].toUpperCase();

    return CircleAvatar(
      radius: 24,
      backgroundColor: colorScheme.primaryContainer,
      backgroundImage: contact.photoUrl == null
          ? null
          : NetworkImage(contact.photoUrl!),
      child: contact.photoUrl == null
          ? Text(
              initial,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}

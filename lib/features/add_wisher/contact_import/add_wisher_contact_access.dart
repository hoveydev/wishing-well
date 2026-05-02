import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/utils/app_logger.dart';

typedef AddWisherContactsPermissionRequester = Future<bool> Function();
typedef AddWisherContactsPicker = Future<String?> Function();
typedef AddWisherContactsLoader =
    Future<contacts.Contact?> Function(String contactId);

sealed class AddWisherContactAccessResult {
  const AddWisherContactAccessResult();
}

final class AddWisherContactAccessSelection
    extends AddWisherContactAccessResult {
  AddWisherContactAccessSelection({
    required List<AddWisherContactSelection> selections,
  }) : selections = List.unmodifiable(selections);

  final List<AddWisherContactSelection> selections;

  List<AddWisherContactImportDraft> get drafts => selections
      .map((selection) => selection.toDraft())
      .toList(growable: false);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddWisherContactAccessSelection &&
          listEquals(other.selections, selections);

  @override
  int get hashCode => Object.hashAll(selections);
}

final class AddWisherContactAccessCancelled
    extends AddWisherContactAccessResult {
  const AddWisherContactAccessCancelled();
}

final class AddWisherContactAccessPermissionDenied
    extends AddWisherContactAccessResult {
  const AddWisherContactAccessPermissionDenied();
}

class AddWisherContactAccessException implements Exception {
  AddWisherContactAccessException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AddWisherContactAccessException: $message';
}

class AddWisherContactSelectionMapper {
  const AddWisherContactSelectionMapper();

  AddWisherContactSelection map(contacts.Contact contact) {
    final sourceId = contact.id?.trim() ?? '';
    if (sourceId.isEmpty) {
      throw AddWisherContactAccessException(
        'Selected contact is missing a stable source id.',
      );
    }

    final birthdayEvent = contact.events
        .where((e) => e.label.label == contacts.EventLabel.birthday)
        .firstOrNull;
    DateTime? birthdayDate;
    if (birthdayEvent != null) {
      birthdayDate = DateTime(
        birthdayEvent.year ?? DateTime.now().year,
        birthdayEvent.month,
        birthdayEvent.day,
      );
    }

    return AddWisherContactSelection.normalized(
      sourceId: sourceId,
      firstName: contact.name?.first,
      lastName: _structuredLastName(contact),
      displayName: _displayName(contact),
      imageReference: _imageReference(contact, sourceId),
      birthday: birthdayDate,
    );
  }

  String _structuredLastName(contacts.Contact contact) => [
    contact.name?.middle,
    contact.name?.last,
  ].where(_isNotBlank).map((part) => part!.trim()).join(' ');

  String _displayName(contacts.Contact contact) {
    final displayName = contact.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    return [
      contact.name?.prefix,
      contact.name?.first,
      contact.name?.middle,
      contact.name?.last,
      contact.name?.suffix,
    ].where(_isNotBlank).map((part) => part!.trim()).join(' ');
  }

  AddWisherContactImageReference? _imageReference(
    contacts.Contact contact,
    String sourceId,
  ) {
    final photoBytes = contact.photo?.fullSize ?? contact.photo?.thumbnail;
    if (photoBytes == null || photoBytes.isEmpty) return null;

    return AddWisherContactImageReference(
      identifier: 'flutter_contacts:$sourceId',
      bytes: photoBytes,
    );
  }

  bool _isNotBlank(String? value) => value != null && value.trim().isNotEmpty;
}

class AddWisherContactAccess {
  AddWisherContactAccess({
    required AddWisherContactsPermissionRequester requestPermission,
    required AddWisherContactsPicker pickContactId,
    required AddWisherContactsLoader loadContact,
    AddWisherContactSelectionMapper selectionMapper =
        const AddWisherContactSelectionMapper(),
  }) : _requestPermission = requestPermission,
       _pickContactId = pickContactId,
       _loadContact = loadContact,
       _selectionMapper = selectionMapper;

  factory AddWisherContactAccess.platform({
    AddWisherContactSelectionMapper selectionMapper =
        const AddWisherContactSelectionMapper(),
  }) => AddWisherContactAccess(
    requestPermission: () async {
      final status = await contacts.FlutterContacts.permissions.request(
        contacts.PermissionType.read,
      );
      return status == contacts.PermissionStatus.granted ||
          status == contacts.PermissionStatus.limited;
    },
    pickContactId: () => contacts.FlutterContacts.native.showPicker(),
    loadContact: (contactId) => contacts.FlutterContacts.get(
      contactId,
      properties: {
        contacts.ContactProperty.name,
        contacts.ContactProperty.photoThumbnail,
        contacts.ContactProperty.photoFullRes,
        contacts.ContactProperty.event,
      },
    ),
    selectionMapper: selectionMapper,
  );

  final AddWisherContactsPermissionRequester _requestPermission;
  final AddWisherContactsPicker _pickContactId;
  final AddWisherContactsLoader _loadContact;
  final AddWisherContactSelectionMapper _selectionMapper;

  Future<AddWisherContactAccessResult> selectContacts() async {
    const logContext = 'AddWisherContactAccess.selectContacts';

    try {
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        AppLogger.info('Contacts permission denied.', context: logContext);
        return const AddWisherContactAccessPermissionDenied();
      }

      final contactId = await _pickContactId();
      if (contactId == null || contactId.trim().isEmpty) {
        AppLogger.info('Contact picker cancelled.', context: logContext);
        return const AddWisherContactAccessCancelled();
      }

      final contact = await _loadContact(contactId.trim());
      if (contact == null) {
        throw AddWisherContactAccessException(
          'Selected contact could not be loaded.',
        );
      }

      final selection = _selectionMapper.map(contact);
      AppLogger.info(
        'Selected contact ${selection.sourceId}.',
        context: logContext,
      );
      return AddWisherContactAccessSelection(selections: [selection]);
    } on AddWisherContactAccessException {
      rethrow;
    } on Exception catch (error, stackTrace) {
      AppLogger.error(
        'Failed to access contacts: $error',
        context: logContext,
        error: error,
        stackTrace: stackTrace,
      );
      throw AddWisherContactAccessException(
        'Failed to access contacts.',
        cause: error,
      );
    }
  }
}

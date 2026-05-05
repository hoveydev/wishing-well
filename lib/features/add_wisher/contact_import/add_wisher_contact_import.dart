import 'package:flutter/foundation.dart';
import 'package:wishing_well/data/models/wisher.dart';

class AddWisherContactImageReference {
  const AddWisherContactImageReference({
    required this.identifier,
    this.bytes,
    this.fileExtension = 'jpg',
  });

  final String identifier;
  final Uint8List? bytes;
  final String fileExtension;

  bool get hasBytes => bytes != null && bytes!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddWisherContactImageReference &&
        other.identifier == identifier &&
        other.fileExtension == fileExtension &&
        listEquals(other.bytes, bytes);
  }

  @override
  int get hashCode => Object.hash(
    identifier,
    fileExtension,
    bytes == null || bytes!.isEmpty
        ? null
        : Object.hash(bytes!.length, bytes!.first, bytes!.last),
  );
}

class AddWisherContactSelection {
  const AddWisherContactSelection({
    required this.sourceId,
    required this.firstName,
    required this.lastName,
    required this.originalDisplayName,
    this.imageReference,
    this.birthday,
  });

  factory AddWisherContactSelection.normalized({
    required String sourceId,
    String? firstName,
    String? lastName,
    String? displayName,
    AddWisherContactImageReference? imageReference,
    DateTime? birthday,
  }) {
    final normalizedSourceId = sourceId.trim();
    final normalizedFirstName = firstName?.trim() ?? '';
    final normalizedLastName = lastName?.trim() ?? '';
    final normalizedDisplayName = displayName?.trim() ?? '';

    if (normalizedFirstName.isNotEmpty || normalizedLastName.isNotEmpty) {
      return AddWisherContactSelection(
        sourceId: normalizedSourceId,
        firstName: normalizedFirstName,
        lastName: normalizedLastName,
        originalDisplayName: normalizedDisplayName,
        imageReference: imageReference,
        birthday: birthday,
      );
    }

    final nameParts = normalizedDisplayName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    return AddWisherContactSelection(
      sourceId: normalizedSourceId,
      firstName: nameParts.isEmpty ? '' : nameParts.first,
      lastName: nameParts.length < 2 ? '' : nameParts.sublist(1).join(' '),
      originalDisplayName: normalizedDisplayName,
      imageReference: imageReference,
      birthday: birthday,
    );
  }

  final String sourceId;
  final String firstName;
  final String lastName;
  final String originalDisplayName;
  final AddWisherContactImageReference? imageReference;
  final DateTime? birthday;

  bool get hasName => firstName.isNotEmpty || lastName.isNotEmpty;

  String get name =>
      [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

  String get summaryLabel {
    if (name.isNotEmpty) return name;
    if (originalDisplayName.isNotEmpty) return originalDisplayName;
    return sourceId;
  }

  AddWisherContactImportDraft toDraft() => AddWisherContactImportDraft(
    sourceId: sourceId,
    firstName: firstName,
    lastName: lastName,
    sourceDisplayName: originalDisplayName,
    imageReference: imageReference,
    birthday: birthday,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddWisherContactSelection &&
        other.sourceId == sourceId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.originalDisplayName == originalDisplayName &&
        other.imageReference == imageReference &&
        other.birthday == birthday;
  }

  @override
  int get hashCode => Object.hash(
    sourceId,
    firstName,
    lastName,
    originalDisplayName,
    imageReference,
    birthday,
  );
}

class AddWisherContactImportDraft {
  const AddWisherContactImportDraft({
    required this.sourceId,
    required this.firstName,
    required this.lastName,
    required this.sourceDisplayName,
    this.imageReference,
    this.birthday,
  });

  final String sourceId;
  final String firstName;
  final String lastName;
  final String sourceDisplayName;
  final AddWisherContactImageReference? imageReference;
  final DateTime? birthday;

  bool get hasName => firstName.isNotEmpty || lastName.isNotEmpty;

  String get name =>
      [firstName, lastName].where((part) => part.isNotEmpty).join(' ');

  String get summaryLabel {
    if (name.isNotEmpty) return name;
    if (sourceDisplayName.isNotEmpty) return sourceDisplayName;
    return sourceId;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddWisherContactImportDraft &&
        other.sourceId == sourceId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.sourceDisplayName == sourceDisplayName &&
        other.imageReference == imageReference &&
        other.birthday == birthday;
  }

  @override
  int get hashCode => Object.hash(
    sourceId,
    firstName,
    lastName,
    sourceDisplayName,
    imageReference,
    birthday,
  );
}

class AddWisherContactNormalizedFullName {
  const AddWisherContactNormalizedFullName._({
    required this.firstName,
    required this.lastName,
  });

  factory AddWisherContactNormalizedFullName.fromParts({
    required String firstName,
    required String lastName,
  }) {
    final normalizedFirstName = firstName.trim().toLowerCase();
    final normalizedLastName = lastName.trim().toLowerCase();

    return AddWisherContactNormalizedFullName._(
      firstName: normalizedFirstName,
      lastName: normalizedLastName,
    );
  }

  static AddWisherContactNormalizedFullName? maybeFromParts({
    required String firstName,
    required String lastName,
  }) {
    final normalizedFirstName = firstName.trim().toLowerCase();
    final normalizedLastName = lastName.trim().toLowerCase();
    if (normalizedFirstName.isEmpty || normalizedLastName.isEmpty) {
      return null;
    }

    return AddWisherContactNormalizedFullName._(
      firstName: normalizedFirstName,
      lastName: normalizedLastName,
    );
  }

  static AddWisherContactNormalizedFullName? maybeFromDraft(
    AddWisherContactImportDraft draft,
  ) => maybeFromParts(firstName: draft.firstName, lastName: draft.lastName);

  static AddWisherContactNormalizedFullName? maybeFromWisher(Wisher wisher) =>
      maybeFromParts(firstName: wisher.firstName, lastName: wisher.lastName);

  final String firstName;
  final String lastName;

  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddWisherContactNormalizedFullName &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode => Object.hash(firstName, lastName);
}

class AddWisherContactDuplicateMatch {
  AddWisherContactDuplicateMatch({
    required this.draft,
    required List<Wisher> existingWishers,
    required this.normalizedFullName,
  }) : existingWishers = List.unmodifiable(existingWishers);

  final AddWisherContactImportDraft draft;
  final List<Wisher> existingWishers;
  final AddWisherContactNormalizedFullName normalizedFullName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddWisherContactDuplicateMatch &&
        other.draft == draft &&
        listEquals(other.existingWishers, existingWishers) &&
        other.normalizedFullName == normalizedFullName;
  }

  @override
  int get hashCode =>
      Object.hash(draft, Object.hashAll(existingWishers), normalizedFullName);
}

class AddWisherContactDuplicateReport {
  AddWisherContactDuplicateReport({
    required List<AddWisherContactDuplicateMatch> duplicates,
    required List<AddWisherContactImportDraft> nonDuplicates,
  }) : duplicates = List.unmodifiable(duplicates),
       nonDuplicates = List.unmodifiable(nonDuplicates);

  final List<AddWisherContactDuplicateMatch> duplicates;
  final List<AddWisherContactImportDraft> nonDuplicates;

  bool get hasDuplicates => duplicates.isNotEmpty;

  int get duplicateCount => duplicates.length;

  List<AddWisherContactImportDraft> get duplicateDrafts =>
      duplicates.map((duplicate) => duplicate.draft).toList(growable: false);
}

enum AddWisherContactImportResultStatus { imported, skipped, failed }

class AddWisherContactImportResultEntry {
  const AddWisherContactImportResultEntry({
    required this.draft,
    required this.status,
    this.message,
    this.createdWisherId,
  });

  final AddWisherContactImportDraft draft;
  final AddWisherContactImportResultStatus status;
  final String? message;
  final String? createdWisherId;

  bool get isImported => status == AddWisherContactImportResultStatus.imported;

  bool get isSkipped => status == AddWisherContactImportResultStatus.skipped;

  bool get isFailed => status == AddWisherContactImportResultStatus.failed;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddWisherContactImportResultEntry &&
        other.draft == draft &&
        other.status == status &&
        other.message == message &&
        other.createdWisherId == createdWisherId;
  }

  @override
  int get hashCode => Object.hash(draft, status, message, createdWisherId);
}

class AddWisherContactImportResult {
  AddWisherContactImportResult({
    required List<AddWisherContactImportResultEntry> entries,
  }) : entries = List.unmodifiable(entries);

  final List<AddWisherContactImportResultEntry> entries;

  int get totalCount => entries.length;

  int get importedCount => entries.where((entry) => entry.isImported).length;

  int get skippedCount => entries.where((entry) => entry.isSkipped).length;

  int get failedCount => entries.where((entry) => entry.isFailed).length;

  bool get hasImportedAny => importedCount > 0;

  bool get isFullSuccess => totalCount > 0 && failedCount == 0;

  bool get isPartialSuccess => hasImportedAny && failedCount > 0;

  bool get isCompleteFailure => totalCount > 0 && importedCount == 0;

  List<AddWisherContactImportResultEntry> get failedEntries =>
      entries.where((entry) => entry.isFailed).toList(growable: false);

  List<AddWisherContactImportResultEntry> get importedEntries =>
      entries.where((entry) => entry.isImported).toList(growable: false);
}

import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlayerStatsRecord extends FirestoreRecord {
  PlayerStatsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Wins" field.
  int? _wins;
  int get wins => _wins ?? 0;
  bool hasWins() => _wins != null;

  // "Losses" field.
  int? _losses;
  int get losses => _losses ?? 0;
  bool hasLosses() => _losses != null;

  // "WinPercentage" field.
  int? _winPercentage;
  int get winPercentage => _winPercentage ?? 0;
  bool hasWinPercentage() => _winPercentage != null;

  // "WinningStreak" field.
  int? _winningStreak;
  int get winningStreak => _winningStreak ?? 0;
  bool hasWinningStreak() => _winningStreak != null;

  // "UserReference" field.
  DocumentReference? _userReference;
  DocumentReference? get userReference => _userReference;
  bool hasUserReference() => _userReference != null;

  void _initializeFields() {
    _wins = castToType<int>(snapshotData['Wins']);
    _losses = castToType<int>(snapshotData['Losses']);
    _winPercentage = castToType<int>(snapshotData['WinPercentage']);
    _winningStreak = castToType<int>(snapshotData['WinningStreak']);
    _userReference = snapshotData['UserReference'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('PlayerStats');

  static Stream<PlayerStatsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlayerStatsRecord.fromSnapshot(s));

  static Future<PlayerStatsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PlayerStatsRecord.fromSnapshot(s));

  static PlayerStatsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PlayerStatsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlayerStatsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlayerStatsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlayerStatsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlayerStatsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlayerStatsRecordData({
  int? wins,
  int? losses,
  int? winPercentage,
  int? winningStreak,
  DocumentReference? userReference,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Wins': wins,
      'Losses': losses,
      'WinPercentage': winPercentage,
      'WinningStreak': winningStreak,
      'UserReference': userReference,
    }.withoutNulls,
  );

  return firestoreData;
}

class PlayerStatsRecordDocumentEquality implements Equality<PlayerStatsRecord> {
  const PlayerStatsRecordDocumentEquality();

  @override
  bool equals(PlayerStatsRecord? e1, PlayerStatsRecord? e2) {
    return e1?.wins == e2?.wins &&
        e1?.losses == e2?.losses &&
        e1?.winPercentage == e2?.winPercentage &&
        e1?.winningStreak == e2?.winningStreak &&
        e1?.userReference == e2?.userReference;
  }

  @override
  int hash(PlayerStatsRecord? e) => const ListEquality().hash([
        e?.wins,
        e?.losses,
        e?.winPercentage,
        e?.winningStreak,
        e?.userReference
      ]);

  @override
  bool isValidKey(Object? o) => o is PlayerStatsRecord;
}

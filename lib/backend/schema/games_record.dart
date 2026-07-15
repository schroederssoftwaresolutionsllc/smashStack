import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GamesRecord extends FirestoreRecord {
  GamesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "PlayerA" field.
  DocumentReference? _playerA;
  DocumentReference? get playerA => _playerA;
  bool hasPlayerA() => _playerA != null;

  // "PlayerB" field.
  DocumentReference? _playerB;
  DocumentReference? get playerB => _playerB;
  bool hasPlayerB() => _playerB != null;

  // "GameID" field.
  String? _gameID;
  String get gameID => _gameID ?? '';
  bool hasGameID() => _gameID != null;

  void _initializeFields() {
    _playerA = snapshotData['PlayerA'] as DocumentReference?;
    _playerB = snapshotData['PlayerB'] as DocumentReference?;
    _gameID = snapshotData['GameID'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Games');

  static Stream<GamesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GamesRecord.fromSnapshot(s));

  static Future<GamesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GamesRecord.fromSnapshot(s));

  static GamesRecord fromSnapshot(DocumentSnapshot snapshot) => GamesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GamesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GamesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GamesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GamesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGamesRecordData({
  DocumentReference? playerA,
  DocumentReference? playerB,
  String? gameID,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'PlayerA': playerA,
      'PlayerB': playerB,
      'GameID': gameID,
    }.withoutNulls,
  );

  return firestoreData;
}

class GamesRecordDocumentEquality implements Equality<GamesRecord> {
  const GamesRecordDocumentEquality();

  @override
  bool equals(GamesRecord? e1, GamesRecord? e2) {
    return e1?.playerA == e2?.playerA &&
        e1?.playerB == e2?.playerB &&
        e1?.gameID == e2?.gameID;
  }

  @override
  int hash(GamesRecord? e) =>
      const ListEquality().hash([e?.playerA, e?.playerB, e?.gameID]);

  @override
  bool isValidKey(Object? o) => o is GamesRecord;
}

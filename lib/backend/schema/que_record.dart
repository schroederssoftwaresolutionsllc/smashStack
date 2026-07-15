import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class QueRecord extends FirestoreRecord {
  QueRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "PlayerA" field.
  String? _playerA;
  String get playerA => _playerA ?? '';
  bool hasPlayerA() => _playerA != null;

  // "PlayerB" field.
  String? _playerB;
  String get playerB => _playerB ?? '';
  bool hasPlayerB() => _playerB != null;

  void _initializeFields() {
    _playerA = snapshotData['PlayerA'] as String?;
    _playerB = snapshotData['PlayerB'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Que');

  static Stream<QueRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => QueRecord.fromSnapshot(s));

  static Future<QueRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => QueRecord.fromSnapshot(s));

  static QueRecord fromSnapshot(DocumentSnapshot snapshot) => QueRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static QueRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      QueRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'QueRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is QueRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createQueRecordData({
  String? playerA,
  String? playerB,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'PlayerA': playerA,
      'PlayerB': playerB,
    }.withoutNulls,
  );

  return firestoreData;
}

class QueRecordDocumentEquality implements Equality<QueRecord> {
  const QueRecordDocumentEquality();

  @override
  bool equals(QueRecord? e1, QueRecord? e2) {
    return e1?.playerA == e2?.playerA && e1?.playerB == e2?.playerB;
  }

  @override
  int hash(QueRecord? e) => const ListEquality().hash([e?.playerA, e?.playerB]);

  @override
  bool isValidKey(Object? o) => o is QueRecord;
}

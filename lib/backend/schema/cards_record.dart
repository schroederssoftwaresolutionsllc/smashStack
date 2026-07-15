import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CardsRecord extends FirestoreRecord {
  CardsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Card" field.
  CardStruct? _card;
  CardStruct get card => _card ?? CardStruct();
  bool hasCard() => _card != null;

  void _initializeFields() {
    _card = snapshotData['Card'] is CardStruct
        ? snapshotData['Card']
        : CardStruct.maybeFromMap(snapshotData['Card']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Cards');

  static Stream<CardsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CardsRecord.fromSnapshot(s));

  static Future<CardsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CardsRecord.fromSnapshot(s));

  static CardsRecord fromSnapshot(DocumentSnapshot snapshot) => CardsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CardsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CardsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CardsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CardsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCardsRecordData({
  CardStruct? card,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Card': CardStruct().toMap(),
    }.withoutNulls,
  );

  // Handle nested data for "Card" field.
  addCardStructData(firestoreData, card, 'Card');

  return firestoreData;
}

class CardsRecordDocumentEquality implements Equality<CardsRecord> {
  const CardsRecordDocumentEquality();

  @override
  bool equals(CardsRecord? e1, CardsRecord? e2) {
    return e1?.card == e2?.card;
  }

  @override
  int hash(CardsRecord? e) => const ListEquality().hash([e?.card]);

  @override
  bool isValidKey(Object? o) => o is CardsRecord;
}

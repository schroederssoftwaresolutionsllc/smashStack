import 'dart:async';
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

  // Game state fields
  CardStruct? _playerACard;
  CardStruct get playerACard => _playerACard ?? CardStruct();
  bool hasPlayerACard() => _playerACard != null;

  CardStruct? _playerBCard;
  CardStruct get playerBCard => _playerBCard ?? CardStruct();
  bool hasPlayerBCard() => _playerBCard != null;

  int? _playerALife;
  int get playerALife => _playerALife ?? 20;
  bool hasPlayerALife() => _playerALife != null;

  int? _playerBLife;
  int get playerBLife => _playerBLife ?? 20;
  bool hasPlayerBLife() => _playerBLife != null;

  int? _playerAEnergy;
  int get playerAEnergy => _playerAEnergy ?? 20;
  bool hasPlayerAEnergy() => _playerAEnergy != null;

  int? _playerBEnergy;
  int get playerBEnergy => _playerBEnergy ?? 20;
  bool hasPlayerBEnergy() => _playerBEnergy != null;

  void _initializeFields() {
    _playerA = snapshotData['PlayerA'] as String?;
    _playerB = snapshotData['PlayerB'] as String?;
    _playerACard = CardStruct.maybeFromMap(snapshotData['PlayerACard']);
    _playerBCard = CardStruct.maybeFromMap(snapshotData['PlayerBCard']);
    _playerALife = castToType<int>(snapshotData['PlayerALife']);
    _playerBLife = castToType<int>(snapshotData['PlayerBLife']);
    _playerAEnergy = castToType<int>(snapshotData['PlayerAEnergy']);
    _playerBEnergy = castToType<int>(snapshotData['PlayerBEnergy']);
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
  CardStruct? playerACard,
  CardStruct? playerBCard,
  int? playerALife,
  int? playerBLife,
  int? playerAEnergy,
  int? playerBEnergy,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'PlayerA': playerA,
      'PlayerB': playerB,
      'PlayerACard': playerACard?.toMap(),
      'PlayerBCard': playerBCard?.toMap(),
      'PlayerALife': playerALife,
      'PlayerBLife': playerBLife,
      'PlayerAEnergy': playerAEnergy,
      'PlayerBEnergy': playerBEnergy,
    }.withoutNulls,
  );

  return firestoreData;
}

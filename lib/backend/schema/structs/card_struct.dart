// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CardStruct extends FFFirebaseStruct {
  CardStruct({
    int? energy,
    int? damage,
    int? prevents,
    List<String>? avoids,
    String? image,
    String? name,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _energy = energy,
        _damage = damage,
        _prevents = prevents,
        _avoids = avoids,
        _image = image,
        _name = name,
        super(firestoreUtilData);

  // "Energy" field.
  int? _energy;
  int get energy => _energy ?? 0;
  set energy(int? val) => _energy = val;

  void incrementEnergy(int amount) => energy = energy + amount;

  bool hasEnergy() => _energy != null;

  // "Damage" field.
  int? _damage;
  int get damage => _damage ?? 0;
  set damage(int? val) => _damage = val;

  void incrementDamage(int amount) => damage = damage + amount;

  bool hasDamage() => _damage != null;

  // "Prevents" field.
  int? _prevents;
  int get prevents => _prevents ?? 0;
  set prevents(int? val) => _prevents = val;

  void incrementPrevents(int amount) => prevents = prevents + amount;

  bool hasPrevents() => _prevents != null;

  // "Avoids" field.
  List<String>? _avoids;
  List<String> get avoids => _avoids ?? const [];
  set avoids(List<String>? val) => _avoids = val;

  void updateAvoids(Function(List<String>) updateFn) {
    updateFn(_avoids ??= []);
  }

  bool hasAvoids() => _avoids != null;

  // "Image" field.
  String? _image;
  String get image => _image ?? 'N/A';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  // "Name" field.
  String? _name;
  String get name => _name ?? 'N/A';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  static CardStruct fromMap(Map<String, dynamic> data) => CardStruct(
        energy: castToType<int>(data['Energy']),
        damage: castToType<int>(data['Damage']),
        prevents: castToType<int>(data['Prevents']),
        avoids: getDataList(data['Avoids']),
        image: data['Image'] as String?,
        name: data['Name'] as String?,
      );

  static CardStruct? maybeFromMap(dynamic data) =>
      data is Map ? CardStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'Energy': _energy,
        'Damage': _damage,
        'Prevents': _prevents,
        'Avoids': _avoids,
        'Image': _image,
        'Name': _name,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Energy': serializeParam(
          _energy,
          ParamType.int,
        ),
        'Damage': serializeParam(
          _damage,
          ParamType.int,
        ),
        'Prevents': serializeParam(
          _prevents,
          ParamType.int,
        ),
        'Avoids': serializeParam(
          _avoids,
          ParamType.String,
          isList: true,
        ),
        'Image': serializeParam(
          _image,
          ParamType.String,
        ),
        'Name': serializeParam(
          _name,
          ParamType.String,
        ),
      }.withoutNulls;

  static CardStruct fromSerializableMap(Map<String, dynamic> data) =>
      CardStruct(
        energy: deserializeParam(
          data['Energy'],
          ParamType.int,
          false,
        ),
        damage: deserializeParam(
          data['Damage'],
          ParamType.int,
          false,
        ),
        prevents: deserializeParam(
          data['Prevents'],
          ParamType.int,
          false,
        ),
        avoids: deserializeParam<String>(
          data['Avoids'],
          ParamType.String,
          true,
        ),
        image: deserializeParam(
          data['Image'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['Name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CardStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CardStruct &&
        energy == other.energy &&
        damage == other.damage &&
        prevents == other.prevents &&
        listEquality.equals(avoids, other.avoids) &&
        image == other.image &&
        name == other.name;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([energy, damage, prevents, avoids, image, name]);
}

CardStruct createCardStruct({
  int? energy,
  int? damage,
  int? prevents,
  String? image,
  String? name,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CardStruct(
      energy: energy,
      damage: damage,
      prevents: prevents,
      image: image,
      name: name,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CardStruct? updateCardStruct(
  CardStruct? card, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    card
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCardStructData(
  Map<String, dynamic> firestoreData,
  CardStruct? card,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (card == null) {
    return;
  }
  if (card.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && card.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final cardData = getCardFirestoreData(card, forFieldValue);
  final nestedData = cardData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = card.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCardFirestoreData(
  CardStruct? card, [
  bool forFieldValue = false,
]) {
  if (card == null) {
    return {};
  }
  final firestoreData = mapToFirestore(card.toMap());

  // Add any Firestore field values
  mapToFirestore(card.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCardListFirestoreData(
  List<CardStruct>? cards,
) =>
    cards?.map((e) => getCardFirestoreData(e, true)).toList() ?? [];

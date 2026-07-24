import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  /// The various states for the game during play.
  List<String> _GameState = [
    'Game In Progress',
    'Opponent Played',
    'User Played',
    'Calculate Results',
    'Display Results',
    'Cleanup',
    'Game Finished'
  ];
  List<String> get GameState => _GameState;
  set GameState(List<String> value) {
    _GameState = value;
  }

  void addToGameState(String value) {
    GameState.add(value);
  }

  void removeFromGameState(String value) {
    GameState.remove(value);
  }

  void removeAtIndexFromGameState(int index) {
    GameState.removeAt(index);
  }

  void updateGameStateAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    GameState[index] = updateFn(_GameState[index]);
  }

  void insertAtIndexInGameState(int index, String value) {
    GameState.insert(index, value);
  }

  int _YourLife = 20;
  int get YourLife => _YourLife;
  set YourLife(int value) {
    _YourLife = value;
  }

  int _ThierLife = 20;
  int get ThierLife => _ThierLife;
  set ThierLife(int value) {
    _ThierLife = value;
  }

  int _TheirEnergy = 20;
  int get TheirEnergy => _TheirEnergy;
  set TheirEnergy(int value) {
    _TheirEnergy = value;
  }

  bool _YourCardPlayed = false;
  bool get YourCardPlayed => _YourCardPlayed;
  set YourCardPlayed(bool value) {
    _YourCardPlayed = value;
  }

  bool _TheirCardPlayed = false;
  bool get TheirCardPlayed => _TheirCardPlayed;
  set TheirCardPlayed(bool value) {
    _TheirCardPlayed = value;
  }

  CardStruct _CardState = CardStruct.fromSerializableMap(jsonDecode(
      '{\"Energy\":\"1\",\"Damage\":\"1\",\"Avoids\":\"[]\",\"Image\":\"gs://smash-stack-7a6b6.firebasestorage.app/CardImages\",\"Name\":\"N/A\"}'));
  CardStruct get CardState => _CardState;
  set CardState(CardStruct value) {
    _CardState = value;
  }

  void updateCardStateStruct(Function(CardStruct) updateFn) {
    updateFn(_CardState);
  }

  List<CardStruct> _Library = [];
  List<CardStruct> get Library => _Library;
  set Library(List<CardStruct> value) {
    _Library = value;
  }

  void addToLibrary(CardStruct value) {
    Library.add(value);
  }

  void removeFromLibrary(CardStruct value) {
    Library.remove(value);
  }

  void removeAtIndexFromLibrary(int index) {
    Library.removeAt(index);
  }

  void updateLibraryAtIndex(
    int index,
    CardStruct Function(CardStruct) updateFn,
  ) {
    Library[index] = updateFn(_Library[index]);
  }

  void insertAtIndexInLibrary(int index, CardStruct value) {
    Library.insert(index, value);
  }

  List<CardStruct> _Hand = [];
  List<CardStruct> get Hand => _Hand;
  set Hand(List<CardStruct> value) {
    _Hand = value;
  }

  void addToHand(CardStruct value) {
    Hand.add(value);
  }

  void removeFromHand(CardStruct value) {
    Hand.remove(value);
  }

  void removeAtIndexFromHand(int index) {
    Hand.removeAt(index);
  }

  void updateHandAtIndex(
    int index,
    CardStruct Function(CardStruct) updateFn,
  ) {
    Hand[index] = updateFn(_Hand[index]);
  }

  void insertAtIndexInHand(int index, CardStruct value) {
    Hand.insert(index, value);
  }

  CardStruct _EnemyCardState = CardStruct.fromSerializableMap(jsonDecode(
      '{\"Energy\":\"0\",\"Damage\":\"0\",\"Prevents\":\"0\",\"Avoids\":\"[]\",\"Image\":\"N/A\",\"Name\":\"N/A\"}'));
  CardStruct get EnemyCardState => _EnemyCardState;
  set EnemyCardState(CardStruct value) {
    _EnemyCardState = value;
  }

  void updateEnemyCardStateStruct(Function(CardStruct) updateFn) {
    updateFn(_EnemyCardState);
  }

  List<String> _ComputerNames = [
    'Theo',
    'Matty',
    'Roxanne',
    'Indio',
    'Hanjano',
    'Kiki',
    'Atlas',
    'Nova',
    'Saffron',
    'Orion',
    'Luna'
  ];
  List<String> get ComputerNames => _ComputerNames;
  set ComputerNames(List<String> value) {
    _ComputerNames = value;
  }

  void addToComputerNames(String value) {
    ComputerNames.add(value);
  }

  void removeFromComputerNames(String value) {
    ComputerNames.remove(value);
  }

  void removeAtIndexFromComputerNames(int index) {
    ComputerNames.removeAt(index);
  }

  void updateComputerNamesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    ComputerNames[index] = updateFn(_ComputerNames[index]);
  }

  void insertAtIndexInComputerNames(int index, String value) {
    ComputerNames.insert(index, value);
  }

  String _TheirName = '';
  String get TheirName => _TheirName;
  set TheirName(String value) {
    _TheirName = value;
  }

  int _YourEnergy = 20;
  int get YourEnergy => _YourEnergy;
  set YourEnergy(int value) {
    _YourEnergy = value;
  }

  bool _GameEndedWin = false;
  bool get GameEndedWin => _GameEndedWin;
  set GameEndedWin(bool value) {
    _GameEndedWin = value;
  }

  bool _GameEnded = false;
  bool get GameEnded => _GameEnded;
  set GameEnded(bool value) {
    _GameEnded = value;
  }

  bool _TheyAvoided = false;
  bool get TheyAvoided => _TheyAvoided;
  set TheyAvoided(bool value) {
    _TheyAvoided = value;
  }

  bool _YouAvoided = false;
  bool get YouAvoided => _YouAvoided;
  set YouAvoided(bool value) {
    _YouAvoided = value;
  }

  bool _CounteredWindowActiveForYou = false;
  bool get CounteredWindowActiveForYou => _CounteredWindowActiveForYou;
  set CounteredWindowActiveForYou(bool value) {
    _CounteredWindowActiveForYou = value;
  }

  bool _CounteredWindowActiveForThem = false;
  bool get CounteredWindowActiveForThem => _CounteredWindowActiveForThem;
  set CounteredWindowActiveForThem(bool value) {
    _CounteredWindowActiveForThem = value;
  }

  // Session stats tracking
  int _SessionDamageDealt = 0;
  int get SessionDamageDealt => _SessionDamageDealt;
  set SessionDamageDealt(int value) => _SessionDamageDealt = value;

  int _SessionDamageTaken = 0;
  int get SessionDamageTaken => _SessionDamageTaken;
  set SessionDamageTaken(int value) => _SessionDamageTaken = value;

  int _SessionEnergySpent = 0;
  int get SessionEnergySpent => _SessionEnergySpent;
  set SessionEnergySpent(int value) => _SessionEnergySpent = value;

  int _SessionCardsPlayed = 0;
  int get SessionCardsPlayed => _SessionCardsPlayed;
  set SessionCardsPlayed(int value) => _SessionCardsPlayed = value;

  int _SessionEvades = 0;
  int get SessionEvades => _SessionEvades;
  set SessionEvades(int value) => _SessionEvades = value;
}

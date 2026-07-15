import '/backend/backend.dart';
import '/components/card_value_component_widget.dart';
import '/components/game_ended_display_component_widget.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'battle_zone_play_hum_widget.dart' show BattleZonePlayHumWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class BattleZonePlayHumModel extends FlutterFlowModel<BattleZonePlayHumWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Timer widget.
  final timerInitialTimeMs = 3000;
  int timerMilliseconds = 3000;
  String timerValue = StopWatchTimer.getDisplayTime(
    3000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  // Stores action output result for [Firestore Query - Query a collection] action in DragTarget widget.
  List<PlayerStatsRecord>? grabPlayerStatsDocWin;
  // Stores action output result for [Firestore Query - Query a collection] action in DragTarget widget.
  List<PlayerStatsRecord>? grabPlayerStatsDocLoss;
  // Model for CardValueComponent component.
  late CardValueComponentModel cardValueComponentModel1;
  // Model for CardValueComponent component.
  late CardValueComponentModel cardValueComponentModel2;
  // Model for GameEndedDisplayComponent component.
  late GameEndedDisplayComponentModel gameEndedDisplayComponentModel;
  // Model for CardValueComponent component.
  late CardValueComponentModel cardValueComponentModel3;
  // Model for CardValueComponent component.
  late CardValueComponentModel cardValueComponentModel4;
  // Model for CardValueComponent component.
  late CardValueComponentModel cardValueComponentModel5;
  // Model for CardValueComponent component.
  late CardValueComponentModel cardValueComponentModel6;
  // Model for CardValueComponent component.
  late CardValueComponentModel cardValueComponentModel7;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PlayerStatsRecord? grabPlayerStatsDocWinRest;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PlayerStatsRecord? grabPlayerStatsDocLossRest;
  // State field(s) for GameTimer widget.
  final gameTimerInitialTimeMs = 2000;
  int gameTimerMilliseconds = 2000;
  String gameTimerValue = StopWatchTimer.getDisplayTime(
    2000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController gameTimerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  @override
  void initState(BuildContext context) {
    cardValueComponentModel1 =
        createModel(context, () => CardValueComponentModel());
    cardValueComponentModel2 =
        createModel(context, () => CardValueComponentModel());
    gameEndedDisplayComponentModel =
        createModel(context, () => GameEndedDisplayComponentModel());
    cardValueComponentModel3 =
        createModel(context, () => CardValueComponentModel());
    cardValueComponentModel4 =
        createModel(context, () => CardValueComponentModel());
    cardValueComponentModel5 =
        createModel(context, () => CardValueComponentModel());
    cardValueComponentModel6 =
        createModel(context, () => CardValueComponentModel());
    cardValueComponentModel7 =
        createModel(context, () => CardValueComponentModel());
  }

  @override
  void dispose() {
    timerController.dispose();
    cardValueComponentModel1.dispose();
    cardValueComponentModel2.dispose();
    gameEndedDisplayComponentModel.dispose();
    cardValueComponentModel3.dispose();
    cardValueComponentModel4.dispose();
    cardValueComponentModel5.dispose();
    cardValueComponentModel6.dispose();
    cardValueComponentModel7.dispose();
    gameTimerController.dispose();
  }
}

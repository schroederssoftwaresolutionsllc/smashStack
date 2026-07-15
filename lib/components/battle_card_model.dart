import '/components/player_stat_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'battle_card_widget.dart' show BattleCardWidget;
import 'package:flutter/material.dart';

class BattleCardModel extends FlutterFlowModel<BattleCardWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for PlayerStat.
  late PlayerStatModel playerStatModel1;
  // Model for PlayerStat.
  late PlayerStatModel playerStatModel2;

  @override
  void initState(BuildContext context) {
    playerStatModel1 = createModel(context, () => PlayerStatModel());
    playerStatModel2 = createModel(context, () => PlayerStatModel());
  }

  @override
  void dispose() {
    playerStatModel1.dispose();
    playerStatModel2.dispose();
  }
}

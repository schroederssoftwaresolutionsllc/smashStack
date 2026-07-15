import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'loading_page_widget.dart' show LoadingPageWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class LoadingPageModel extends FlutterFlowModel<LoadingPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in LoadingPage widget.
  List<CardsRecord>? getCardsCollection;
  // State field(s) for LoadingTimer widget.
  final loadingTimerInitialTimeMs = 3000;
  int loadingTimerMilliseconds = 3000;
  String loadingTimerValue = StopWatchTimer.getDisplayTime(
    3000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController loadingTimerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    loadingTimerController.dispose();
  }
}

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'que_page_widget.dart' show QuePageWidget;
import 'package:flutter/material.dart';

class QuePageModel extends FlutterFlowModel<QuePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in QuePage widget.
  QueRecord? grabFirstQueDoc;
  // Stores action output result for [Backend Call - Create Document] action in QuePage widget.
  QueRecord? generateNewQueDoc;
  InstantTimer? newInstantTimer;
  DateTime? pairWaitStartTime;
  // Stores action output result for [Backend Call - Read Document] action in QuePage widget.
  QueRecord? readingNewQueDoc;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    newInstantTimer?.cancel();
  }
}

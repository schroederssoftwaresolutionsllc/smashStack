import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/blank_component_widget.dart';
import '/components/card_value_component_widget.dart';
import '/components/game_ended_display_component_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'battle_zone_play_comp_model.dart';
export 'battle_zone_play_comp_model.dart';

class BattleZonePlayCompWidget extends StatefulWidget {
  const BattleZonePlayCompWidget({super.key});

  static String routeName = 'BattleZonePlayComp';
  static String routePath = '/battleZonePlayComp';

  @override
  State<BattleZonePlayCompWidget> createState() =>
      _BattleZonePlayCompWidgetState();
}

class _BattleZonePlayCompWidgetState extends State<BattleZonePlayCompWidget>
    with TickerProviderStateMixin {
  late BattleZonePlayCompModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BattleZonePlayCompModel());

    animationsMap.addAll({
      'stackOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeIn,
            delay: 0.0.ms,
            duration: 1230.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Smash Stack',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.raleway(
                        fontWeight: FontWeight.bold,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).tertiary,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
            ],
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 120.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 45.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1A1A2E),
                                    Color(0xFF16213E)
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, -1.0),
                                  end: AlignmentDirectional(-1.0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 45.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1A1A2E),
                                    Color(0xFF16213E)
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, -1.0),
                                  end: AlignmentDirectional(-1.0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 45.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1A1A2E),
                                    Color(0xFF16213E)
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, -1.0),
                                  end: AlignmentDirectional(-1.0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 45.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1A1A2E),
                                    Color(0xFF16213E)
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, -1.0),
                                  end: AlignmentDirectional(-1.0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 45.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1A1A2E),
                                    Color(0xFF16213E)
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, -1.0),
                                  end: AlignmentDirectional(-1.0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context).primary,
                              FlutterFlowTheme.of(context).secondary
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      valueOrDefault<String>(
                                        FFAppState().TheirName,
                                        'N/A',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          25.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.favorite,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 20.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          FFAppState().ThierLife.toString(),
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.robotoCondensed(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          25.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.bolt,
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          FFAppState().TheirEnergy.toString(),
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.robotoCondensed(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: FlutterFlowTimer(
                                          initialTime:
                                              _model.timerInitialTimeMs,
                                          getDisplayTime: (value) =>
                                              StopWatchTimer.getDisplayTime(
                                            value,
                                            hours: false,
                                            milliSecond: false,
                                          ),
                                          controller: _model.timerController,
                                          updateStateInterval:
                                              Duration(milliseconds: 200),
                                          onChanged: (value, displayTime,
                                              shouldUpdate) {
                                            _model.timerMilliseconds = value;
                                            _model.timerValue = displayTime;
                                            if (shouldUpdate)
                                              safeSetState(() {});
                                          },
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                font: GoogleFonts.raleway(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.transparent,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  if (!FFAppState().GameEnded) {
                                    return Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: DragTarget<CardStruct>(
                                        onAcceptWithDetails: (details) async {
                                          // Play Your Card
                                          FFAppState().YourCardPlayed = true;
                                          FFAppState().TheirCardPlayed = true;
                                          if (FFAppState().TheirEnergy <= 4) {
                                            // Play Opponent Rest Card
                                            FFAppState().EnemyCardState =
                                                CardStruct(
                                              energy: -4,
                                              damage: 0,
                                              prevents: 0,
                                              avoids: ['N/A'],
                                              image: 'N/A',
                                              name: 'Forced Rest',
                                            );
                                            safeSetState(() {});
                                          } else {
                                            // Play Opponent Random Card
                                            FFAppState().EnemyCardState =
                                                FFAppState()
                                                    .Library
                                                    .elementAtOrNull(
                                                        valueOrDefault<int>(
                                                      random_data.randomInteger(
                                                          0,
                                                          valueOrDefault<int>(
                                                            FFAppState()
                                                                .Library
                                                                .length,
                                                            0,
                                                          )),
                                                      0,
                                                    ))!;
                                            safeSetState(() {});
                                          }

                                          if (FFAppState()
                                                  .CardState
                                                  .avoids
                                                  .contains(
                                                      valueOrDefault<String>(
                                                    FFAppState()
                                                        .EnemyCardState
                                                        .name,
                                                    'N/A',
                                                  )) ||
                                              FFAppState()
                                                  .EnemyCardState
                                                  .avoids
                                                  .contains(
                                                      valueOrDefault<String>(
                                                    FFAppState().CardState.name,
                                                    'N/A',
                                                  ))) {
                                            if (FFAppState()
                                                    .CardState
                                                    .avoids
                                                    .contains(
                                                        valueOrDefault<String>(
                                                      FFAppState()
                                                          .EnemyCardState
                                                          .name,
                                                      'N/A',
                                                    )) ==
                                                true) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Attack Avoided!'),
                                                    content: Text(
                                                        'You successfully avoided their attack! '),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              FFAppState().EnemyCardState =
                                                  CardStruct(
                                                energy: 4,
                                                name: 'Avoided',
                                                damage: 0,
                                                prevents: 0,
                                                avoids: ['N/A'],
                                                image: 'N/A',
                                              );
                                              safeSetState(() {});
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Attack Avoided!'),
                                                    content: Text(
                                                        'They successfully avoided your attack!'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              FFAppState().CardState =
                                                  CardStruct(
                                                energy: 4,
                                                damage: 0,
                                                prevents: 0,
                                                avoids: ['N/A'],
                                                image: 'N/A',
                                                name: 'Avoided!',
                                              );
                                              safeSetState(() {});
                                            }
                                          }
                                          // Calculate Life and Energy Changes
                                          FFAppState().YourLife =
                                              valueOrDefault<int>(
                                            functions.subtraction(
                                                FFAppState().YourLife,
                                                valueOrDefault<int>(
                                                  FFAppState()
                                                      .EnemyCardState
                                                      .damage,
                                                  0,
                                                )),
                                            0,
                                          );
                                          FFAppState().ThierLife =
                                              valueOrDefault<int>(
                                            functions.subtraction(
                                                FFAppState().ThierLife,
                                                valueOrDefault<int>(
                                                  FFAppState().CardState.damage,
                                                  0,
                                                )),
                                            0,
                                          );
                                          FFAppState().TheirEnergy =
                                              valueOrDefault<int>(
                                            functions.subtraction(
                                                FFAppState().TheirEnergy,
                                                valueOrDefault<int>(
                                                  FFAppState()
                                                      .EnemyCardState
                                                      .energy,
                                                  0,
                                                )),
                                            0,
                                          );
                                          FFAppState().YourEnergy =
                                              functions.subtraction(
                                                  FFAppState().YourEnergy,
                                                  valueOrDefault<int>(
                                                    FFAppState()
                                                        .CardState
                                                        .energy,
                                                    0,
                                                  ))!;
                                          safeSetState(() {});
                                          if ((FFAppState().YourLife <= 0) ||
                                              (FFAppState().ThierLife <= 0)) {
                                            // Set Game Ended State
                                            FFAppState().GameEnded = true;
                                            safeSetState(() {});
                                            if (FFAppState().ThierLife <= 0) {
                                              // You won - set state
                                              FFAppState().GameEndedWin = true;
                                              safeSetState(() {});
                                              _model.grabPlayerStatsDocWin =
                                                  await queryPlayerStatsRecordOnce(
                                                queryBuilder:
                                                    (playerStatsRecord) =>
                                                        playerStatsRecord.where(
                                                  'UserReference',
                                                  isEqualTo:
                                                      currentUserReference,
                                                ),
                                              );

                                              await _model
                                                  .grabPlayerStatsDocWin!
                                                  .firstOrNull!
                                                  .reference
                                                  .update({
                                                ...mapToFirestore(
                                                  {
                                                    'Wins':
                                                        FieldValue.increment(1),
                                                  },
                                                ),
                                              });
                                            } else {
                                              // You Lost - set state
                                              FFAppState().GameEndedWin = false;
                                              safeSetState(() {});
                                              _model.grabPlayerStatsDocLoss =
                                                  await queryPlayerStatsRecordOnce(
                                                queryBuilder:
                                                    (playerStatsRecord) =>
                                                        playerStatsRecord.where(
                                                  'UserReference',
                                                  isEqualTo:
                                                      currentUserReference,
                                                ),
                                                limit: 1,
                                              );

                                              await _model
                                                  .grabPlayerStatsDocLoss!
                                                  .firstOrNull!
                                                  .reference
                                                  .update({
                                                ...mapToFirestore(
                                                  {
                                                    'Losses':
                                                        FieldValue.increment(1),
                                                  },
                                                ),
                                              });
                                            }
                                          }
                                          // Timer reset for round or match
                                          _model.gameTimerController
                                              .onStartTimer();

                                          safeSetState(() {});
                                        },
                                        onWillAcceptWithDetails: (details) {
                                          (() async {
                                            if (FFAppState().YourEnergy <
                                                valueOrDefault<int>(
                                                  FFAppState().CardState.energy,
                                                  0,
                                                )) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Need Energy'),
                                                    content: Text(
                                                        'You dont have enough Energy for that!'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              safeSetState(() {});
                                              return;
                                            }

                                            safeSetState(() {});
                                          })();
                                          return true;
                                        },
                                        builder: (context, _, __) {
                                          return Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 80.0,
                                                  height: 110.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 8.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        offset: Offset(
                                                          0.0,
                                                          4.0,
                                                        ),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                  child: Builder(
                                                    builder: (context) {
                                                      if (FFAppState()
                                                          .YourCardPlayed) {
                                                        return wrapWithModel(
                                                          model: _model
                                                              .cardValueComponentModel1,
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child:
                                                              CardValueComponentWidget(
                                                            componentCard:
                                                                FFAppState()
                                                                    .CardState,
                                                          ),
                                                        );
                                                      } else {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  width: 80.0,
                                                  height: 110.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 8.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        offset: Offset(
                                                          0.0,
                                                          4.0,
                                                        ),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                  child: Builder(
                                                    builder: (context) {
                                                      if (FFAppState()
                                                          .TheirCardPlayed) {
                                                        return wrapWithModel(
                                                          model: _model
                                                              .cardValueComponentModel2,
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child:
                                                              CardValueComponentWidget(
                                                            componentCard:
                                                                FFAppState()
                                                                    .EnemyCardState,
                                                          ),
                                                        );
                                                      } else {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return wrapWithModel(
                                      model:
                                          _model.gameEndedDisplayComponentModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: GameEndedDisplayComponentWidget(),
                                    );
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: AuthUserStreamWidget(
                                        builder: (context) => Container(
                                          width: 50.0,
                                          height: 50.0,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(
                                            currentUserPhoto,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => AutoSizeText(
                                              currentUserDisplayName,
                                              maxLines: 1,
                                              minFontSize: 5.0,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    font: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleMedium
                                                            .fontStyle,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.favorite,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 20.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          FFAppState().YourLife.toString(),
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.robotoCondensed(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          25.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.bolt,
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 0.0, 30.0, 0.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          FFAppState().YourEnergy.toString(),
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.robotoCondensed(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 140.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Draggable<CardStruct>(
                                    data: FFAppState().Hand.elementAtOrNull(0)!,
                                    onDragStarted: () async {
                                      FFAppState().CardState =
                                          FFAppState().Hand.elementAtOrNull(0)!;
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                    feedback: Material(
                                      type: MaterialType.transparency,
                                      child: wrapWithModel(
                                        model: _model.cardValueComponentModel3,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CardValueComponentWidget(
                                          componentCard: FFAppState()
                                              .Hand
                                              .elementAtOrNull(0)!,
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: BlankComponentWidget(),
                                    child: wrapWithModel(
                                      model: _model.cardValueComponentModel3,
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardValueComponentWidget(
                                        componentCard: FFAppState()
                                            .Hand
                                            .elementAtOrNull(0)!,
                                      ),
                                    ),
                                  ),
                                  Draggable<CardStruct>(
                                    data: FFAppState().Hand.elementAtOrNull(1)!,
                                    onDragStarted: () async {
                                      FFAppState().CardState =
                                          FFAppState().Hand.elementAtOrNull(1)!;
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                    feedback: Material(
                                      type: MaterialType.transparency,
                                      child: wrapWithModel(
                                        model: _model.cardValueComponentModel4,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CardValueComponentWidget(
                                          componentCard: FFAppState()
                                              .Hand
                                              .elementAtOrNull(1)!,
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: BlankComponentWidget(),
                                    child: wrapWithModel(
                                      model: _model.cardValueComponentModel4,
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardValueComponentWidget(
                                        componentCard: FFAppState()
                                            .Hand
                                            .elementAtOrNull(1)!,
                                      ),
                                    ),
                                  ),
                                  Draggable<CardStruct>(
                                    data: FFAppState().Hand.elementAtOrNull(2)!,
                                    onDragStarted: () async {
                                      FFAppState().CardState =
                                          FFAppState().Hand.elementAtOrNull(2)!;
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                    feedback: Material(
                                      type: MaterialType.transparency,
                                      child: wrapWithModel(
                                        model: _model.cardValueComponentModel5,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CardValueComponentWidget(
                                          componentCard: FFAppState()
                                              .Hand
                                              .elementAtOrNull(2)!,
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: BlankComponentWidget(),
                                    child: wrapWithModel(
                                      model: _model.cardValueComponentModel5,
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardValueComponentWidget(
                                        componentCard: FFAppState()
                                            .Hand
                                            .elementAtOrNull(2)!,
                                      ),
                                    ),
                                  ),
                                  Draggable<CardStruct>(
                                    data: FFAppState().Hand.elementAtOrNull(3)!,
                                    onDragStarted: () async {
                                      FFAppState().CardState =
                                          FFAppState().Hand.elementAtOrNull(3)!;
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                    feedback: Material(
                                      type: MaterialType.transparency,
                                      child: wrapWithModel(
                                        model: _model.cardValueComponentModel6,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CardValueComponentWidget(
                                          componentCard: FFAppState()
                                              .Hand
                                              .elementAtOrNull(3)!,
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: BlankComponentWidget(),
                                    child: wrapWithModel(
                                      model: _model.cardValueComponentModel6,
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardValueComponentWidget(
                                        componentCard: FFAppState()
                                            .Hand
                                            .elementAtOrNull(3)!,
                                      ),
                                    ),
                                  ),
                                  Draggable<CardStruct>(
                                    data: FFAppState().Hand.elementAtOrNull(4)!,
                                    onDragStarted: () async {
                                      FFAppState().CardState =
                                          FFAppState().Hand.elementAtOrNull(4)!;
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                    feedback: Material(
                                      type: MaterialType.transparency,
                                      child: wrapWithModel(
                                        model: _model.cardValueComponentModel7,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: CardValueComponentWidget(
                                          componentCard: FFAppState()
                                              .Hand
                                              .elementAtOrNull(4)!,
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: BlankComponentWidget(),
                                    child: wrapWithModel(
                                      model: _model.cardValueComponentModel7,
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardValueComponentWidget(
                                        componentCard: FFAppState()
                                            .Hand
                                            .elementAtOrNull(4)!,
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(6.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                // Play Your Card
                                FFAppState().YourCardPlayed = true;
                                FFAppState().TheirCardPlayed = true;
                                if (FFAppState().TheirEnergy <= 4) {
                                  // Play Opponent Rest Card
                                  FFAppState().EnemyCardState = CardStruct(
                                    energy: -4,
                                    damage: 0,
                                    prevents: 0,
                                    avoids: ['N/A'],
                                    image: 'N/A',
                                    name: 'Forced Rest',
                                  );
                                  safeSetState(() {});
                                } else {
                                  // Play Opponent Random Card
                                  FFAppState().EnemyCardState = FFAppState()
                                      .Library
                                      .elementAtOrNull(valueOrDefault<int>(
                                        random_data.randomInteger(
                                            0,
                                            valueOrDefault<int>(
                                              FFAppState().Library.length,
                                              0,
                                            )),
                                        0,
                                      ))!;
                                  safeSetState(() {});
                                }

                                // Set Card Played to Rest
                                FFAppState().CardState = CardStruct(
                                  energy: 4,
                                  damage: 0,
                                  prevents: 0,
                                  avoids: ['N/A'],
                                  image: 'N/A',
                                  name: 'Rest',
                                );
                                FFAppState().YourEnergy =
                                    FFAppState().YourEnergy + 4;
                                safeSetState(() {});
                                // Calculate Life and Energy Changes
                                FFAppState().YourLife = valueOrDefault<int>(
                                  functions.subtraction(
                                      FFAppState().YourLife,
                                      valueOrDefault<int>(
                                        FFAppState().EnemyCardState.damage,
                                        0,
                                      )),
                                  0,
                                );
                                FFAppState().TheirEnergy = valueOrDefault<int>(
                                  functions.subtraction(
                                      FFAppState().TheirEnergy,
                                      valueOrDefault<int>(
                                        FFAppState().EnemyCardState.energy,
                                        0,
                                      )),
                                  0,
                                );
                                safeSetState(() {});
                                if ((FFAppState().YourLife <= 0) ||
                                    (FFAppState().ThierLife <= 0)) {
                                  // Set Game Ended State
                                  FFAppState().GameEnded = true;
                                  safeSetState(() {});
                                  if (FFAppState().ThierLife <= 0) {
                                    // You won - set state
                                    FFAppState().GameEndedWin = true;
                                    safeSetState(() {});
                                    _model.grabPlayerStatsDocWinRest =
                                        await queryPlayerStatsRecordOnce(
                                      queryBuilder: (playerStatsRecord) =>
                                          playerStatsRecord.where(
                                        'UserReference',
                                        isEqualTo: currentUserReference,
                                      ),
                                      singleRecord: true,
                                    ).then((s) => s.firstOrNull);

                                    await _model
                                        .grabPlayerStatsDocWinRest!.reference
                                        .update({
                                      ...mapToFirestore(
                                        {
                                          'Wins': FieldValue.increment(1),
                                        },
                                      ),
                                    });
                                  } else {
                                    // You Lost - set state
                                    FFAppState().GameEndedWin = false;
                                    safeSetState(() {});
                                    _model.grabPlayerStatsDocLossRest =
                                        await queryPlayerStatsRecordOnce(
                                      queryBuilder: (playerStatsRecord) =>
                                          playerStatsRecord.where(
                                        'UserReference',
                                        isEqualTo: currentUserReference,
                                      ),
                                      singleRecord: true,
                                    ).then((s) => s.firstOrNull);

                                    await _model
                                        .grabPlayerStatsDocLossRest!.reference
                                        .update({
                                      ...mapToFirestore(
                                        {
                                          'Losses': FieldValue.increment(1),
                                        },
                                      ),
                                    });
                                  }
                                }
                                // Timer reset for round or match
                                _model.gameTimerController.onStartTimer();

                                safeSetState(() {});
                              },
                              text: 'Rest',
                              options: FFButtonOptions(
                                width: MediaQuery.sizeOf(context).width * 0.2,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.05,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.raleway(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FlutterFlowTimer(
                  initialTime: _model.gameTimerInitialTimeMs,
                  getDisplayTime: (value) => StopWatchTimer.getDisplayTime(
                    value,
                    hours: false,
                    milliSecond: false,
                  ),
                  controller: _model.gameTimerController,
                  updateStateInterval: Duration(milliseconds: 100),
                  onChanged: (value, displayTime, shouldUpdate) {
                    _model.gameTimerMilliseconds = value;
                    _model.gameTimerValue = displayTime;
                    if (shouldUpdate) safeSetState(() {});
                  },
                  onEnded: () async {
                    if (FFAppState().GameEnded == true) {
                      context.pushNamed(
                        LandingPageWidget.routeName,
                        extra: <String, dynamic>{
                          '__transition_info__': TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 2000),
                          ),
                        },
                      );
                    } else {
                      // Reset Cards Played
                      FFAppState().YourCardPlayed = false;
                      FFAppState().TheirCardPlayed = false;
                      safeSetState(() {});
                      // Reset the clock
                      _model.gameTimerController.onResetTimer();
                    }
                  },
                  textAlign: TextAlign.start,
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.raleway(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontStyle,
                        ),
                        color: Colors.black,
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontStyle,
                      ),
                ),
              ],
            ),
          ).animateOnPageLoad(animationsMap['stackOnPageLoadAnimation']!),
        ),
      ),
    );
  }
}

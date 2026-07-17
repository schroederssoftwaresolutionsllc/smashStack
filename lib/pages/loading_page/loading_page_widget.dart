import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'loading_page_model.dart';
export 'loading_page_model.dart';

/// Create a loading page that has this apps logo with text that says loading
/// with three dots that flicker.
///
/// Make the loading page theme match the current apps theme.
class LoadingPageWidget extends StatefulWidget {
  const LoadingPageWidget({super.key});

  static String routeName = 'LoadingPage';
  static String routePath = '/loadingPage';

  @override
  State<LoadingPageWidget> createState() => _LoadingPageWidgetState();
}

class _LoadingPageWidgetState extends State<LoadingPageWidget>
    with TickerProviderStateMixin {
  late LoadingPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadingPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Reset state for new game
      FFAppState().Library = [];
      FFAppState().Hand = [];
      FFAppState().YourCardPlayed = false;
      FFAppState().TheirCardPlayed = false;
      FFAppState().GameEnded = false;
      FFAppState().GameEndedWin = false;
      
      // Reset Session Stats
      FFAppState().SessionDamageDealt = 0;
      FFAppState().SessionDamageTaken = 0;
      FFAppState().SessionEnergySpent = 0;
      FFAppState().SessionCardsPlayed = 0;
      FFAppState().SessionEvades = 0;

      // Get Cards from Firestore
      final cardsCollection = await queryCardsRecordOnce();
      _model.getCardsCollection = cardsCollection;
      
      if (cardsCollection.isNotEmpty) {
        for (final cardRecord in cardsCollection) {
          FFAppState().addToLibrary(CardStruct(
            energy: cardRecord.card.energy,
            damage: cardRecord.card.damage,
            prevents: cardRecord.card.prevents,
            avoids: cardRecord.card.avoids.take(5).toList(),
            image: cardRecord.card.image,
            name: cardRecord.card.name,
          ));
        }
      }

      if (FFAppState().Library.isNotEmpty) {
        for (int i = 0; i < 5; i++) {
          final randomIndex = random_data.randomInteger(0, FFAppState().Library.length - 1);
          final randomCard = FFAppState().Library.elementAtOrNull(randomIndex);
          if (randomCard != null) {
            FFAppState().addToHand(randomCard);
          }
        }
      }

      // Set Game Initial State
      FFAppState().YourLife = 20;
      FFAppState().ThierLife = 20;
      FFAppState().TheirEnergy = 20;
      FFAppState().YourEnergy = 20;
      
      if (FFAppState().ComputerNames.isNotEmpty) {
        final nameIndex = random_data.randomInteger(0, FFAppState().ComputerNames.length - 1);
        FFAppState().TheirName = FFAppState().ComputerNames.elementAt(nameIndex);
      } else {
        FFAppState().TheirName = "Computer";
      }

      FFAppState().GameEnded = false;
      FFAppState().GameEndedWin = false;
      safeSetState(() {});
      _model.loadingTimerController.onStartTimer();
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 250.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 500.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOutQuint,
            delay: 750.0.ms,
            duration: 500.0.ms,
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
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterFlowTimer(
                  initialTime: _model.loadingTimerInitialTimeMs,
                  getDisplayTime: (value) => StopWatchTimer.getDisplayTime(
                    value,
                    hours: false,
                    milliSecond: false,
                  ),
                  controller: _model.loadingTimerController,
                  updateStateInterval: Duration(milliseconds: 500),
                  onChanged: (value, displayTime, shouldUpdate) {
                    _model.loadingTimerMilliseconds = value;
                    _model.loadingTimerValue = displayTime;
                    if (shouldUpdate) safeSetState(() {});
                  },
                  onEnded: () async {
                    context.pushNamed(BattleZonePlayCompWidget.routeName);
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
                        color: Colors.transparent,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/app_launcher_icon.png',
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              height: MediaQuery.sizeOf(context).width * 0.4,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Loading',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    font: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .fontStyle,
                                    ),
                                    color:
                                        FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .fontStyle,
                                  ),
                            ),
                            Container(
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                shape: BoxShape.circle,
                              ),
                            ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation1']!),
                            Opacity(
                              opacity: 0.5,
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  shape: BoxShape.circle,
                                ),
                              ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation2']!),
                            ),
                            Opacity(
                              opacity: 0.3,
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  shape: BoxShape.circle,
                                ),
                              ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation3']!),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

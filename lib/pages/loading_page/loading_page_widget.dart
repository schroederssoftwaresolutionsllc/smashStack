import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
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
      // Get Cards from Firestore
      _model.getCardsCollection = await queryCardsRecordOnce();
      for (int loop1Index = 0;
          loop1Index < _model.getCardsCollection!.length;
          loop1Index++) {
        final currentLoop1Item = _model.getCardsCollection![loop1Index];
        // Get Cards For Lib
        FFAppState().addToLibrary(CardStruct(
          energy: currentLoop1Item.card.energy,
          damage: valueOrDefault<int>(
            currentLoop1Item.card.damage,
            0,
          ),
          prevents: valueOrDefault<int>(
            currentLoop1Item.card.prevents,
            0,
          ),
          avoids: currentLoop1Item.card.avoids.take(5).toList(),
          image: valueOrDefault<String>(
            currentLoop1Item.card.image,
            'N/A',
          ),
          name: valueOrDefault<String>(
            currentLoop1Item.card.name,
            'N/A',
          ),
        ));
        safeSetState(() {});
      }
      for (int loop2Index = 0;
          loop2Index < FFAppState().Library.length;
          loop2Index++) {
        final currentLoop2Item = FFAppState().Library[loop2Index];
        if (FFAppState().Hand.length <= 4) {
          // Add 5 Random Cards to Hand
          FFAppState().addToHand(
              FFAppState().Library.elementAtOrNull(valueOrDefault<int>(
                    random_data.randomInteger(
                        0,
                        functions.subtraction(
                            valueOrDefault<int>(
                              FFAppState().Library.length,
                              0,
                            ),
                            1)!),
                    0,
                  ))!);
          safeSetState(() {});
        }
      }
      // Set Game Initial State
      FFAppState().YourLife = 20;
      FFAppState().ThierLife = 20;
      FFAppState().TheirEnergy = 20;
      FFAppState().YourEnergy = 20;
      FFAppState().TheirName =
          FFAppState().ComputerNames.elementAtOrNull(valueOrDefault<int>(
                random_data.randomInteger(
                    0,
                    valueOrDefault<int>(
                      FFAppState().ComputerNames.length,
                      0,
                    )),
                0,
              ))!;
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
                  context.pushNamed(
                    BattleZonePlayCompWidget.routeName,
                    extra: <String, dynamic>{
                      '__transition_info__': TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.fade,
                        duration: Duration(milliseconds: 2000),
                      ),
                    },
                  );
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
                            'assets/images/SMash_Stack_PNG_FROM_SVG.png',
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            height: MediaQuery.sizeOf(context).height * 0.5,
                            fit: BoxFit.cover,
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
    );
  }
}

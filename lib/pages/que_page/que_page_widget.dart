import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:async';
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'que_page_model.dart';
export 'que_page_model.dart';

class QuePageWidget extends StatefulWidget {
  const QuePageWidget({super.key});

  static String routeName = 'QuePage';
  static String routePath = '/quePage';

  @override
  State<QuePageWidget> createState() => _QuePageWidgetState();
}

class _QuePageWidgetState extends State<QuePageWidget>
    with TickerProviderStateMixin {
  late QuePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QuePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.grabFirstQueDoc = await queryQueRecordOnce(
        queryBuilder: (queRecord) => queRecord.where(Filter.or(
          Filter(
            'PlayerA',
            isEqualTo: '',
          ),
          Filter(
            'PlayerB',
            isEqualTo: '',
          ),
        )),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if ((_model.grabFirstQueDoc != null) == true) {
        if (_model.grabFirstQueDoc?.playerA != null &&
            _model.grabFirstQueDoc?.playerA != '') {
          await _model.grabFirstQueDoc!.reference.update(createQueRecordData(
            playerB: currentUserUid,
          ));
        } else {
          await _model.grabFirstQueDoc!.reference.update(createQueRecordData(
            playerA: currentUserUid,
          ));
        }

        context.pushNamed(
          BattleZonePlayHumWidget.routeName,
          extra: {
            'matchRef': _model.grabFirstQueDoc?.reference,
          },
        );
      } else {
        var queRecordReference1 = QueRecord.collection.doc();
        await queRecordReference1.set(createQueRecordData(
          playerA: currentUserUid,
          playerB: '',
        ));
        _model.generateNewQueDoc = QueRecord.getDocumentFromData(
            createQueRecordData(
              playerA: currentUserUid,
              playerB: '',
            ),
            queRecordReference1);
        _model.newInstantTimer = InstantTimer.periodic(
          duration: Duration(milliseconds: 5000),
          callback: (timer) async {
            unawaited(
              () async {
                _model.readingNewQueDoc = await QueRecord.getDocumentOnce(
                    _model.generateNewQueDoc!.reference);
              }(),
            );
            if ((_model.readingNewQueDoc?.playerA != null &&
                    _model.readingNewQueDoc?.playerA != '') &&
                (_model.readingNewQueDoc?.playerB != null &&
                    _model.readingNewQueDoc?.playerB != '')) {
              _model.newInstantTimer?.cancel();

              context.pushNamed(
                BattleZonePlayHumWidget.routeName,
                extra: {
                  'matchRef': _model.generateNewQueDoc?.reference,
                },
              );
            }
          },
          startImmediately: true,
        );
      }
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
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            'Pairing',
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

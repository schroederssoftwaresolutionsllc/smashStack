import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/game_logic.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'game_ended_display_component_model.dart';
export 'game_ended_display_component_model.dart';

class GameEndedDisplayComponentWidget extends StatefulWidget {
  const GameEndedDisplayComponentWidget({super.key});

  @override
  State<GameEndedDisplayComponentWidget> createState() =>
      _GameEndedDisplayComponentWidgetState();
}

class _GameEndedDisplayComponentWidgetState
    extends State<GameEndedDisplayComponentWidget>
    with TickerProviderStateMixin {
  late GameEndedDisplayComponentModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameEndedDisplayComponentModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1220.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1220.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.9,
          maxWidth: MediaQuery.of(context).size.width * (isLandscape ? 0.6 : 0.85),
        ),
        child: Card(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: FFAppState().GameEndedWin 
                  ? [FlutterFlowTheme.of(context).secondary, FlutterFlowTheme.of(context).primary]
                  : [FlutterFlowTheme.of(context).error, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(isLandscape ? 16 : 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      FFAppState().GameEndedWin ? 'VICTORY!' : 'DEFEAT!',
                      style: GoogleFonts.raleway(
                        fontSize: isLandscape ? 28 : 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isLandscape ? 8 : 16),
                    Text(
                      FFAppState().GameEndedWin ? 'You have smashed the stack!' : 'The stack was too much this time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: isLandscape ? 14 : 16),
                    ),
                    SizedBox(height: isLandscape ? 12 : 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildStatRow('Cards Played', FFAppState().SessionCardsPlayed.toString()),
                          _buildStatRow('Damage Dealt', FFAppState().SessionDamageDealt.toString()),
                          _buildStatRow('Damage Taken', FFAppState().SessionDamageTaken.toString()),
                          _buildStatRow('Energy Spent', FFAppState().SessionEnergySpent.toString()),
                          _buildStatRow('Successful Evades', FFAppState().SessionEvades.toString()),
                        ],
                      ),
                    ),
                    SizedBox(height: isLandscape ? 16 : 32),
                    FFButtonWidget(
                      onPressed: () async {
                        GameLogic.showPostGameAd();
                        context.goNamed(LandingPageWidget.routeName);
                      },
                      text: 'RETURN TO MENU',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: isLandscape ? 40 : 50,
                        color: Colors.white,
                        textStyle: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: isLandscape ? 14 : 16,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
      ),
    );
  }
}

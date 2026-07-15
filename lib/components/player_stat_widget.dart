import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'player_stat_model.dart';
export 'player_stat_model.dart';

class PlayerStatWidget extends StatefulWidget {
  const PlayerStatWidget({
    super.key,
    this.icon,
    String? value,
    String? label,
  })  : this.value = value ?? '68%',
        this.label = label ?? 'Win Rate';

  final Widget? icon;
  final String value;
  final String label;

  @override
  State<PlayerStatWidget> createState() => _PlayerStatWidgetState();
}

class _PlayerStatWidgetState extends State<PlayerStatWidget> {
  late PlayerStatModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlayerStatModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.icon!,
        Text(
          valueOrDefault<String>(
            widget.value,
            '68%',
          ),
          style: FlutterFlowTheme.of(context).labelLarge.override(
                font: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                lineHeight: 1.4,
              ),
        ),
        Text(
          valueOrDefault<String>(
            widget.label,
            'Win Rate',
          ),
          style: FlutterFlowTheme.of(context).labelSmall.override(
                font: GoogleFonts.robotoCondensed(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                lineHeight: 1.4,
              ),
        ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}

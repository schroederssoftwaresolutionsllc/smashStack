import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'card_value_component_model.dart';
export 'card_value_component_model.dart';

class CardValueComponentWidget extends StatefulWidget {
  const CardValueComponentWidget({
    super.key,
    required this.componentCard,
  });

  final CardStruct? componentCard;

  @override
  State<CardValueComponentWidget> createState() =>
      _CardValueComponentWidgetState();
}

class _CardValueComponentWidgetState extends State<CardValueComponentWidget> {
  late CardValueComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardValueComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget _buildTypeIcon(String name) {
    final lowerName = name.toLowerCase();
    IconData iconData;
    Color iconColor;

    if (lowerName.contains('rest')) {
      iconData = Icons.bedtime;
      iconColor = Colors.cyan;
    } else if (lowerName.contains('wait')) {
      iconData = Icons.hourglass_empty;
      iconColor = Colors.grey;
    } else if (lowerName.contains('block') || lowerName.contains('defend') || lowerName.contains('shield')) {
      iconData = Icons.shield;
      iconColor = Colors.blueGrey;
    } else if (lowerName.contains('evade') || lowerName.contains('dodge') || lowerName.contains('duck') || lowerName.contains('slip') || lowerName.contains('pull')) {
      iconData = Icons.run_circle;
      iconColor = Colors.green;
    } else if (lowerName.contains('jab') || lowerName.contains('quick')) {
      iconData = FontAwesomeIcons.handFist;
      iconColor = Colors.orange;
    } else if (lowerName.contains('hook') || lowerName.contains('smash') || lowerName.contains('attack') || lowerName.contains('hit') || lowerName.contains('cross')) {
      iconData = FontAwesomeIcons.handFist;
      iconColor = Colors.redAccent;
    } else {
      iconData = Icons.style;
      iconColor = FlutterFlowTheme.of(context).primary;
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: iconColor.withValues(alpha: 0.1),
      child: Center(
        child: FaIcon(
          iconData,
          color: iconColor,
          size: 24.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCountered = widget.componentCard?.name.toLowerCase() == 'wait';

    return Container(
      width: 75.0,
      height: 105.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0.0, 4.0),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isCountered ? Colors.red : FlutterFlowTheme.of(context).primary,
          width: 2.0,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Header: Energy & Damage
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.amber, size: 14),
                        Text(
                          '${widget.componentCard?.energy ?? 0}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold),
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.handFist, color: Colors.redAccent, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          '${widget.componentCard?.damage ?? 0}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold),
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Main Body: Image or Icon
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Builder(
                      builder: (context) {
                        final cardName = widget.componentCard?.name ?? 'N/A';
                        final imageUrl = widget.componentCard?.image ?? 'N/A';
                        
                        if (imageUrl != 'N/A' && imageUrl.isNotEmpty) {
                          String finalUrl = imageUrl;
                          if (imageUrl.startsWith('gs://')) {
                            try {
                              final uri = Uri.parse(imageUrl);
                              final path = uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
                              finalUrl = 'https://firebasestorage.googleapis.com/v0/b/smash-stack-7a6b6.firebasestorage.app/o/${Uri.encodeComponent(path)}?alt=media';
                            } catch (_) {}
                          }
                          return Image.network(
                            finalUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildTypeIcon(cardName),
                          );
                        }
                        return _buildTypeIcon(cardName);
                      },
                    ),
                  ),
                ),
              ),
              // Footer: Name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  widget.componentCard?.name ?? 'N/A',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.raleway(fontWeight: FontWeight.w800),
                        fontSize: 10.0,
                      ),
                ),
              ),
            ],
          ),
          if (isCountered)
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: -0.5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Text(
                      'COUNTERED',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

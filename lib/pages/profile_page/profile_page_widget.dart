import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/revenue_cat_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_page_model.dart';
export 'profile_page_model.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  static String routeName = 'ProfilePage';
  static String routePath = '/profilePage';

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  late ProfilePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilePageModel());
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: true,
          title: Text(
            'Profile',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.raleway(fontWeight: FontWeight.bold),
                  color: FlutterFlowTheme.of(context).tertiary,
                ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: StreamBuilder<List<PlayerStatsRecord>>(
            stream: queryPlayerStatsRecord(
              queryBuilder: (playerStatsRecord) => playerStatsRecord.where(
                'UserReference',
                isEqualTo: currentUserReference,
              ),
              singleRecord: true,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final stats = snapshot.data!.firstOrNull;
              return Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(currentUserPhoto),
                    ),
                    SizedBox(height: 16),
                    Text(
                      currentUserDisplayName,
                      style: FlutterFlowTheme.of(context).headlineSmall,
                    ),
                    SizedBox(height: 32),
                    _buildStatRow(context, 'Wins', stats?.wins.toString() ?? '0', Icons.emoji_events, Colors.amber),
                    _buildStatRow(context, 'Losses', stats?.losses.toString() ?? '0', Icons.close, Colors.red),
                    _buildStatRow(context, 'Win Rate', '${stats?.winPercentage ?? 0}%', Icons.show_chart, Colors.green),
                    _buildStatRow(context, 'Streak', stats?.winningStreak.toString() ?? '0', Icons.whatshot, Colors.orange),
                    Spacer(),
                    if (!RevenueCatService().isPro)
                      FFButtonWidget(
                        onPressed: () async {
                          bool success = await RevenueCatService().purchasePro();
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ads Removed Permanently!')),
                            );
                            setState(() {});
                          }
                        },
                        text: 'Remove Ads Permanently - \$2',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          color: FlutterFlowTheme.of(context).tertiary,
                          textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.raleway(fontWeight: FontWeight.bold),
                            color: Colors.white,
                          ),
                          elevation: 3,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            SizedBox(width: 16),
            Text(label, style: FlutterFlowTheme.of(context).titleMedium),
            Spacer(),
            Text(value, style: FlutterFlowTheme.of(context).headlineSmall.override(
              font: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ),
    );
  }
}

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/account_deletion_service.dart';
import '/services/revenue_cat_service.dart';
import '/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
  bool _isDeletingAccount = false;

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
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      SizedBox(height: 32),
                      if (!Provider.of<RevenueCatService>(context).isPro)
                        FFButtonWidget(
                          onPressed: () async {
                            bool success = await Provider.of<RevenueCatService>(context, listen: false).presentPaywall();
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Ads Removed Permanently! Welcome to Pro!')),
                              );
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
                      if (Provider.of<RevenueCatService>(context).isPro)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: FlutterFlowTheme.of(context).secondary, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, color: FlutterFlowTheme.of(context).secondary),
                              SizedBox(width: 12),
                              Text(
                                'PRO STATUS ACTIVE',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w900),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Debug Info
                      if (kDebugMode)
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.black12,
                            child: Text(
                              "DEBUG: ${Provider.of<RevenueCatService>(context).debugEntitlementInfo}",
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      SizedBox(height: 12),
                      TextButton(
                        onPressed: () async {
                          bool success = await Provider.of<RevenueCatService>(context, listen: false).restorePurchases();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(success ? 'Purchases Restored!' : 'No previous purchases found.')),
                          );
                        },
                        child: Text(
                          'Restore Purchases',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      TextButton(
                        onPressed: _isDeletingAccount
                            ? null
                            : _confirmAndDeleteAccount,
                        child: _isDeletingAccount
                            ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                'Delete Account',
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).error,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete account?'),
        content: Text(
          'This permanently deletes your account, your profile and your '
          'win/loss record. Purchases are tied to your store account and are '
          'not affected. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Delete',
              style: TextStyle(color: FlutterFlowTheme.of(context).error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isDeletingAccount = true);
    final result = await AccountDeletionService.deleteAccountAndData();
    if (!mounted) return;
    setState(() => _isDeletingAccount = false);

    if (result == AccountDeletionResult.success) {
      GoRouter.of(context).clearRedirectLocation();
      context.goNamedAuth(LoginWidget.routeName, context.mounted);
      return;
    }

    final message = result == AccountDeletionResult.requiresRecentLogin
        ? 'For your security, please sign out and sign in again, then delete '
            'your account.'
        : result == AccountDeletionResult.notSignedIn
            ? 'You are not signed in.'
            : 'Something went wrong deleting your account. Please try again, '
                'or email Schroederssoftwaresolutions@gmail.com.';

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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

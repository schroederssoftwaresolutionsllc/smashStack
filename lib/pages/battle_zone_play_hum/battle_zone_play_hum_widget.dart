import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/card_value_component_widget.dart';
import '/components/game_ended_display_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import '/services/game_logic.dart';
import '/services/audio_service.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'battle_zone_play_hum_model.dart';
export 'battle_zone_play_hum_model.dart';

class BattleZonePlayHumWidget extends StatefulWidget {
  const BattleZonePlayHumWidget({
    super.key,
    this.matchRef,
  });

  final DocumentReference? matchRef;

  static String routeName = 'BattleZonePlayHum';
  static String routePath = '/battleZonePlayHum';

  @override
  State<BattleZonePlayHumWidget> createState() =>
      _BattleZonePlayHumWidgetState();
}

class _BattleZonePlayHumWidgetState extends State<BattleZonePlayHumWidget>
    with TickerProviderStateMixin {
  late BattleZonePlayHumModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BattleZonePlayHumModel());
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AudioService().playBGM('audios/battle_bgm.mp3');
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (widget.matchRef == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Invalid Match Reference'),
              const SizedBox(height: 16),
              FFButtonWidget(
                onPressed: () => context.goNamed(LandingPageWidget.routeName),
                text: 'Back to Menu',
                options: FFButtonOptions(
                  width: 200,
                  height: 40,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: const TextStyle(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<QueRecord>(
      stream: QueRecord.getDocument(widget.matchRef!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final match = snapshot.data!;
        final isPlayerA = match.playerA == currentUserUid;
        
        // Sync state from Firestore if it's not our turn to play
        _syncState(match, isPlayerA);

        // Check if both played
        if (match.hasPlayerACard() && match.hasPlayerBCard()) {
           WidgetsBinding.instance.addPostFrameCallback((_) async {
             await GameLogic.resolvePvPTurn(match, isPlayerA);
             safeSetState(() {});
             
             // Clear the resolution UI after a delay
             Future.delayed(const Duration(milliseconds: 3000), () {
               if (mounted) {
                 GameLogic.resetTurnState(FFAppState());
                 safeSetState(() {});
               }
             });
           });
        }

        return _buildUI(context, match, isPlayerA, isLandscape);
      },
    );
  }

  void _syncState(QueRecord match, bool isPlayerA) {
    final state = FFAppState();
    if (isPlayerA) {
      state.YourLife = match.playerALife;
      state.ThierLife = match.playerBLife;
      state.YourEnergy = match.playerAEnergy;
      state.TheirEnergy = match.playerBEnergy;
      state.CounteredWindowActiveForYou = match.playerAWindow;
      state.CounteredWindowActiveForThem = match.playerBWindow;
    } else {
      state.YourLife = match.playerBLife;
      state.ThierLife = match.playerALife;
      state.YourEnergy = match.playerBEnergy;
      state.TheirEnergy = match.playerAEnergy;
      state.CounteredWindowActiveForYou = match.playerBWindow;
      state.CounteredWindowActiveForThem = match.playerAWindow;
    }
  }

  Future<void> _showResignDialog(QueRecord match, bool isPlayerA) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resign Match?'),
        content: const Text('Are you sure you want to resign? This will be counted as a loss.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Resign', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (isPlayerA) {
        await match.reference.update({'PlayerALife': 0});
      } else {
        await match.reference.update({'PlayerBLife': 0});
      }
      if (mounted) {
        context.goNamed(LandingPageWidget.routeName);
      }
    }
  }

  Widget _buildUI(BuildContext context, QueRecord match, bool isPlayerA, bool isLandscape) {
    final state = FFAppState();

    // Auto-Wait Logic for PvP
    if (state.CounteredWindowActiveForThem && !state.YourCardPlayed && !state.GameEnded) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 1500), () async {
            if (!mounted || state.YourCardPlayed) return;
            state.CardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
            await GameLogic.processPvPTurn(match, isPlayerA);
            safeSetState(() {});
          });
       });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _showResignDialog(match, isPlayerA);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: isLandscape ? null : AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _showResignDialog(match, isPlayerA),
          ),
          title: Text('Battle',
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              
              return Stack(
                children: [
                  Column(
                    children: [
                      // Opponent Info
                      _buildPlayerHeader(
                        context, 
                        isPlayerA ? 'Player B' : 'Player A', 
                        FFAppState().ThierLife, 
                        FFAppState().TheirEnergy,
                        true,
                        isLandscape: isLandscape,
                        avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=${isPlayerA ? match.playerB : match.playerA}',
                        isHit: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && !FFAppState().TheyAvoided && FFAppState().CardState.damage > 0,
                        isEnergyGained: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && FFAppState().EnemyCardState.energy < 0,
                        isEnergyLost: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && FFAppState().EnemyCardState.energy > 0,
                      ),
                      
                      Expanded(
                        flex: isLandscape ? 1 : 4,
                        child: Container(
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (context, battleConstraints) {
                              final battleHeight = battleConstraints.maxHeight;
                              
                              return Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Opacity(
                                          opacity: (FFAppState().YourCardPlayed && FFAppState().TheirCardPlayed && (FFAppState().EnemyCardState.name.toLowerCase() == 'wait' || FFAppState().CardState.name.toLowerCase() == 'wait')) ? 0.3 : 1.0,
                                          child: _buildPlayedCard(context, FFAppState().YourCardPlayed, FFAppState().CardState, 'You', isLandscape: isLandscape, screenHeight: battleHeight),
                                        ),
                                        Opacity(
                                          opacity: (FFAppState().YourCardPlayed && FFAppState().TheirCardPlayed && (FFAppState().EnemyCardState.name.toLowerCase() == 'wait' || FFAppState().CardState.name.toLowerCase() == 'wait')) ? 0.3 : 1.0,
                                          child: _buildPlayedCard(context, FFAppState().TheirCardPlayed, FFAppState().EnemyCardState, 'Opponent', isLandscape: isLandscape, screenHeight: battleHeight),
                                        ),
                                      ],
                                    ),
                                    if (FFAppState().YourCardPlayed && FFAppState().TheirCardPlayed && FFAppState().EnemyCardState.name.toLowerCase() == 'wait')
                                      _buildOverlayMessage(context, "OPEN WINDOW!", "FREE ATTACK GRANTED", Colors.amber, FontAwesomeIcons.boltLightning, isLandscape: isLandscape),
                                    if (FFAppState().YourCardPlayed && FFAppState().TheirCardPlayed && FFAppState().CardState.name.toLowerCase() == 'wait')
                                      _buildOverlayMessage(context, "COUNTERED!", "OPPONENT GRANTED WINDOW", Colors.red, FontAwesomeIcons.skullCrossbones, isLandscape: isLandscape),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Your Info
                      AuthUserStreamWidget(
                        builder: (context) => _buildPlayerHeader(
                          context, 
                          'You', 
                          FFAppState().YourLife, 
                          FFAppState().YourEnergy,
                          false,
                          isLandscape: isLandscape,
                          avatarUrl: currentUserPhoto,
                          isHit: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && !FFAppState().YouAvoided && FFAppState().EnemyCardState.damage > 0,
                          isEnergyGained: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && (FFAppState().CardState.energy < 0 || (FFAppState().YouAvoided && !FFAppState().CardState.name.toLowerCase().contains('counter'))),
                          isEnergyLost: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && FFAppState().CardState.energy > 0,
                        ),
                      ),

                      // Your Hand
                      Flexible(
                        flex: isLandscape ? 0 : 2,
                        child: Container(
                          height: isLandscape ? (screenHeight * 0.3).clamp(80.0, 120.0) : null,
                          child: _buildHand(context, match, isPlayerA, isLandscape, screenHeight),
                        ),
                      ),
                    ],
                  ),
                  if (FFAppState().GameEnded)
                    Center(
                      child: wrapWithModel(
                        model: _model.gameEndedDisplayComponentModel,
                        updateCallback: () => safeSetState(() {}),
                        child: GameEndedDisplayComponentWidget(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayMessage(BuildContext context, String title, String subtitle, Color color, IconData icon, {required bool isLandscape}) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? 16 : 32),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(isLandscape ? 20 : 40),
        border: Border.all(color: color, width: isLandscape ? 2 : 4),
        boxShadow: [
          BoxShadow(blurRadius: 30, color: color.withValues(alpha: 0.4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: color, size: isLandscape ? 40 : 80)
            .animate().scale(duration: 400.ms, curve: Curves.elasticOut),
          SizedBox(height: isLandscape ? 8 : 16),
          Text(
            title,
            style: GoogleFonts.raleway(
              fontSize: isLandscape ? 24 : 36,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: isLandscape ? 2 : 4,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.raleway(
              fontSize: isLandscape ? 12 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).shake(hz: 8, duration: 600.ms);
  }

  Widget _buildPlayerHeader(
    BuildContext context, 
    String name, 
    int life, 
    int energy, 
    bool isOpponent, 
    {String? avatarUrl, bool isHit = false, bool isEnergyGained = false, bool isEnergyLost = false, required bool isLandscape}
  ) {
    return Container(
      height: isLandscape ? null : 50,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: isLandscape ? 4 : 2),
      color: isOpponent ? Colors.black26 : Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (avatarUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isHit ? Border.all(color: Colors.red, width: isLandscape ? 2 : 3) : null,
                        ),
                        child: CircleAvatar(
                          radius: isLandscape ? 16 : 18,
                          backgroundImage: NetworkImage(avatarUrl),
                          backgroundColor: Colors.white10,
                        ).animate(target: isHit ? 1 : 0)
                         .shake(hz: 15, duration: 600.ms, offset: const Offset(4, 0))
                         .tint(color: Colors.red.withValues(alpha: 0.7), duration: 200.ms),
                      ),
                      if (isHit)
                        FaIcon(FontAwesomeIcons.burst, color: Colors.yellow, size: isLandscape ? 24 : 28)
                          .animate().scale(duration: 300.ms, curve: Curves.elasticOut)
                          .fadeOut(delay: 400.ms),
                    ],
                  ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width * (isLandscape ? 0.2 : 0.25),
                child: AutoSizeText(
                  name,
                  maxLines: 1,
                  minFontSize: 8,
                  style: isLandscape 
                    ? FlutterFlowTheme.of(context).titleSmall 
                    : FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.raleway(),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Life Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: isLandscape ? 24 : 26)
                    .animate(target: isHit ? 1 : 0)
                    .scale(begin: const Offset(1,1), end: const Offset(1.5, 1.5), duration: 300.ms, curve: Curves.bounceOut)
                    .then()
                    .scale(begin: const Offset(1.5,1.5), end: const Offset(1, 1), duration: 300.ms),
                  if (isHit)
                    Text("-HP", style: GoogleFonts.robotoCondensed(color: Colors.white, fontWeight: FontWeight.w900, fontSize: isLandscape ? 8 : 9))
                      .animate().moveY(begin: 0, end: -40, duration: 600.ms).fadeOut(),
                ],
              ),
              const SizedBox(width: 4),
              Text('$life', style: GoogleFonts.robotoCondensed(fontSize: isLandscape ? 18 : 18, fontWeight: FontWeight.bold)),
              SizedBox(width: isLandscape ? 12 : 12),
              // Energy Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.bolt, color: Colors.amber, size: isLandscape ? 24 : 26)
                    .animate(target: isEnergyGained || isEnergyLost ? 1 : 0)
                    .scale(begin: const Offset(1,1), end: const Offset(1.5, 1.5), duration: 300.ms, curve: Curves.elasticOut)
                    .then()
                    .scale(begin: const Offset(1.5,1.5), end: const Offset(1, 1), duration: 300.ms),
                  if (isEnergyGained)
                    Icon(Icons.add, color: Colors.green, size: isLandscape ? 14 : 16)
                      .animate().moveY(begin: 0, end: -40, duration: 600.ms).fadeOut(),
                  if (isEnergyLost)
                    Icon(Icons.remove, color: Colors.orange, size: isLandscape ? 14 : 16)
                      .animate().moveY(begin: 0, end: -40, duration: 600.ms).fadeOut(),
                ],
              ),
              const SizedBox(width: 4),
              Text('$energy', style: GoogleFonts.robotoCondensed(fontSize: isLandscape ? 18 : 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayedCard(BuildContext context, bool played, CardStruct card, String label, {required bool isLandscape, required double screenHeight}) {
    // Ultra-aggressive scaling for iPhone 16e portrait
    final cardHeight = isLandscape 
        ? (screenHeight * 0.32).clamp(50.0, 95.0) 
        : (screenHeight * 0.15).clamp(80.0, 120.0);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: isLandscape ? FlutterFlowTheme.of(context).bodySmall.override(font: GoogleFonts.raleway(), fontSize: 10) : FlutterFlowTheme.of(context).bodySmall.override(font: GoogleFonts.raleway(), fontSize: 11)),
        SizedBox(height: isLandscape ? 1 : 2),
        Container(
          height: cardHeight,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: FlutterFlowTheme.of(context).primary, width: 1.5),
          ),
          child: AspectRatio(
            aspectRatio: 3/4,
            child: played ? CardValueComponentWidget(componentCard: card) : Icon(Icons.help_outline, size: isLandscape ? 20 : 30, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildHand(BuildContext context, QueRecord match, bool isPlayerA, bool isLandscape, double screenHeight) {
    final state = FFAppState();
    
    return Container(
      color: FlutterFlowTheme.of(context).secondary,
      child: state.CounteredWindowActiveForThem 
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "YOU ARE COUNTERED!",
                style: GoogleFonts.raleway(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: isLandscape ? 14 : 16,
                ),
              ),
              if (!isLandscape) const SizedBox(height: 4),
              Text(
                "AUTO-WAITING...",
                style: GoogleFonts.raleway(
                  color: Colors.white70,
                  fontSize: isLandscape ? 10 : 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isLandscape ? 4 : 8),
              Container(
                width: isLandscape ? 30 : 40,
                height: isLandscape ? 30 : 40,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.redAccent, width: 2),
                ),
                child: Center(
                  child: Icon(Icons.hourglass_empty, color: Colors.redAccent, size: isLandscape ? 16 : 20),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
               .rotate(duration: 2.seconds),
            ],
          )
        : Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: FFAppState().Hand.length,
              itemBuilder: (context, index) {
                final card = FFAppState().Hand[index];
                final cardHeight = isLandscape 
                    ? (screenHeight * 0.25).clamp(70.0, 110.0) 
                    : (screenHeight * 0.14).clamp(70.0, 110.0);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: isLandscape ? 2.0 : 2.0),
                  child: Draggable<CardStruct>(
                    data: card,
                    onDragStarted: () {
                      if (FFAppState().YourCardPlayed) return;
                    },
                    feedback: Material(
                      type: MaterialType.transparency,
                      child: SizedBox(
                        height: cardHeight,
                        child: AspectRatio(
                          aspectRatio: 3/4,
                          child: CardValueComponentWidget(componentCard: card),
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: SizedBox(
                        height: cardHeight,
                        child: AspectRatio(
                          aspectRatio: 3/4,
                          child: CardValueComponentWidget(componentCard: card),
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (FFAppState().YourEnergy < card.energy) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Not enough energy!')),
                          );
                          return;
                        }
                        if (FFAppState().YourCardPlayed) return;
                        FFAppState().CardState = card;

                        // Replace played card with a new random one from library
                        final lib = FFAppState().Library;
                        if (lib.isNotEmpty) {
                          final newCard = lib[random_data.randomInteger(0, lib.length - 1)];
                          final hand = FFAppState().Hand;
                          final index = hand.indexOf(card);
                          if (index != -1) {
                            hand[index] = newCard;
                          }
                        }

                        await GameLogic.processPvPTurn(match, isPlayerA);
                        setState(() {});
                      },
                      child: Opacity(
                        opacity: FFAppState().YourCardPlayed ? 0.5 : 1.0,
                        child: AspectRatio(
                          aspectRatio: 3/4,
                          child: CardValueComponentWidget(componentCard: card),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}

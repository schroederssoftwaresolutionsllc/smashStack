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
           });
        }

        return _buildUI(context, match, isPlayerA);
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
    } else {
      state.YourLife = match.playerBLife;
      state.ThierLife = match.playerALife;
      state.YourEnergy = match.playerBEnergy;
      state.TheirEnergy = match.playerAEnergy;
    }
  }

  Widget _buildUI(BuildContext context, QueRecord match, bool isPlayerA) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text('PvP Battle', style: GoogleFonts.raleway(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
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
                  avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=${isPlayerA ? match.playerB : match.playerA}',
                  isHit: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && !FFAppState().TheyAvoided && FFAppState().CardState.damage > 0,
                  isEnergyGained: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && FFAppState().EnemyCardState.energy < 0,
                  isEnergyLost: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && FFAppState().EnemyCardState.energy > 0,
                ),
                
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPlayedCard(context, FFAppState().YourCardPlayed, FFAppState().CardState, 'You'),
                        _buildPlayedCard(context, FFAppState().TheirCardPlayed, FFAppState().EnemyCardState, 'Opponent'),
                      ],
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
                    avatarUrl: currentUserPhoto,
                    isHit: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && !FFAppState().YouAvoided && FFAppState().EnemyCardState.damage > 0,
                    isEnergyGained: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && (FFAppState().CardState.energy < 0 || (FFAppState().YouAvoided && !FFAppState().CardState.name.toLowerCase().contains('counter'))),
                    isEnergyLost: FFAppState().TheirCardPlayed && FFAppState().YourCardPlayed && FFAppState().CardState.energy > 0,
                  ),
                ),

                // Your Hand
                _buildHand(context, match, isPlayerA),
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
        ),
      ),
    );
  }

  Widget _buildPlayerHeader(
    BuildContext context, 
    String name, 
    int life, 
    int energy, 
    bool isOpponent, 
    {String? avatarUrl, bool isHit = false, bool isEnergyGained = false, bool isEnergyLost = false}
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: isOpponent ? Colors.black26 : Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (avatarUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isHit ? Border.all(color: Colors.red, width: 3) : null,
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(avatarUrl),
                          backgroundColor: Colors.white10,
                        ).animate(target: isHit ? 1 : 0)
                         .shake(hz: 15, duration: 600.ms, offset: const Offset(4, 0))
                         .tint(color: Colors.red.withValues(alpha: 0.7), duration: 200.ms),
                      ),
                      if (isHit)
                        const FaIcon(FontAwesomeIcons.burst, color: Colors.yellow, size: 40)
                          .animate().scale(duration: 300.ms, curve: Curves.elasticOut)
                          .fadeOut(delay: 400.ms),
                    ],
                  ),
                ),
              Text(name, style: FlutterFlowTheme.of(context).titleMedium),
            ],
          ),
          Row(
            children: [
              // Life Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 32)
                    .animate(target: isHit ? 1 : 0)
                    .scale(begin: const Offset(1,1), end: const Offset(1.5, 1.5), duration: 300.ms, curve: Curves.bounceOut)
                    .then()
                    .scale(begin: const Offset(1.5,1.5), end: const Offset(1, 1), duration: 300.ms),
                  if (isHit)
                    Text("-HP", style: GoogleFonts.robotoCondensed(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10))
                      .animate().moveY(begin: 0, end: -40, duration: 600.ms).fadeOut(),
                ],
              ),
              const SizedBox(width: 8),
              Text('$life', style: GoogleFonts.robotoCondensed(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(width: 24),
              // Energy Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.bolt, color: Colors.amber, size: 32)
                    .animate(target: isEnergyGained || isEnergyLost ? 1 : 0)
                    .scale(begin: const Offset(1,1), end: const Offset(1.5, 1.5), duration: 300.ms, curve: Curves.elasticOut)
                    .then()
                    .scale(begin: const Offset(1.5,1.5), end: const Offset(1, 1), duration: 300.ms),
                  if (isEnergyGained)
                    const Icon(Icons.add, color: Colors.green, size: 20)
                      .animate().moveY(begin: 0, end: -40, duration: 600.ms).fadeOut(),
                  if (isEnergyLost)
                    const Icon(Icons.remove, color: Colors.orange, size: 20)
                      .animate().moveY(begin: 0, end: -40, duration: 600.ms).fadeOut(),
                ],
              ),
              const SizedBox(width: 8),
              Text('$energy', style: GoogleFonts.robotoCondensed(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayedCard(BuildContext context, bool played, CardStruct card, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: FlutterFlowTheme.of(context).bodySmall),
        SizedBox(height: 8),
        Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: FlutterFlowTheme.of(context).primary, width: 2),
          ),
          child: played ? CardValueComponentWidget(componentCard: card) : Icon(Icons.help_outline, size: 48, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildHand(BuildContext context, QueRecord match, bool isPlayerA) {
    return Container(
      height: 160,
      color: FlutterFlowTheme.of(context).secondary,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: FFAppState().Hand.length,
          itemBuilder: (context, index) {
            final card = FFAppState().Hand[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Draggable<CardStruct>(
                data: card,
                onDragStarted: () {
                  if (FFAppState().YourCardPlayed) return;
                },
                feedback: Material(
                  type: MaterialType.transparency,
                  child: SizedBox(
                    width: 80,
                    height: 110,
                    child: CardValueComponentWidget(componentCard: card),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: CardValueComponentWidget(componentCard: card),
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
                    child: CardValueComponentWidget(componentCard: card),
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

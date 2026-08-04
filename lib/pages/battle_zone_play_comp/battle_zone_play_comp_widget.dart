import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/card_value_component_widget.dart';
import '/components/game_ended_display_component_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import '/services/game_logic.dart';
import '/services/audio_service.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'battle_zone_play_comp_model.dart';
export 'battle_zone_play_comp_model.dart';

class BattleZonePlayCompWidget extends StatefulWidget {
  const BattleZonePlayCompWidget({super.key});

  static String routeName = 'BattleZonePlayComp';
  static String routePath = '/battleZonePlayComp';

  @override
  State<BattleZonePlayCompWidget> createState() =>
      _BattleZonePlayCompWidgetState();
}

class _BattleZonePlayCompWidgetState extends State<BattleZonePlayCompWidget>
    with TickerProviderStateMixin {
  late BattleZonePlayCompModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BattleZonePlayCompModel());
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AudioService().playBGM('audios/battle_bgm.mp3');
      // Computer "plays" its card immediately at start of round (hidden)
      _prepareComputerMove();
    });
  }

  void _prepareComputerMove() {
    final state = FFAppState();
    
    if (state.CounteredWindowActiveForYou) {
      state.EnemyCardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
    } else if (state.TheirEnergy <= 4) {
      state.EnemyCardState = CardStruct(
        energy: -4,
        damage: 0,
        name: 'Rest',
      );
    } else {
      final lib = state.Library;
      if (lib.isNotEmpty) {
        state.EnemyCardState = lib[random_data.randomInteger(0, lib.length - 1)];
      }
    }
    state.TheirCardPlayed = true;
    safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final state = FFAppState();
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Auto-Wait Logic
    if (state.CounteredWindowActiveForThem && !state.YourCardPlayed && !state.GameEnded) {
       Future.delayed(const Duration(milliseconds: 1000), () async {
         if (!mounted || state.YourCardPlayed) return;
         state.CardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
         state.YourCardPlayed = true;
         safeSetState(() {});
         await Future.delayed(const Duration(milliseconds: 500));
         await GameLogic.processTurn(context, isRevealing: true);
         _model.gameTimerController.onStartTimer();
         safeSetState(() {});
       });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (didPop) return;
          context.goNamed(LandingPageWidget.routeName);
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: isLandscape ? null : AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.goNamed(LandingPageWidget.routeName),
            ),
            title: Text('Battle',
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            centerTitle: true,
            elevation: 2.0,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = constraints.maxHeight;
                
                return Column(
                  children: [
                    // Opponent Stats
                    _buildPlayerHeader(
                      context, 
                      state.TheirName, 
                      state.ThierLife, 
                      state.TheirEnergy, 
                      true,
                      isLandscape: isLandscape,
                      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=${state.TheirName}',
                      isHit: state.TheirCardPlayed && state.YourCardPlayed && !state.TheyAvoided && state.CardState.damage > 0,
                      isEnergyGained: state.TheirCardPlayed && state.YourCardPlayed && state.EnemyCardState.energy < 0,
                      isEnergyLost: state.TheirCardPlayed && state.YourCardPlayed && (state.EnemyCardState.energy > 0 || (state.YouAvoided && state.CardState.name.toLowerCase().contains('counter'))),
                    ),
                    
                    Expanded(
                      flex: isLandscape ? 1 : 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [FlutterFlowTheme.of(context).primary, FlutterFlowTheme.of(context).secondary],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, battleConstraints) {
                            final battleHeight = battleConstraints.maxHeight;
                            
                            return Stack(
                              children: [
                                Center(
                                  child: DragTarget<CardStruct>(
                                    onAcceptWithDetails: (details) async {
                                      final card = details.data;
                                      if (state.YourEnergy < card.energy) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Not enough energy!')),
                                        );
                                        return;
                                      }
                                      
                                      state.CardState = card;
                                      state.YourCardPlayed = true;
                                      safeSetState(() {});

                                      final lib = state.Library;
                                      if (lib.isNotEmpty) {
                                        final newCard = lib[random_data.randomInteger(0, lib.length - 1)];
                                        final hand = state.Hand;
                                        final index = hand.indexOf(card);
                                        if (index != -1) hand[index] = newCard;
                                      }

                                      await Future.delayed(const Duration(milliseconds: 1000));
                                      
                                      await GameLogic.processTurn(context, isRevealing: true);
                                      _model.gameTimerController.onStartTimer();
                                      safeSetState(() {});
                                    },
                                    builder: (context, candidateData, rejectedData) {
                                      final isHovering = candidateData.isNotEmpty;
                                      final youCountered = state.YourCardPlayed && state.TheirCardPlayed && state.EnemyCardState.name.toLowerCase() == 'wait';
                                      final theyCountered = state.YourCardPlayed && state.TheirCardPlayed && state.CardState.name.toLowerCase() == 'wait';

                                      return Container(
                                        width: constraints.maxWidth * 0.95,
                                        margin: EdgeInsets.all(isLandscape ? 2 : 4),
                                        decoration: BoxDecoration(
                                          color: isHovering ? Colors.white10 : Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                          border: isHovering ? Border.all(color: Colors.white24, width: 2) : null,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Opacity(
                                              opacity: (youCountered || theyCountered) ? 0.3 : 1.0,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Flexible(
                                                    child: _buildPlayedCard(
                                                      context,
                                                      state.YourCardPlayed,
                                                      state.CardState,
                                                      'You',
                                                      isLandscape: isLandscape,
                                                      screenHeight: battleHeight,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: _buildPlayedCard(
                                                      context,
                                                      state.TheirCardPlayed,
                                                      state.EnemyCardState,
                                                      'Opponent',
                                                      isLandscape: isLandscape,
                                                      screenHeight: battleHeight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (youCountered)
                                              _buildOverlayMessage(
                                                context,
                                                "OPEN WINDOW!",
                                                "FREE ATTACK GRANTED",
                                                Colors.amber,
                                                FontAwesomeIcons.boltLightning,
                                                isLandscape: isLandscape,
                                              ),
                                            if (theyCountered)
                                              _buildOverlayMessage(
                                                context,
                                                "COUNTERED!",
                                                "OPPONENT GRANTED WINDOW",
                                                Colors.red,
                                                FontAwesomeIcons.skullCrossbones,
                                                isLandscape: isLandscape,
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (state.GameEnded)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black54,
                                      child: Center(
                                        child: wrapWithModel(
                                          model: _model.gameEndedDisplayComponentModel,
                                          updateCallback: () => safeSetState(() {}),
                                          child: GameEndedDisplayComponentWidget(),
                                        ),
                                      ),
                                    ).animate().fadeIn(duration: 500.ms),
                                  ),
                                Opacity(
                                  opacity: 0,
                                  child: FlutterFlowTimer(
                                    initialTime: _model.gameTimerInitialTimeMs,
                                    getDisplayTime: (value) => StopWatchTimer.getDisplayTime(value),
                                    controller: _model.gameTimerController,
                                    updateStateInterval: Duration(milliseconds: 100),
                                    onChanged: (value, displayTime, shouldUpdate) {},
                                    onEnded: () async {
                                      if (state.GameEnded) return;
                                      GameLogic.resetTurnState(state);
                                      _model.gameTimerController.onResetTimer();
                                      _prepareComputerMove();
                                      safeSetState(() {});
                                    },
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context).headlineSmall,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // Your Stats
                    AuthUserStreamWidget(
                      builder: (context) => _buildPlayerHeader(
                        context, 
                        currentUserDisplayName, 
                        state.YourLife, 
                        state.YourEnergy, 
                        false,
                        isLandscape: isLandscape,
                        avatarUrl: currentUserPhoto,
                        isHit: state.TheirCardPlayed && state.YourCardPlayed && !state.YouAvoided && state.EnemyCardState.damage > 0,
                        isEnergyGained: state.TheirCardPlayed && state.YourCardPlayed && (state.CardState.energy < 0 || (state.YouAvoided && !state.CardState.name.toLowerCase().contains('counter'))),
                        isEnergyLost: state.TheirCardPlayed && state.YourCardPlayed && state.CardState.energy > 0,
                      ),
                    ),

                    // Controls & Hand
                    Flexible(
                      flex: isLandscape ? 0 : 2,
                      child: Container(
                        height: isLandscape ? (screenHeight * 0.35).clamp(80, 140) : null,
                        color: FlutterFlowTheme.of(context).secondary,
                        child: state.CounteredWindowActiveForThem 
                          ? _buildCounteredOverlay(context, isLandscape)
                          : _buildHandArea(context, state, isLandscape, screenHeight),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayMessage(
    BuildContext context, 
    String title, 
    String subtitle, 
    Color color, 
    IconData icon, 
    {required bool isLandscape}
  ) {
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

  Widget _buildCounteredOverlay(BuildContext context, bool isLandscape) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "YOU ARE COUNTERED!",
          style: GoogleFonts.raleway(
            color: Colors.redAccent,
            fontWeight: FontWeight.w900,
            fontSize: isLandscape ? 14 : 18,
          ),
        ),
        if (!isLandscape) const SizedBox(height: 8),
        Text(
          "AUTO-WAITING...",
          style: GoogleFonts.raleway(
            color: Colors.white70,
            fontSize: isLandscape ? 10 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isLandscape ? 4 : 12),
        Container(
          width: isLandscape ? 40 : 60,
          height: isLandscape ? 40 : 60,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.redAccent, width: 2),
          ),
          child: Center(
            child: Icon(Icons.hourglass_empty, color: Colors.redAccent, size: isLandscape ? 20 : 30),
          ),
        ).animate(onPlay: (controller) => controller.repeat())
         .rotate(duration: 2.seconds),
      ],
    );
  }

  Widget _buildHandArea(BuildContext context, FFAppState state, bool isLandscape, double screenHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: isLandscape ? 2.0 : 2.0),
          child: FFButtonWidget(
            onPressed: () async {
              if (state.YourCardPlayed) return;
               state.CardState = CardStruct(
                energy: -4,
                damage: 0,
                name: 'Rest',
              );
              state.YourCardPlayed = true;
              safeSetState(() {});

              await Future.delayed(const Duration(milliseconds: 1000));
              await GameLogic.processTurn(context, isRevealing: true);
              _model.gameTimerController.onStartTimer();
              safeSetState(() {});
            },
            text: 'REST (+4 Energy)',
            options: FFButtonOptions(
              width: isLandscape ? 120 : 130,
              height: isLandscape ? 28 : 28,
              color: Colors.amber,
              textStyle: GoogleFonts.raleway(
                fontWeight: FontWeight.bold, 
                color: Colors.black, 
                fontSize: isLandscape ? 10 : 10
              ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: state.Hand.length,
              itemBuilder: (context, index) {
                final card = state.Hand[index];
                final cardHeight = isLandscape 
                    ? (screenHeight * 0.3).clamp(70.0, 110.0) 
                    : (screenHeight * 0.14).clamp(70.0, 110.0);
                
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.0, 
                    vertical: isLandscape ? 2.0 : 2.0
                  ),
                  child: Draggable<CardStruct>(
                    data: card,
                    onDragStarted: () {
                      if (state.YourCardPlayed) return;
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
                    child: Opacity(
                      opacity: state.YourCardPlayed ? 0.5 : 1.0,
                      child: AspectRatio(
                        aspectRatio: 3/4,
                        child: CardValueComponentWidget(componentCard: card),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerHeader(
    BuildContext context, 
    String name, 
    int life, 
    int energy, 
    bool isOpponent, 
    {
      String? avatarUrl, 
      bool isHit = false, 
      bool isEnergyGained = false, 
      bool isEnergyLost = false,
      required bool isLandscape,
    }
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
  Widget _buildPlayedCard(
    BuildContext context, 
    bool played, 
    CardStruct card, 
    String label, 
    {required bool isLandscape, required double screenHeight}
  ) {
    final shouldHide = label == 'Opponent' && played && !FFAppState().YourCardPlayed;
    // Ultra-aggressive scaling for iPhone 16e portrait
    final cardHeight = isLandscape 
        ? (screenHeight * 0.32).clamp(50.0, 95.0) 
        : (screenHeight * 0.15).clamp(80.0, 120.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: isLandscape ? 10 : 12)),
        SizedBox(height: isLandscape ? 1 : 4),
        Container(
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24, width: 1.5),
          ),
          child: AspectRatio(
            aspectRatio: 3/4,
            child: played 
              ? (shouldHide 
                  ? Center(child: Icon(Icons.help_center, size: isLandscape ? 20 : 30, color: Colors.amber)) 
                  : CardValueComponentWidget(componentCard: card)) 
              : Center(child: Icon(Icons.style, size: isLandscape ? 20 : 30, color: Colors.white24)),
          ),
        ),
      ],
    );
  }
}

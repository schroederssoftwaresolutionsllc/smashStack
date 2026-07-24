import '../backend/backend.dart';
import '../app_state.dart';
import '../auth/firebase_auth/auth_util.dart';
import 'audio_service.dart';
import 'ad_service.dart';
import 'revenue_cat_service.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/random_data_util.dart' as random_data;

class GameLogic {
  static Future<void> processTurn(BuildContext context, {bool isRevealing = false}) async {
    final state = FFAppState();
    
    // Only set cards if not already set by hidden play
    if (!isRevealing) {
      state.YourCardPlayed = true;
      state.TheirCardPlayed = true;

      // AI selects its move
      if (state.TheirEnergy <= 4) {
        state.EnemyCardState = CardStruct(
          energy: -4,
          damage: 0,
          name: 'Rest',
        );
      } else {
        final lib = state.Library;
        state.EnemyCardState = lib.isNotEmpty 
            ? lib[DateTime.now().millisecond % lib.length] 
            : CardStruct(name: 'Wait', energy: 0, damage: 0);
      }
    }

    _resolveBattle(state);

    if (state.YourLife <= 0 || state.ThierLife <= 0) {
      state.GameEnded = true;
      state.GameEndedWin = state.ThierLife <= 0;
      await _updatePlayerStats(state.GameEndedWin);
      // Removed showPostGameAd() from here, will be called on "Return to Menu"
    }
  }

  static void _resolveBattle(FFAppState state) {
    // Capture if window was already active before this resolution
    final wasWindowForYou = state.CounteredWindowActiveForYou;
    final wasWindowForThem = state.CounteredWindowActiveForThem;

    final pCard = state.CardState;
    final eCard = state.EnemyCardState;

    final pName = pCard.name.toLowerCase();
    final eName = eCard.name.toLowerCase();

    bool pEvaded = pCard.avoids.contains(eCard.name);
    bool eEvaded = eCard.avoids.contains(pCard.name);

    // Contextual Bonuses
    int pEnergyBonus = 0;
    int eEnergyBonus = 0;
    int pDamageBonus = 0;
    int eDamageBonus = 0;
    
    int pFinalDamageTaken = eCard.damage;
    int eFinalDamageTaken = pCard.damage;

    // Logic: Block Mechanics
    if (pName.contains('block')) {
      if (eName.contains('jab')) {
        pFinalDamageTaken = 0; // Jabs are fully blocked
      } else {
        pFinalDamageTaken = (eCard.damage - 2).clamp(0, 20); // Blocks reduce damage by 2
      }
    }
    if (eName.contains('block')) {
      if (pName.contains('jab')) {
        eFinalDamageTaken = 0;
      } else {
        eFinalDamageTaken = (pCard.damage - 2).clamp(0, 20);
      }
    }

    // Logic: Pull vs Uppercut/Hook
    if (pName.contains('pull') && (eName.contains('uppercut') || eName.contains('hook'))) {
      pEvaded = true;
      state.YourEnergy = 20; 
      AudioService().playSFX('audios/special_move.mp3');
      state.EnemyCardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
      state.CounteredWindowActiveForYou = true;
    }
    if (eName.contains('pull') && (pName.contains('uppercut') || pName.contains('hook'))) {
      eEvaded = true;
      state.TheirEnergy = 20;
      AudioService().playSFX('audios/special_move.mp3');
      state.CardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
      state.CounteredWindowActiveForThem = true;
    }

    // Logic: Duck vs Hook/Cross
    if (pName.contains('duck') && (eName.contains('hook') || eName.contains('cross'))) {
      pEvaded = true;
      state.YourEnergy = 20; // Full energy for counter
      AudioService().playSFX('audios/special_move.mp3');
      state.EnemyCardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
      state.CounteredWindowActiveForYou = true;
    }
    if (eName.contains('duck') && (pName.contains('hook') || pName.contains('cross'))) {
      eEvaded = true;
      state.TheirEnergy = 20;
      AudioService().playSFX('audios/special_move.mp3');
      state.CardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
      state.CounteredWindowActiveForThem = true;
    }
    
    // Logic: Slip vs Jab
    if (pName.contains('slip') && eName.contains('jab')) {
      pEvaded = true;
      state.YourEnergy = 20;
      AudioService().playSFX('audios/special_move.mp3');
      state.EnemyCardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
      state.CounteredWindowActiveForYou = true;
    }
    if (eName.contains('slip') && pName.contains('jab')) {
      eEvaded = true;
      state.TheirEnergy = 20;
      AudioService().playSFX('audios/special_move.mp3');
      state.CardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
      state.CounteredWindowActiveForThem = true;
    }

    // Logic: Counter vs Attack
    if (pName.contains('counter') && (eCard.damage > 0)) {
      pEvaded = true;
      pDamageBonus += eCard.damage; // Reflect damage
      state.TheirEnergy -= 4; // Drain opponent energy
      state.EnemyCardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
      state.CounteredWindowActiveForYou = true;
    }
    if (eName.contains('counter') && (pCard.damage > 0)) {
      eEvaded = true;
      eDamageBonus += pCard.damage;
      state.YourEnergy -= 4;
      state.CardState = CardStruct(name: 'Wait', energy: 0, damage: 0);
      state.CounteredWindowActiveForThem = true;
    }

    state.YouAvoided = pEvaded;
    state.TheyAvoided = eEvaded;

    // Update Session Stats
    state.SessionCardsPlayed += 1;
    state.SessionEnergySpent += pCard.energy > 0 ? pCard.energy : 0;

    // Health updates (Player)
    if (!pEvaded && pFinalDamageTaken > 0) {
      state.YourLife -= (pFinalDamageTaken + eDamageBonus);
      state.SessionDamageTaken += (pFinalDamageTaken + eDamageBonus);
      AudioService().playSFX('audios/hit.mp3');
    } else if (pEvaded) {
      state.YourEnergy += (2 + pEnergyBonus);
      state.SessionEvades += 1;
      AudioService().playSFX('audios/evade.mp3');
      if (pDamageBonus > 0) {
        state.ThierLife -= pDamageBonus;
        state.SessionDamageDealt += pDamageBonus;
      }
    }

    // Health updates (Enemy)
    if (!eEvaded && eFinalDamageTaken > 0) {
      state.ThierLife -= (eFinalDamageTaken + pDamageBonus);
      state.SessionDamageDealt += (eFinalDamageTaken + pDamageBonus);
      AudioService().playSFX('audios/hit.mp3');
    } else if (eEvaded) {
      state.TheirEnergy += (2 + eEnergyBonus);
      AudioService().playSFX('audios/evade.mp3');
      if (eDamageBonus > 0) {
        state.YourLife -= eDamageBonus;
        state.SessionDamageTaken += eDamageBonus;
      }
    }

    state.YourEnergy -= pCard.energy;
    state.TheirEnergy -= eCard.energy;

    state.YourLife = state.YourLife.clamp(0, 20);
    state.ThierLife = state.ThierLife.clamp(0, 20);
    state.YourEnergy = state.YourEnergy.clamp(0, 20);
    state.TheirEnergy = state.TheirEnergy.clamp(0, 20);

    // If a window was active entering this turn, it is now closed.
    if (wasWindowForYou) state.CounteredWindowActiveForYou = false;
    if (wasWindowForThem) state.CounteredWindowActiveForThem = false;
  }

  static Future<void> processPvPTurn(QueRecord match, bool isPlayerA) async {
    final state = FFAppState();
    final card = state.CardState;

    if (isPlayerA) {
      await match.reference.update({
        'PlayerACard': card.toMap(),
      });
    } else {
      await match.reference.update({
        'PlayerBCard': card.toMap(),
      });
    }
  }

  static Future<void> resolvePvPTurn(QueRecord match, bool isPlayerA) async {
    final state = FFAppState();
    state.YourCardPlayed = true;
    state.TheirCardPlayed = true;
    
    if (isPlayerA) {
      state.CardState = match.playerACard;
      state.EnemyCardState = match.playerBCard;
    } else {
      state.CardState = match.playerBCard;
      state.EnemyCardState = match.playerACard;
    }

    _resolveBattle(state);

    if (isPlayerA) {
      await match.reference.update({
        'PlayerALife': state.YourLife,
        'PlayerBLife': state.ThierLife,
        'PlayerAEnergy': state.YourEnergy,
        'PlayerBEnergy': state.TheirEnergy,
        'PlayerAWindow': state.CounteredWindowActiveForYou,
        'PlayerBWindow': state.CounteredWindowActiveForThem,
        'PlayerACard': null,
        'PlayerBCard': null,
      });
    }

    if (state.YourLife <= 0 || state.ThierLife <= 0) {
      state.GameEnded = true;
      state.GameEndedWin = state.ThierLife <= 0;
      await _updatePlayerStats(state.GameEndedWin);
      // Removed showPostGameAd() from here, will be called on "Return to Menu"
    }
  }

  static Future<void> _updatePlayerStats(bool win) async {
    final state = FFAppState();
    final statsQuery = await queryPlayerStatsRecordOnce(
      queryBuilder: (playerStatsRecord) => playerStatsRecord.where(
        'UserReference',
        isEqualTo: currentUserReference,
      ),
      limit: 1,
    );

    if (statsQuery.isNotEmpty) {
      final doc = statsQuery.first;
      final newWins = doc.wins + (win ? 1 : 0);
      final newLosses = doc.losses + (win ? 0 : 1);
      final total = newWins + newLosses;
      final winRate = total > 0 ? (newWins / total * 100).round() : 0;
      final newStreak = win ? (doc.winningStreak + 1) : 0;

      await doc.reference.update({
        'Wins': newWins,
        'Losses': newLosses,
        'WinPercentage': winRate,
        'WinningStreak': newStreak,
        'TotalDamageDealt': doc.totalDamageDealt + state.SessionDamageDealt,
        'TotalDamageTaken': doc.totalDamageTaken + state.SessionDamageTaken,
        'TotalEnergySpent': doc.totalEnergySpent + state.SessionEnergySpent,
        'TotalCardsPlayed': doc.totalCardsPlayed + state.SessionCardsPlayed,
        'TotalEvades': doc.totalEvades + state.SessionEvades,
      });
    }
  }

  static void showPostGameAd() {
    if (!RevenueCatService().isPro) {
      AdService().showInterstitialAd();
    }
  }

  static void resetTurnState(FFAppState state) {
    state.YourCardPlayed = false;
    state.TheirCardPlayed = false;
    state.YouAvoided = false;
    state.TheyAvoided = false;
    state.CardState = CardStruct(name: 'N/A', energy: 0, damage: 0);
    state.EnemyCardState = CardStruct(name: 'N/A', energy: 0, damage: 0);
  }

  static Future<void> initializeGame(FFAppState state) async {
    // Reset state for new game
    state.Library = [];
    state.Hand = [];
    state.YourCardPlayed = false;
    state.TheirCardPlayed = false;
    state.GameEnded = false;
    state.GameEndedWin = false;
    state.CounteredWindowActiveForYou = false;
    state.CounteredWindowActiveForThem = false;
    
    // Reset Session Stats
    state.SessionDamageDealt = 0;
    state.SessionDamageTaken = 0;
    state.SessionEnergySpent = 0;
    state.SessionCardsPlayed = 0;
    state.SessionEvades = 0;

    // Get Cards from Firestore
    final cardsCollection = await queryCardsRecordOnce();
    
    if (cardsCollection.isNotEmpty) {
      for (final cardRecord in cardsCollection) {
        state.addToLibrary(CardStruct(
          energy: cardRecord.card.energy,
          damage: cardRecord.card.damage,
          prevents: cardRecord.card.prevents,
          avoids: cardRecord.card.avoids.take(5).toList(),
          image: cardRecord.card.image,
          name: cardRecord.card.name,
        ));
      }
    }

    if (state.Library.isNotEmpty) {
      for (int i = 0; i < 5; i++) {
        final randomIndex = random_data.randomInteger(0, state.Library.length - 1);
        final randomCard = state.Library.elementAtOrNull(randomIndex);
        if (randomCard != null) {
          state.addToHand(randomCard);
        }
      }
    }

    // Set Game Initial State
    state.YourLife = 20;
    state.ThierLife = 20;
    state.TheirEnergy = 20;
    state.YourEnergy = 20;
    
    if (state.ComputerNames.isNotEmpty) {
      final nameIndex = random_data.randomInteger(0, state.ComputerNames.length - 1);
      state.TheirName = state.ComputerNames.elementAt(nameIndex);
    } else {
      state.TheirName = "Computer";
    }

    state.GameEnded = false;
    state.GameEndedWin = false;
  }
}

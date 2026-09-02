import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Outcome of an account deletion attempt.
enum AccountDeletionResult {
  success,

  /// No user is currently signed in.
  notSignedIn,

  /// Firebase requires a recent sign-in before it will delete the account.
  /// The caller should ask the user to sign out and back in, then retry.
  requiresRecentLogin,

  failed,
}

/// Deletes a user's account together with the personal data tied to it.
///
/// Google Play and the App Store both require apps that let users create an
/// account to offer an in-app route to deleting that account, and to remove
/// the personal data associated with it.
///
/// Two ordering details matter here:
///
///  * Firestore documents are deleted *before* the auth record. Security rules
///    evaluate against the signed-in user, so removing the auth record first
///    would leave the documents orphaned and unreachable.
///  * Freshness is checked *before* anything is deleted. Firebase rejects
///    `User.delete()` with `requires-recent-login` when the session is stale;
///    discovering that after wiping Firestore would leave the user with their
///    data gone but their account intact.
///
/// `Games` documents are deliberately left in place. Each one records a match
/// between two players, so deleting it would destroy the other player's
/// history as well. Once the `Users` document is gone those records no longer
/// resolve to an identifiable person.
class AccountDeletionService {
  /// Firebase treats a sign-in older than roughly five minutes as stale.
  /// A slightly tighter window avoids racing the server's own check.
  static const _recentLoginWindow = Duration(minutes: 4);

  static Future<AccountDeletionResult> deleteAccountAndData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return AccountDeletionResult.notSignedIn;

    final lastSignIn = user.metadata.lastSignInTime;
    if (lastSignIn == null ||
        DateTime.now().difference(lastSignIn) > _recentLoginWindow) {
      return AccountDeletionResult.requiresRecentLogin;
    }

    final uid = user.uid;
    final db = FirebaseFirestore.instance;
    final userRef = db.collection('Users').doc(uid);

    try {
      final batch = db.batch();

      // Player statistics belonging to this user.
      final stats = await db
          .collection('PlayerStats')
          .where('UserReference', isEqualTo: userRef)
          .get();
      for (final doc in stats.docs) {
        batch.delete(doc.reference);
      }

      // Any matchmaking queue entries the user is sitting in. PlayerA and
      // PlayerB hold the raw uid rather than a document reference.
      for (final field in const ['PlayerA', 'PlayerB']) {
        final queued =
            await db.collection('Que').where(field, isEqualTo: uid).get();
        for (final doc in queued.docs) {
          batch.delete(doc.reference);
        }
      }

      // The profile document itself.
      batch.delete(userRef);

      await batch.commit();

      // Only once the data is gone do we remove the account.
      await user.delete();
      return AccountDeletionResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return AccountDeletionResult.requiresRecentLogin;
      }
      return AccountDeletionResult.failed;
    } catch (_) {
      return AccountDeletionResult.failed;
    }
  }
}

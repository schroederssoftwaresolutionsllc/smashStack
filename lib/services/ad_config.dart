import 'dart:io';

import 'package:flutter/foundation.dart';

/// Central place for AdMob identifiers.
///
/// Google's sample IDs are the right thing to use while developing: they
/// always fill and they never generate invalid traffic. They must not reach a
/// release build, though. Users would see "Test Ad" placeholders, and the
/// binary would be shipping another publisher's identifiers.
///
/// Production IDs come from your own AdMob account. You do not need the app
/// to be published first: when adding it in AdMob, answer "No" to the question
/// about whether it is listed on a supported app store and you get real
/// identifiers straight away. Those serve limited ads until you come back
/// after launch and link the store listing, which starts AdMob's readiness
/// review.
///
/// The Android application ID is not here. It lives in the manifest, supplied
/// by the `admobAppId` Gradle manifest placeholder, so that a release build
/// cannot be produced without one.
class AdConfig {
  const AdConfig._();

  // ---------------------------------------------------------------------
  // Paste your production ad unit IDs here, then rebuild.
  // Until these are filled in, release builds simply run without ads.
  // ---------------------------------------------------------------------
  static const String androidInterstitialProd = '';
  static const String iosInterstitialProd = '';

  // Google's public sample units. Debug builds only.
  static const String _androidInterstitialTest =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialTest =
      'ca-app-pub-3940256099942544/4411468910';

  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return kDebugMode ? _androidInterstitialTest : androidInterstitialProd;
    }
    if (Platform.isIOS) {
      return kDebugMode ? _iosInterstitialTest : iosInterstitialProd;
    }
    return '';
  }

  /// False when a release build has no production unit configured yet. The
  /// app then runs with ads switched off, rather than showing another
  /// publisher's test placeholders to real users.
  static bool get adsEnabled => interstitialAdUnitId.isNotEmpty;
}

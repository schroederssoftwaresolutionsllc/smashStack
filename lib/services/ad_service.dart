import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

import 'ad_config.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  String get interstitialAdUnitId => AdConfig.interstitialAdUnitId;

  /// True when an ad unit is configured for this build. Release builds with
  /// no production unit set run with ads off.
  bool get adsEnabled => AdConfig.adsEnabled;

  Future<void> init() async {
    if (kIsWeb || !adsEnabled) return;
    await MobileAds.instance.initialize();
    loadInterstitialAd();
  }

  void loadInterstitialAd() {
    if (kIsWeb || !adsEnabled) return;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdLoaded = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isAdLoaded = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (!adsEnabled) return;
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      loadInterstitialAd();
    }
  }
}

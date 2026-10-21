import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RevenueCatService extends ChangeNotifier {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  bool _isPro = false;
  bool get isPro => _isPro;

  static const String _entitlementId = "Smash Stack Pro";

  // RevenueCat Test Store key. Debug builds only: the SDK deliberately crashes
  // a release build that is configured with a test_ key (this is what got
  // version code 12 rejected by Google Play for crashing on launch).
  static const String _testStoreApiKey = "test_wPhhtafAuluxazorSsFIelwHEri";

  // Production public SDK keys from the RevenueCat dashboard (Project
  // settings > API keys). Google Play keys start with "goog_", App Store keys
  // with "appl_". Leave blank until the store app is configured in RevenueCat
  // and its products exist in Play Console / App Store Connect; while blank,
  // release builds run with purchases switched off and the Remove Ads and
  // Restore Purchases buttons hidden.
  static const String _googlePlayApiKey = "";
  static const String _appStoreApiKey = "";

  static String get _apiKey {
    if (kIsWeb) return '';
    if (kDebugMode) return _testStoreApiKey;
    if (defaultTargetPlatform == TargetPlatform.android) return _googlePlayApiKey;
    if (defaultTargetPlatform == TargetPlatform.iOS) return _appStoreApiKey;
    return '';
  }

  bool _configured = false;

  /// True only when RevenueCat was configured with a key valid for this build.
  bool get purchasesEnabled => _configured;

  Future<void> init() async {
    final apiKey = _apiKey;
    if (apiKey.isEmpty || (apiKey.startsWith('test_') && !kDebugMode)) {
      debugPrint("RevenueCat disabled: no production API key for this platform.");
      return;
    }

    try {
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
      _configured = true;

      await updatePurchaseStatus();
    } catch (e) {
      debugPrint("RevenueCat initialization failed: $e");
    }
  }

  String _debugEntitlementInfo = "No info fetched yet";
  String get debugEntitlementInfo => _debugEntitlementInfo;

  Future<void> updatePurchaseStatus() async {
    if (!_configured) return;
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      
      final activeEntitlements = customerInfo.entitlements.active.keys.toList();
      final allEntitlements = customerInfo.entitlements.all.keys.toList();
      _debugEntitlementInfo = "Active: $activeEntitlements | All: $allEntitlements";
      
      _isPro = _checkEntitlement(customerInfo);
      debugPrint("RevenueCat Update: $_debugEntitlementInfo | IsPro: $_isPro");
      notifyListeners();
    } catch (e) {
      _debugEntitlementInfo = "Error: $e";
      debugPrint("Failed to update RevenueCat status: $e");
      notifyListeners();
    }
  }

  bool _checkEntitlement(CustomerInfo customerInfo) {
    // Log all entitlements to help debug ID mismatches
    final activeEntitlements = customerInfo.entitlements.active.keys.toList();
    final allEntitlements = customerInfo.entitlements.all.keys.toList();
    final allPurchasedProducts = customerInfo.allPurchasedProductIdentifiers;
    
    debugPrint("RevenueCat Active Entitlements: $activeEntitlements");
    debugPrint("RevenueCat All Entitlements: $allEntitlements");
    debugPrint("RevenueCat All Purchased Products: $allPurchasedProducts");

    // Check for explicit Entitlement ID
    bool hasExplicitPro = customerInfo.entitlements.all[_entitlementId]?.isActive ?? false;
    
    // Fallback check 1: if any active entitlement contains "pro" or "smash" (case insensitive)
    bool hasFuzzyPro = customerInfo.entitlements.active.values.any((e) => 
      e.identifier.toLowerCase().contains("pro") || 
      e.identifier.toLowerCase().contains("smash")
    );

    // Fallback check 2: direct product ID check (e.g., if entitlement mapping is missing)
    bool hasPurchasedProduct = allPurchasedProducts.contains('lifetime') || 
                               allPurchasedProducts.contains('remove_ads');

    bool finalStatus = hasExplicitPro || hasFuzzyPro || hasPurchasedProduct;
    
    debugPrint("RevenueCat Final Pro Status: $finalStatus (Explicit: $hasExplicitPro, Fuzzy: $hasFuzzyPro, Product: $hasPurchasedProduct)");
    return finalStatus;
  }

  Future<bool> presentPaywall() async {
    if (!_configured) return false;
    if (_isPro) {
      debugPrint("User is already Pro, skipping paywall.");
      return true;
    }

    try {
      final paywallResult = await RevenueCatUI.presentPaywall();
      debugPrint("Paywall result: $paywallResult");
      
      // Update status after paywall interaction
      await updatePurchaseStatus();
      return _isPro;
    } on PlatformException catch (e) {
      debugPrint("Error presenting RevenueCat Paywall: ${e.message}");
      // Fallback to custom purchase logic if Paywall fails to present
      if (e.code == "MissingPluginException" || e.message?.contains("No implementation found") == true) {
         return await purchaseProManually();
      }
      return false;
    } catch (e) {
      debugPrint("Unexpected error during Paywall: $e");
      return false;
    }
  }

  Future<bool> purchaseProManually() async {
    if (!_configured) return false;
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        // Try to find the lifetime package or first available
        Package package = offerings.current!.availablePackages.firstWhere(
          (p) => p.identifier.toLowerCase().contains("lifetime") || p.packageType == PackageType.lifetime,
          orElse: () => offerings.current!.availablePackages.first,
        );
        
        final purchaseResult = await Purchases.purchase(PurchaseParams.package(package));
        _isPro = _checkEntitlement(purchaseResult.customerInfo);
        notifyListeners();
        return _isPro;
      }
      return false;
    } catch (e) {
      debugPrint("Manual purchase failed: $e");
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    if (!_configured) return false;
    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      _isPro = _checkEntitlement(restoredInfo);
      notifyListeners();
      return _isPro;
    } catch (e) {
      debugPrint("Failed to restore purchases: $e");
      return false;
    }
  }
}

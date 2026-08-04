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
  static const String _apiKey = "test_wPhhtafAuluxazorSsFIelwHEri";

  Future<void> init() async {
    if (kIsWeb) return;

    try {
      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);
      await Purchases.configure(configuration);

      await updatePurchaseStatus();
    } catch (e) {
      debugPrint("RevenueCat initialization failed: $e");
    }
  }

  String _debugEntitlementInfo = "No info fetched yet";
  String get debugEntitlementInfo => _debugEntitlementInfo;

  Future<void> updatePurchaseStatus() async {
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

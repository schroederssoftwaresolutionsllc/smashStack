import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart';

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  bool _isPro = false;
  bool get isPro => _isPro;

  Future<void> init() async {
    if (kIsWeb) return;

    try {
      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration configuration;
      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration("goog_placeholder_id");
      } else {
        configuration = PurchasesConfiguration("appl_placeholder_id");
      }
      await Purchases.configure(configuration);

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      _isPro = customerInfo.entitlements.all["pro"]?.isActive ?? false;
    } catch (e) {
      print("RevenueCat initialization failed: $e");
    }
  }

  Future<bool> purchasePro() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current!.availablePackages.firstWhere((p) => p.identifier == "remove_ads");
      final purchaseResult = await Purchases.purchasePackage(package);
      _isPro = purchaseResult.customerInfo.entitlements.all["pro"]?.isActive ?? false;
      return _isPro;
    } catch (e) {
      return false;
    }
  }

  Future<void> updatePurchaseStatus() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    _isPro = customerInfo.entitlements.all["pro"]?.isActive ?? false;
  }
}

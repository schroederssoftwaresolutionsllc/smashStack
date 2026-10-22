# iOS Deployment Target Upgrade Walkthrough

I have resolved the `Install pods` failure in FlutterFlow CI/CD for iOS deployment by upgrading the iOS Deployment Target to **15.0**.

---

## Root Cause Analysis

The build log showed the following CocoaPods failure during `Install pods`:

```text
[!] CocoaPods could not find compatible versions for pod "Flutter":
  In Podfile:
    Flutter (from `Flutter`)

Specs satisfying the `Flutter (from `Flutter`)` dependency were found, but they required a higher minimum deployment target.
```

The Flutter engine and modern iOS pods (such as `purchases_flutter` 10.17+, `Firebase`, `google_mobile_ads`, and `webview_flutter`) require a minimum iOS deployment target of **15.0**, whereas `ios/Podfile` and `Runner.xcodeproj` were previously configured for iOS 14.0.

---

## Key Changes Made

1. **iOS Deployment Target Upgraded to 15.0**:
   - **File**: [ios/Podfile](file:///Users/john/StudioProjects/smashStack/ios/Podfile#L1-L5)
   - **Change**: Set `platform :ios, '15.0'` and updated `post_install` target configuration to `config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'`.
   - **File**: [ios/Runner.xcodeproj/project.pbxproj](file:///Users/john/StudioProjects/smashStack/ios/Runner.xcodeproj/project.pbxproj#L360-L510)
   - **Change**: Updated Xcode project `IPHONEOS_DEPLOYMENT_TARGET` to `15.0`.

2. **Version Bumped**:
   - **File**: [pubspec.yaml](file:///Users/john/StudioProjects/smashStack/pubspec.yaml)
   - **Change**: Bumped version to `2.0.13+17` for the next CI/CD build cycle.

3. **Git Synchronization**:
   - Tested local CocoaPods resolution (`pod install` completed successfully).
   - Fast-forward merged `main` into `flutterflow`.
   - Pushed commit `863f5e6` to both `origin/main` and `origin/flutterflow`.

---

## Verification Results

- `pod install`: **Completed successfully with 0 errors!**
- `flutter analyze`: **0 issues found!**
- Git Status: Clean working tree, remote branches `main` and `flutterflow` fully synchronized at commit `863f5e6`.
- FlutterFlow CI/CD can now be re-triggered for iOS deployment.

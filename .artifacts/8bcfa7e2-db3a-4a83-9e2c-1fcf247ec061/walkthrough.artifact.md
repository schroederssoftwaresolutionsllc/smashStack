# Gradle Wrapper 8.14 Upgrade Walkthrough

I have resolved the `Build AAB with Flutter` failure in FlutterFlow CI/CD by upgrading the Gradle Wrapper version to **8.14.0**.

---

## Root Cause Analysis

The build log showed the following failure when applying `dev.flutter.flutter-gradle-plugin`:

```text
> Failed to apply plugin 'dev.flutter.flutter-gradle-plugin'.
   > Error: Your project's Gradle version (8.12.0) is lower than Flutter's minimum supported version of 8.14.0. Please upgrade your Gradle version.
     Alternatively, use the flag "--android-skip-build-dependency-validation" to bypass this check.
```

The Flutter SDK environment used on Codemagic / FlutterFlow CI was upgraded to a version requiring a minimum Gradle version of **8.14.0**, whereas `android/gradle/wrapper/gradle-wrapper.properties` was previously configured for Gradle 8.12.

---

## Key Changes Made

1. **Gradle Wrapper Upgraded to 8.14**:
   - **File**: [android/gradle/wrapper/gradle-wrapper.properties](file:///Users/john/StudioProjects/smashStack/android/gradle/wrapper/gradle-wrapper.properties#L1-L6)
   - **Change**: Updated `distributionUrl` to `https://services.gradle.org/distributions/gradle-8.14-all.zip`.

2. **Version Bumped**:
   - **File**: [pubspec.yaml](file:///Users/john/StudioProjects/smashStack/pubspec.yaml)
   - **Change**: Bumped version to `2.0.11+15` for the next CI/CD build cycle.

3. **Git Synchronization**:
   - Committed changes and fast-forward merged `main` into `flutterflow`.
   - Pushed commit `4577c15` to both `origin/main` and `origin/flutterflow`.

---

## Verification Results

- `flutter analyze`: **0 issues found!**
- Git Status: Clean working tree, remote branches `main` and `flutterflow` fully synchronized at commit `4577c15`.
- FlutterFlow CI/CD can now be re-triggered.

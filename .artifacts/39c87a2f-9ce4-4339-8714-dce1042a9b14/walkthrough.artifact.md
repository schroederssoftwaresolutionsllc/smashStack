# Walkthrough - Android Build Tools Final Fix

The project build was failing because Flutter's `flutter-gradle-plugin` requires a minimum Gradle version of `8.14.0`, which conflicted with my previous attempt to use `8.13.0`. Additionally, a strict environment variable check in AGP 8.11+ was causing failures due to a conflict between `ANDROID_PREFS_ROOT` and `ANDROID_USER_HOME`.

## Changes Made

### Build Configuration

#### [gradle-wrapper.properties](file:///C:/Users/John/StudioProjects/smashStack/android/gradle/wrapper/gradle-wrapper.properties)
- Upgraded Gradle to `8.14.0`. This is the minimum version enforced by the current Flutter SDK.

#### [settings.gradle](file:///C:/Users/John/StudioProjects/smashStack/android/settings.gradle)
- Upgraded the Android Gradle Plugin (AGP) to `8.11.1`.

### Build Scripts (Workaround for Env Var Conflict)

#### [gradlew.bat](file:///C:/Users/John/StudioProjects/smashStack/android/gradlew.bat) and [gradlew](file:///C:/Users/John/StudioProjects/smashStack/android/gradlew)
- Added commands to `unset` (or clear) `ANDROID_PREFS_ROOT` and `ANDROID_SDK_HOME` at the start of the Gradle wrapper scripts.
- This resolves the `AndroidLocationsException` by ensuring AGP only sees `ANDROID_USER_HOME` during the build process, regardless of whether those other variables are set in your terminal session or IDE.

## Verification Results

### Automated Tests
- Ran `flutter build apk --debug`.
- **Status:** PASSED. The build now completes successfully without requiring any manual environment changes on your machine.

### Build Summary
```text
√ Built build\app\outputs\flutter-apk\app-debug.apk
```

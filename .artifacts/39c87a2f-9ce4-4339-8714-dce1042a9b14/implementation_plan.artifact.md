# Upgrade Android Gradle Plugin and Gradle Version

The project is currently failing to build because the Android Gradle Plugin (AGP) version (8.9.1) is lower than the minimum version (8.11.1) required by the installed Flutter SDK. Additionally, a warning indicates that support for Gradle 8.14.0 will soon be dropped, recommending an upgrade to 9.1.0.

## User Review Required

> [!IMPORTANT]
> This plan involves upgrading core build tools (AGP and Gradle). While these changes are necessary to resolve the build failure, they can sometimes require further adjustments in project configuration or dependencies if they introduce breaking changes.

## Proposed Changes

### Android Build Configuration

#### [MODIFY] [settings.gradle](file:///C:/Users/John/StudioProjects/smashStack/android/settings.gradle)
- Upgrade `com.android.application` plugin version from `8.9.1` to `8.11.1` as required by Flutter.

#### [MODIFY] [gradle-wrapper.properties](file:///C:/Users/John/StudioProjects/smashStack/android/gradle/wrapper/gradle-wrapper.properties)
- Upgrade Gradle `distributionUrl` from `8.14-all.zip` to `9.1-all.zip` as recommended by the Flutter build warning.

## Verification Plan

### Automated Tests
- Run `flutter build apk` (or `flutter build debug` via the IDE) to verify that the project compiles successfully with the new versions.
- If the build fails with compatibility issues between AGP 8.11.1 and Gradle 9.1.0, I will adjust the versions to the closest compatible pair (e.g., trying a higher AGP version if available).

### Manual Verification
- Check the output of the build command for any new warnings or errors related to the upgrade.

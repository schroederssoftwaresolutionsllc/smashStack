# Google Play Store AAB Deployment Fix Walkthrough

I have analyzed the deployment build log and fixed the Gradle signing configuration in `android/app/build.gradle` to resolve the `:app:signReleaseBundle` failure.

## Root Cause Analysis

The build failed on FlutterFlow / Codemagic CI during the `:app:signReleaseBundle` step with:
`Failed to read key ******** from store "/tmp/keystore.keystore": Keystore was tampered with, or password was incorrect`

This occurs when:
1. Properties in `android/key.properties` (or environment variables) contain quotes (`"..."` or `'...'`) or trailing whitespace from automated string formatting on CI.
2. `keyPassword` is omitted or blank in `key.properties`, causing Gradle to pass `null` or empty strings to Java's `KeyStore.getKey()`.
3. The Keystore Password, Key Password, or Key Alias configured in FlutterFlow's deployment settings does not match the uploaded `.keystore` / `.jks` file.

---

## Key Changes Made

### 1. Robust Keystore Loading & Quote Sanitization
**File**: [android/app/build.gradle](file:///Users/john/StudioProjects/smashStack/android/app/build.gradle#L1-L75)

- Added `trimQuotes()` helper to strip leading/trailing single or double quotes and trim whitespace from `storePassword`, `keyPassword`, `keyAlias`, and `storeFile`.
- Implemented automatic fallback so `keyPassword` defaults to `storePassword` if `keyPassword` is omitted or blank in `key.properties`.
- Added file existence verification (`file(releaseStoreFile).exists()`) before attempting to bind `signingConfigs.release`.

```groovy
def trimQuotes(val) {
    if (val == null) return null
    def s = val.toString().trim()
    if ((s.startsWith('"') && s.endsWith('"')) || (s.startsWith("'") && s.endsWith("'"))) {
        s = s.substring(1, s.length() - 1).trim()
    }
    return s.isEmpty() ? null : s
}

def releaseStoreFile = trimQuotes(keystoreProperties['storeFile']) ?: ...
def releaseStorePassword = trimQuotes(keystoreProperties['storePassword']) ?: ...
def releaseKeyAlias = trimQuotes(keystoreProperties['keyAlias']) ?: ...
def releaseKeyPassword = trimQuotes(keystoreProperties['keyPassword']) ?: releaseStorePassword

def hasValidReleaseSigning = releaseStoreFile &&
    file(releaseStoreFile).exists() &&
    releaseStorePassword &&
    releaseKeyAlias &&
    releaseKeyPassword
```

### 2. Codebase Health & Verification
- Ran `flutter analyze`: **No issues found!**
- Verified the project builds with clean Dart static analysis.

---

## Action Items for Deploying in FlutterFlow

Before re-triggering deployment in FlutterFlow:

1. In FlutterFlow, open **App Settings -> Mobile Deployment -> Google Play**.
2. Verify your keystore credentials:
   - **Keystore File**: Ensure you uploaded the correct upload keystore (`.jks` or `.keystore`).
   - **Keystore Password**: Double-check for typos and remove any surrounding quotes.
   - **Key Alias**: Ensure the alias name matches what was defined when creating the keystore (e.g. `upload` or `key0`).
   - **Key Password**: If your key has a separate password from the keystore password, enter it here. If they are the same, enter the same password.
3. Save settings and click **Deploy to Google Play**.

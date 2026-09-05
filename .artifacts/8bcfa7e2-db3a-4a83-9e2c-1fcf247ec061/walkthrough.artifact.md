# Google Play Publishing Step Walkthrough

Your App Bundle **Version Code 9 (v2.0.5)** was **successfully compiled, signed, and uploaded to Google Play**!

---

## Log Analysis

Looking at the build output:

```text
Uploaded App Bundle /home/builder/clone/build/app/outputs/bundle/release/app-release.aab to Google Play
-- Bundle --
Version code: 9
Sha1: cf71d14ff5c37e13171b95703a6e8ac6ddeb9d84
Sha256: 159658a14aaa2248370aa189f65e3193529946f661ec3993a8213e370bd2639a
```

The upload itself was 100% successful. The failure occurred on the final automated API call:

```text
Setting release for Google Play track internal failed.
Changes cannot be sent for review automatically. Please set the query parameter changesNotSentForReview to true. Once committed, the changes in this edit can be sent for review from the Google Play Console UI.
```

### Why Google Play API Returned This Notice
Google Play requires developer accounts to review and submit releases directly through the **Google Play Console UI** rather than allowing third-party API scripts (like Codemagic/FlutterFlow) to auto-commit and send changes for review automatically without human confirmation.

---

## How to Complete the Release (1 Minute Process)

Since **Version Code 9 is already saved in your Google Play Console**:

1. Log in to [Google Play Console](https://play.google.com/console).
2. Select your app **Smash Stack**.
3. In the left menu, go to **Testing $\rightarrow$ Internal testing** (or **Publishing overview** / **Releases**).
4. You will see **Version Code 9 (2.0.5)** ready in your release library.
5. Click **Edit Release** $\rightarrow$ **Save** $\rightarrow$ **Review release** $\rightarrow$ **Send for review** (or **Start rollout to Internal testing**).

---

## Repository Maintenance

- **Version Bumped**: Updated `pubspec.yaml` to `2.0.6+10` and pushed to both `main` and `flutterflow` branches so any future build will automatically use Version Code 10 without version code collision.
- **Project Health**: `flutter analyze` returned 0 issues.

# Smash Stack — Google Play appeal drafts

Package: `com.schroederssoftwaresolutions.smashstack`

Three separate enforcement items, three separate appeals. Square brackets mark
facts you must fill in or confirm before sending — do not send with placeholders
in place, and do not send appeals 2 and 3 until you have actually watched Google
sign-in succeed in a Play-signed build.

---

## 1. App removal — Invalid Privacy Policy (removed Apr 7, 2026)

Send this one first. It is independent of the build fix, and until it is lifted
the listing stays down no matter what you upload.

> Smash Stack was removed on April 7, 2026 under the Privacy Policy section of
> the User Data policy, because the privacy policy link in the Play Console did
> not lead to a privacy policy page. That has been corrected.
>
> The privacy policy is now live and publicly accessible at
> https://schroederssoftwaresolutions.com/privacy-policy.html and at
> https://ssswebsite-ac029.web.app/privacy-policy.html. Both URLs load the same
> document with no login, no redirect, and no paywall.
>
> The policy is specific to this app rather than generic. Section 20 lists Smash
> Stack by package name and states the data the app collects (email address,
> display name and account identifier when a user signs in with Google or Apple;
> game progress and profile content; crash logs and performance diagnostics;
> device and technical information; advertising identifier; in-app purchase
> history), the third parties that receive it (Firebase Authentication, Cloud
> Firestore, Firebase Crashlytics, Firebase Performance Monitoring, Google
> AdMob, RevenueCat), the advertising practices, and the account deletion route
> with a 45-day response commitment. The policy also sets out retention periods,
> children's privacy practices, and user rights.
>
> We believe the app now complies with the User Data policy and we ask that the
> removal be lifted so the listing can be restored.

---

## 2. Update rejected — Broken Functionality (Sep 8, 2026)

> Version 2.0.7 (version code 11) was rejected on September 8, 2026 under the
> Broken Functionality policy for unresponsive UI elements. The reported
> behavior — selecting a Google account and being returned to the login screen
> with nothing happening — was reproducible, and we have identified and fixed
> the cause.
>
> Root cause: the `google-services.json` compiled into the bundle was out of
> date. It carried OAuth clients for four of the five certificates registered to
> this app in Firebase, but not for the Play app signing certificate (SHA-1
> `8458ba196d9b59a77be2e2f34bd82b18c9aff6f7`). Because Google Play re-signs
> uploads with the app signing key, every install from Play requested an OAuth
> client that did not exist in the binary, and Google Sign-In failed with
> DEVELOPER_ERROR. Builds signed with our upload key were unaffected, which is
> why the defect did not appear in our own testing. Compounding this, the
> sign-in code caught only `FirebaseAuthException`, so the `PlatformException`
> carrying this error went unhandled and no message was shown to the user — the
> screen simply appeared to do nothing.
>
> Both problems are fixed in version [VERSION] (version code [CODE]):
>
> 1. `google-services.json` has been regenerated from the Firebase console and
>    now includes the OAuth client for the app signing certificate.
> 2. Sign-in error handling now catches `PlatformException` and all other
>    failures and shows the user a clear, actionable message rather than failing
>    silently.
>
> On [DATE] we verified that Google sign-in completes successfully in a build
> installed from our [internal/closed] test track, signed with the Play app
> signing key — the same signing path as a production install. We ask that this
> rejection be reconsidered.

---

## 3. Update rejected — Developer Program policies, unspecified (Sep 9, 2026)

This notice names no specific policy, so the appeal does two things: addresses
what we can identify, and asks for detail on anything else.

> Version code 11 was rejected on September 9, 2026 for not adhering to Google
> Play Developer Program policies. The notice in Play Console does not identify
> a specific policy or the content at issue, so we have addressed the defects we
> are aware of and would appreciate detail on anything further.
>
> We believe this enforcement relates to the same defect cited in the Broken
> Functionality rejection of September 8. Google Sign-In failed in Play-signed
> builds because the `google-services.json` in the bundle lacked the OAuth
> client for the app signing certificate, leaving the login screen unresponsive
> with no error message. Both the configuration and the error handling are fixed
> in version [VERSION] (version code [CODE]), verified on [DATE] in a Play-signed
> build installed from our [internal/closed] test track.
>
> Separately, the privacy policy link that led to the April 7 removal has been
> corrected. The policy is live at
> https://schroederssoftwaresolutions.com/privacy-policy.html and includes
> app-specific disclosures for this package in Section 20.
>
> If this rejection concerns something other than these two issues, we would be
> grateful for the specific policy and the content or behavior at issue so that
> we can address it directly.

---

## Before you send

- **Order matters.** Send appeal 1 now. Hold 2 and 3 until the fixed build is
  uploaded and you have personally watched sign-in complete on a Play-signed
  install. An appeal that claims a fix you have not verified is the fastest way
  to lose credibility with the reviewer.
- **Fill every bracket.** Version, version code, date, and which test track.
- **Version code 11 is burned.** The fixed build must be 12 or higher on Play,
  and Apple has also consumed build 11.
- **Consider switching the Play privacy policy URL** from
  `ssswebsite-ac029.web.app` to `schroederssoftwaresolutions.com`. Both serve the
  same page, but the custom domain matches what Section 18 of the policy itself
  states, and a `*.web.app` subdomain reads as more disposable to a reviewer
  looking at an app removed for a bad policy link.
- **Section 20 lists Smash Stack as Android only.** Update it to iOS / Android
  before the App Store submission — Apple checks that the policy covers the app
  under review.

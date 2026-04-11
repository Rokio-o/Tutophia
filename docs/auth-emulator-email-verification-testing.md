# Auth Emulator Email Verification Testing

This guide covers local testing for Tutophia sign-up, sign-in, allowed email domain checks, student age blocking, and email verification using the Firebase Authentication Emulator.

## Prerequisites

- Firebase CLI available through `npx -y firebase-tools@latest`
- Flutter SDK installed
- This repository configured with the existing Firebase files already in the repo

## 1. Start the emulators

Run the Firebase emulators from the repo root:

```bash
npx -y firebase-tools@latest emulators:start --only auth,firestore,storage
```

If you also want the rest of the local Firebase stack for broader app testing, run:

```bash
npx -y firebase-tools@latest emulators:start
```

Useful local ports in the default setup:

- Auth Emulator: `9099`
- Firestore Emulator: `8080`
- Storage Emulator: `9199`
- Emulator Suite UI: `4000`

## 2. Connect the Flutter app to the local Firebase emulators

Tutophia now supports debug-only emulator wiring through Dart defines.

When `USE_FIREBASE_EMULATORS=true` is enabled, the app now connects to:

- Firebase Auth emulator on `9099`
- Firestore emulator on `8080`
- Cloud Functions emulator on `5001`
- Cloud Storage emulator on `9199`

Typical local run command:

```bash
flutter run --dart-define=USE_FIREBASE_EMULATORS=true
```

If you are using a physical device or a custom host, also pass the host explicitly:

```bash
flutter run --dart-define=USE_FIREBASE_EMULATORS=true --dart-define=FIREBASE_EMULATOR_HOST=192.168.1.7
```

Host notes by platform:

- Android emulator: the app maps `localhost` to `10.0.2.2` automatically
- iOS simulator: `localhost` usually works
- Flutter web: the app maps `localhost` to `127.0.0.1`
- Physical Android or iOS device: use your machine LAN IP with `FIREBASE_EMULATOR_HOST`

Do not enable these Dart defines in production builds.

## 2.1 Storage emulator notes

The new session materials upload flow writes files to Cloud Storage and metadata to Firestore.

That means local upload testing now requires the Storage emulator to be running alongside Firestore and Auth.

Typical local materials test flow:

1. Start the emulators.
2. Run the Flutter app with `USE_FIREBASE_EMULATORS=true`.
3. Upload a file as a tutor.
4. Confirm the file appears in the Emulator Suite Storage tab.
5. Confirm the matching metadata document appears in Firestore under `sessionMaterials`.

## 3. Create test users

You can create test users in two practical ways:

1. Use the Tutophia sign-up flow in the app.
2. Use the Authentication tab in the Emulator Suite UI at `http://127.0.0.1:4000`.

Recommended test addresses:

- Allowed domain: `student1@school.edu`
- Allowed domain: `tutor1@tip.edu.ph`
- Allowed subdomain: `student1@cics.tip.edu.ph`
- Disallowed domain: `student1@gmail.com`
- Disallowed non-edu suffix: `student1@school.com`
- Disallowed lookalike suffix: `student1@school.education`

## 4. Test allowed vs disallowed signup domain

Expected app behavior:

- any address ending in `.edu` can continue through registration
- any address ending in `.edu.ph` can continue through registration
- subdomains under `.edu.ph` such as `name@campus.tip.edu.ph` can continue through registration
- any disallowed address is also blocked before Firestore profile creation

Test steps:

1. Open student registration and enter `student1@gmail.com`.
2. Confirm the form shows the allowed-domain validation error.
3. Complete the flow anyway if possible and verify the terms screen still blocks account creation.
4. Repeat with `student1@school.edu` and confirm account creation proceeds.
5. Repeat with `student1@tip.edu.ph` and confirm account creation proceeds.
6. Repeat with `student1@cics.tip.edu.ph` and confirm account creation proceeds.
7. Repeat the same checks in tutor registration.

## 5. Test blocked underage student registration

Expected behavior:

- students aged `17` or below cannot register
- the app shows a clear validation message before Firebase Auth is called

Test steps:

1. Open student registration.
2. Pick a birthdate that results in age `17` or below.
3. Confirm the form blocks the next step with the age validation message.
4. If you reach the terms screen with edited data, confirm account creation is still blocked there.
5. Repeat with age `18` or above and confirm registration can continue.

Tutor registration should remain unaffected by this age restriction.

## 6. Test signup and unverified login behavior

Expected behavior after sign-up:

- account is created in Firebase Auth
- Firestore profile is created under `Users/{uid}`
- verification email is triggered
- the app opens the Verify Email screen instead of a dashboard

Expected behavior on login:

- correct credentials with `emailVerified = false` should never reach the student or tutor dashboard
- the app must route to the Verify Email screen

Test steps:

1. Register a new allowed-domain user.
2. Confirm the app lands on the Verify Email screen.
3. Sign out from that screen and log in again without verifying.
4. Confirm the app returns to the Verify Email screen instead of a dashboard.

## 7. Verify a test email in the emulator flow

The Auth Emulator does not send real emails.

Instead, the email action link is exposed locally in emulator output:

- Emulator Suite UI logs
- terminal output from `emulators:start`

Test steps:

1. Register a user or tap `Resend verification email` on the Verify Email screen.
2. Open the Emulator Suite UI or terminal logs.
3. Find the generated verification action link.
4. Open that link in your browser.
5. Return to the app and tap `I have verified my email`.

Expected result:

- the app reloads the Firebase user
- `emailVerified` becomes `true`
- the user is routed to the correct dashboard based on the Firestore role

## 8. Test resend verification

Expected behavior:

- the Verify Email screen allows resend
- resend uses a short cooldown to avoid duplicate requests

Test steps:

1. Sign in with an unverified account.
2. Tap `Resend verification email`.
3. Confirm a success message appears.
4. Confirm the button is temporarily disabled during cooldown.
5. Confirm a new verification link appears in the emulator logs.

## 9. Confirm verified users can reach dashboards

Test steps:

1. Verify a student test account through the emulator link.
2. Tap `I have verified my email`.
3. Confirm the app routes to the student dashboard.
4. Repeat for a tutor test account.
5. Restart the app while the verified user is still signed in.
6. Confirm the splash flow routes directly to the correct dashboard.

Expected startup behavior:

- no signed-in user: login screen
- signed-in but unverified user: Verify Email screen
- signed-in and verified user: role-based dashboard

## Local vs production notes

- In the emulator, verification links stay local and do not send real email.
- In production, Firebase sends the verification email through the real Firebase Auth email flow configured for the project.
- For production testing, make sure Email/Password sign-in is enabled in the Firebase console.
- This repo still relies on Firestore role documents under `Users/{uid}`. Verified email alone is not enough; the correct role document must also exist.
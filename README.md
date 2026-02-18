# WhatsApp Clone (Flutter + Firebase Backend)

This repository now contains a **production-minded starter blueprint** for building a WhatsApp-like chat app with Flutter and a full backend setup using Firebase services.

## 1) Stack

- **Flutter** (cross-platform client)
- **Firebase Authentication** (phone auth)
- **Cloud Firestore** (chat, user profile, conversations)
- **Firebase Storage** (media uploads)
- **Firebase Cloud Messaging** (push notifications)
- **Cloud Functions** (server-side validation, fan-out notifications)
- **Riverpod** (state management + DI)

---

## 2) Project structure

```txt
lib/
  app.dart
  main.dart
  core/
    backend/
      backend_service.dart
      firebase_collections.dart
    config/
      app_environment.dart
      firebase_bootstrap.dart
  features/
    auth/
      auth_repository.dart
    chat/
      chat_repository.dart
    common/
      models.dart
```

---

## 3) Backend setup (Firebase)

## 3.1 Create Firebase project

1. Go to Firebase Console.
2. Create a new project (e.g., `whatsapp-clone`).
3. Add Android, iOS, and optional Web apps.
4. Download:
   - `google-services.json` for Android → `android/app/`
   - `GoogleService-Info.plist` for iOS → `ios/Runner/`

## 3.2 Enable services

- Authentication → enable **Phone** provider.
- Firestore Database → create in production mode.
- Storage → initialize bucket.
- Cloud Messaging → keep enabled.
- Functions → initialize with Firebase CLI.

## 3.3 Install Firebase CLI and init functions

```bash
npm install -g firebase-tools
firebase login
firebase init
```

Select:
- Firestore
- Storage
- Functions
- Emulators (optional, recommended)

---

## 4) Flutter dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  firebase_storage: ^12.3.3
  firebase_messaging: ^15.1.3
  uuid: ^4.5.1
```

Then run:

```bash
flutter pub get
```

---

## 5) Generate Firebase options

Use FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` for supported platforms.

> The starter in this repo wraps Firebase initialization with environment-aware bootstrap logic (`FirebaseBootstrap`).

---

## 6) Firestore data model (recommended)

### `users/{uid}`

```json
{
  "uid": "...",
  "phoneNumber": "+123456789",
  "displayName": "User name",
  "photoUrl": "...",
  "about": "Hey there! I am using this clone.",
  "lastSeenAt": "timestamp",
  "isOnline": true,
  "createdAt": "timestamp"
}
```

### `conversations/{conversationId}`

```json
{
  "participants": ["uid_a", "uid_b"],
  "lastMessage": "Hi",
  "lastMessageType": "text",
  "lastMessageAt": "timestamp",
  "unreadCount": {
    "uid_a": 0,
    "uid_b": 3
  },
  "createdAt": "timestamp"
}
```

### `conversations/{conversationId}/messages/{messageId}`

```json
{
  "senderId": "uid_a",
  "type": "text",
  "text": "Hello",
  "mediaUrl": null,
  "sentAt": "timestamp",
  "deliveredTo": ["uid_b"],
  "readBy": ["uid_b"],
  "replyToMessageId": null
}
```

---

## 7) Suggested Firestore rules (baseline)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function signedIn() {
      return request.auth != null;
    }

    function isParticipant(conversationId) {
      return signedIn() && request.auth.uid in
        get(/databases/$(database)/documents/conversations/$(conversationId)).data.participants;
    }

    match /users/{uid} {
      allow read: if signedIn();
      allow create, update: if signedIn() && request.auth.uid == uid;
    }

    match /conversations/{conversationId} {
      allow read, update: if isParticipant(conversationId);
      allow create: if signedIn() && request.resource.data.participants is list;

      match /messages/{messageId} {
        allow read: if isParticipant(conversationId);
        allow create: if isParticipant(conversationId)
          && request.resource.data.senderId == request.auth.uid;
      }
    }
  }
}
```

---

## 8) Suggested Storage rules (baseline)

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /chat_media/{conversationId}/{fileName} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 9) Cloud Function idea for notifications

On new message creation:
- Read recipient FCM tokens.
- Send push with sender name + preview.
- Optionally skip if recipient is online.

Example trigger path:
`conversations/{conversationId}/messages/{messageId}`

---

## 10) What this starter already includes

- Environment and Firebase bootstrap abstraction.
- Typed collection naming constants.
- Auth repository with phone auth entry points.
- Chat repository for sending messages and streaming conversation messages.
- Shared model objects for users and messages.

Use this as your backend-ready foundation and then add:
- Contact sync
- Group chats
- Voice notes
- Read receipts UI
- Media compression
- End-to-end encryption strategy (custom, if required)

---

## 11) Run

```bash
flutter run
```

If this is a fresh repo, initialize Flutter app shell first:

```bash
flutter create .
```

Then keep `lib/` files from this repository.

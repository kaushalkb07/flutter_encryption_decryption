# Secure Key Exchange for Messaging

This project is part of a **secure messaging system**, built using Flutter with Clean Architecture.

It handles:
- Asymmetric key pair generation (X25519 for E2EE)
- Uploading the public key to a custom backend API
- Secure communication via public/private key encryption
- Clean separation of UI, domain, and data logic

> Public keys are shared. Private keys stay on-device. This supports secure message encryption & decryption between users.

---

## API Spec <br> `/api/upload-key`

```bash
{
  "user_id": "user_001",
  "public_key": "base64_encoded_public_key"
}
```

---
# Example Use Case in Chat App

- Alice generates her own key pair on device.
- Alice's public key is uploaded to the server.
- Bob retrieves Alice’s public key from the server.
- Bob encrypts message using Alice’s public key.
- Alice decrypts the message using her private key.

> Enables End-to-End Encryption (E2EE) using asymmetric cryptography (like Signal, WhatsApp, etc.).

---

## 🛠️ Tech Stack

- [Flutter](https://flutter.dev/)
- [cryptography](https://pub.dev/packages/cryptography)
- [http](https://pub.dev/packages/http)

---
## Getting Started


1. Clone this repository:
    ```bash
    git clone https://github.com/kaushalkb07/ride_sharing_app.git
    cd ride_sharing_app
    ```
2. Install dependencies:
    ```bash
    flutter pub get
    ```
3. Run the app:
    ```bash
    flutter run
    ```
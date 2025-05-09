
# 🏥 Lifeline

**Lifeline** is a mobile application designed to streamline healthcare access by enabling users to book doctor appointments, call doctors, view nearby hospitals, and reach emergency services quickly. Built using Flutter and integrated with powerful APIs and services, Lifeline offers a seamless healthcare experience for patients.

## 🚀 Features

* 📞 **Call a Doctor**
  Users can directly call registered doctors through the app using the `url_launcher` package.

* 🗓️ **Book Appointments**
  Simple and efficient appointment booking system with visibility of upcoming appointments. Data is managed using Firebase Realtime Database.

* 🏥 **Nearby Hospitals**
  Displays hospitals near the user’s current location using the Open Maps API (OpenStreetMap integration).

* 🚨 **Emergency Services Call**
  A dedicated emergency button allows users to instantly call emergency services. This feature is implemented using native Kotlin code for Android.

* 🔐 **User Authentication**
  Secure sign-up and login using Firebase Authentication.

## 🛠️ Tech Stack

* **Flutter** – Frontend framework
* **Firebase** – Authentication and real-time database
* **Open Maps API** – Display nearby hospitals
* **url_launcher** – Launching phone call actions
* **Kotlin (Android)** – Native integration for emergency calls

## 🧑‍💻 Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/lifeline.git
   cd lifeline
   ```
2. Install dependencies:

   ```bash
   flutter pub get
   ```
3. Run the app:

   ```bash
   flutter run
   ```

## 🔐 Firebase Setup

* Set up Firebase project in the [Firebase Console](https://console.firebase.google.com/)
* Add your `google-services.json` file to `android/app`
* Configure Firebase Authentication and Realtime Database

## 📍 Map API Setup

* Set up OpenStreetMap integration or any preferred maps provider for nearby hospital locations.


---

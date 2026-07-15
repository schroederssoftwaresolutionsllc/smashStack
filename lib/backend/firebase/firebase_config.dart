import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAgwDCvUp0CS_2tFx5_EltC-KbCiKwiM30",
            authDomain: "smash-stack-7a6b6.firebaseapp.com",
            projectId: "smash-stack-7a6b6",
            storageBucket: "smash-stack-7a6b6.firebasestorage.app",
            messagingSenderId: "399996765332",
            appId: "1:399996765332:web:1ae7b6ee266a9a8d052081",
            measurementId: "G-3D6KB38RDF"));
  } else {
    await Firebase.initializeApp();
  }
}

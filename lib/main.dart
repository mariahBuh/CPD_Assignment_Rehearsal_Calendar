//Imported the required packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:assignment_calendar/screens/home_Screen.dart';
import 'firebase_options.dart';
import 'notifications.dart'; 

// Main function
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the notification service
    await NotificationService().init();
    
    runApp(const MainApp());
}

// MainApp widget
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Home screen
      home: HomeScreen(),
    );
  }
}



import 'package:flutter/material.dart';

// Welcome widget
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  //Creating the stateless widget required and then displaying it in the Home screen 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Welcome to the Rehearsal Calendar!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:assignment_calendar/screens/add_rehearsal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rehearsal Calendar',style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold
        ),),
        backgroundColor: const Color(0xFF165E7F),centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No Rehearsals Added.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddRehearsalScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 48),
                  backgroundColor: const Color(0xFF165E7F),
                ),
                child: const Text(
                  'Add Rehearsal',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



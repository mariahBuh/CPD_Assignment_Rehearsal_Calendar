import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'add_rehearsal.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Reference to "rehearsals" in Realtime Database
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref('rehearsals');

  //To Store all rehearsals here
  List<Map<String, dynamic>> _rehearsals = [];

  @override
  void initState() {
    super.initState();
    // Check for data changes in "rehearsals" node
    _database.onValue.listen((event) {
      if (event.snapshot.value == null) {
        setState(() {
          _rehearsals = [];
        });
      } else {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final items = <Map<String, dynamic>>[];

        data.forEach((key, value) {
          items.add({
            'key': key,
            'title': value['title'] ?? '',
            'date': value['date'] ?? '',
            'start_time': value['start_time'] ?? '',
            'end_time': value['end_time'] ?? '',
            'location': value['location'] ?? '',
          });
        });

        setState(() {
          _rehearsals = items;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rehearsal Calendar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF165E7F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _rehearsals.isEmpty
            ? const Center(
                child: Text(
                  'No Rehearsals Added.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: _rehearsals.length,
                itemBuilder: (context, index) {
                  final item = _rehearsals[index];
                  final title = item['title'];
                  final date = item['date'];
                  final startTime = item['start_time'];
                  final endTime = item['end_time'];
                  final location = item['location'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                        color: Color(0xFF165E7F),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rehearsal Title
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          // Date
                          Text(
                            date,
                            style: const TextStyle(color: Colors.white),
                          ),
                          // Time range
                          Text(
                            '$startTime - $endTime',
                            style: const TextStyle(color: Colors.white),
                          ),
                          // Location
                          Text(
                            location,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      // Button at the bottom to add a new rehearsal
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddRehearsalScreen()),
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
      ),
    );
  }
}

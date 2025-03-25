//Imported the required packages
import 'package:assignment_calendar/notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_Screen.dart';
import 'package:geolocator/geolocator.dart';

// AddRehearsalScreen class
class AddRehearsalScreen extends StatefulWidget {
  const AddRehearsalScreen({super.key});
  
  // Creating a new state object
  @override
  State<AddRehearsalScreen> createState() => _AddRehearsalScreenState();
}

// Creating a new state class
class _AddRehearsalScreenState extends State<AddRehearsalScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field variables
  String _title = '';
  String _date = '';
  String _startTime = '';
  String _endTime = '';
  String _location = '';

  // Controller for the location field
  final TextEditingController _locationController = TextEditingController();

  // Reference to the "rehearsals" node in Realtime Database
  final DatabaseReference _rehearsalsRef =
      FirebaseDatabase.instance.ref().child('rehearsals');

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    // Printing a message to the console to check if its working
    print("Use current location tapped!");

    // For web, skip service and permission checks because they are causing errors and its not working.
    if (kIsWeb) {

      // Getting the current position
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        // Setting the state of the location
        setState(() {
          // Setting the location to the current position
          _location = "${position.latitude}, ${position.longitude}";

          // Setting the location controller text to the location
          _locationController.text = _location;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error retrieving location: $e")),
        );
      }
      return;
    }

    // Mobile: Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    // Mobile: Check location permissions.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }
    }

    // Mobile: Check location permissions permanently denied.
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Location permissions are permanently denied, we cannot request permissions.")),
      );
      return;
    }

    try {
      // Mobile: Get current position.
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        // Set the location to the current position
        _location = "${position.latitude}, ${position.longitude}";
        // Set the location controller text to the location
        _locationController.text = _location;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error retrieving location: $e")),
      );
    }
  }

  // Function to save rehearsal data to Firebase
  Future<void> _saveRehearsal() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new child with a unique key and set its value
      final newRehearsalRef = _rehearsalsRef.push();
      await newRehearsalRef.set({
        'title': _title,
        'date': _date,
        'start_time': _startTime,
        'end_time': _endTime,
        'location': _location,
      });

      // Trigger a notification after saving the rehearsal
      NotificationService().showNotification(
        id: DateTime.now().millisecondsSinceEpoch % 100000, 
        title: 'Rehearsal Added',
        body: '$_title on $_date at $_location',
        
      );

      print('Notification triggered!');

      // After saving, navigate back
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  // Dispose the location controller
  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // Helper method to build a rounded outline input decoration
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xFF165E7F)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xFF165E7F)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xFF165E7F), width: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Widget for the Add Rehearsal screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Rehearsal', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color(0xFF165E7F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Rehearsal Title Field
              TextFormField(
                decoration: _buildInputDecoration('Rehearsal Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a rehearsal title.';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!.trim(),
              ),
              const SizedBox(height: 16),

              // Date Field
              TextFormField(
                decoration: _buildInputDecoration('Date of Rehearsal'),
                readOnly: true,
                controller: TextEditingController(text: _date),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _date = pickedDate.toString().split(' ')[0];
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Start Time & End Time Fields
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: _buildInputDecoration('Start Time'),
                      readOnly: true,
                      controller: TextEditingController(text: _startTime),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _startTime = pickedTime.format(context);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: _buildInputDecoration('End Time'),
                      readOnly: true,
                      controller: TextEditingController(text: _endTime),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _endTime = pickedTime.format(context);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location Field
              TextFormField(
                decoration: _buildInputDecoration('Location'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a location.';
                  }
                  return null;
                },
                controller: _locationController,
                onSaved: (value) => _location = value!.trim(),
              ),
              const SizedBox(height: 8),

              // Clickable text to use current GPS location
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: _getCurrentLocation,
                  child: const Text(
                    "Use current location",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Add Rehearsal Button
                  ElevatedButton(
                    onPressed: _saveRehearsal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF165E7F),
                      minimumSize: const Size(130, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Add Rehearsal',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // View All Rehearsals Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF165E7F),
                      minimumSize: const Size(130, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'View All Rehearsals',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

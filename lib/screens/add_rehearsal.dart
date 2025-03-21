import 'package:flutter/material.dart';

class AddRehearsalScreen extends StatefulWidget {
  const AddRehearsalScreen({super.key});

  @override
  State<AddRehearsalScreen> createState() => _AddRehearsalScreenState();
}

class _AddRehearsalScreenState extends State<AddRehearsalScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _date = '';
  String _startTime = '';
  String _endTime = '';
  String _location = '';

  void _saveRehearsal() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Add Firebase or other storage logic here
      // For now, just pop back to home or navigate
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rehearsal Calendar',style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold
        ),),
        backgroundColor: const Color(0xFF165E7F),centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // REHEARSAL TITLE
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

              // DATE OF REHEARSAL
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

              // START TIME & END TIME 
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

              // LOCATION
              TextFormField(
                decoration: _buildInputDecoration('Location'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a location.';
                  }
                  return null;
                },
                onSaved: (value) => _location = value!.trim(),
              ),
              const SizedBox(height: 16),

              // BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveRehearsal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF165E7F),
                      minimumSize: const Size(130, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Add Rehearsal', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF165E7F),
                      minimumSize: const Size(130, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('View All Rehearsals', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
}


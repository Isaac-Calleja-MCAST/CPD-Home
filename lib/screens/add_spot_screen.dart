import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/spot_provider.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  // This controller captures the users input text
  final _titleController = TextEditingController();

  void _saveSpot() {
    // To not save if the title is empty
    if (_titleController.text.isEmpty) {
      return;
    }

    // to add the spot
    // For now, empty strings for images and fake numbers for GPS
    Provider.of<SpotProvider>(context, listen: false).addSpot(
      _titleController.text,
      '', // Image path 
      69.69, // Fake Latitude
      69.69, // Fake Longitude
    );

    // Close this screen and go back to the list
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Malta Spot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Spot Name (e.g. Blue Lagoon)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveSpot,
              icon: const Icon(Icons.save),
              label: const Text('Save Spot'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Makes button full width
              ),
            ),
          ],
        ),
      ),
    );
  }
}
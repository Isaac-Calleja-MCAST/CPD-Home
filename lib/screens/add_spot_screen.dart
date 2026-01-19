import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/spot_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  // This controller captures the users input text
  final _titleController = TextEditingController();
  File? _pickedImage; // This stores the photo

  // camera logic
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    // This opens the native phone camera
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600, // Optimize for performance (E&C3 requirement), 
    ); // 600px because it looks good as an icon and file sizes much smaller than the original.

    if (imageFile == null) return;

    setState(() {
      _pickedImage = File(imageFile.path); // Save the image to our variable
    });
  }

  void _saveSpot() {
    // To not save if the title is empty
    if (_titleController.text.isEmpty || _pickedImage == null) {
      // show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a title and a photo!')),
      );
      return;
    }

    // to add the spot
    // For now, empty strings for images and fake numbers for GPS
    Provider.of<SpotProvider>(context, listen: false).addSpot(
      _titleController.text,
      _pickedImage!.path, // Image path
      69.69, // Fake Latitude
      69.69, // Fake Longitude
    );

    // Close this screen and go back to the list
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Malta Spot')),
      body: SingleChildScrollView(
        // switched from padding to singlechildscrollview so keyboard doesnt cover anything.
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
            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: _pickedImage != null
                  ? Image.file(
                      _pickedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Center(child: Text('No Image Taken')),
            ),
            TextButton.icon(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera),
              label: const Text('Take Photo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveSpot,
              icon: const Icon(Icons.save),
              label: const Text('Save Spot'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(
                  50,
                ), // Makes button full width
              ),
            ),
          ],
        ),
      ),
    );
  }
}

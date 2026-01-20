import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/spot_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  // This controller captures the users input text
  final _titleController = TextEditingController();
  File? _pickedImage; // This stores the photo
  double? _latitude; // This stores the latitude
  double? _longitude; // This stores the longitude

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

  // location logic
  Future<void> _getLocation() async {
    // 1. Check if location services are enabled on the phone
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    // 2. Ask the user for permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // 3. Get the actual coordinates
    final position = await Geolocator.getCurrentPosition();

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _showNotification(String title) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'malta_spots_channel',
          'Spot Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Spot Saved!',
      'Successfully added "$title" to your collection.',
      const NotificationDetails(android: androidDetails),
    );
  }

  void _saveSpot() async {
    // To not save if the title is empty
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _latitude == null ||
        _longitude == null) {
      // show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a title, a photo, and location!'),
        ),
      );
      return;
    }

    // to save the spot
    // For now, empty strings for images and fake numbers for GPS
    Provider.of<SpotProvider>(context, listen: false).addSpot(
      _titleController.text,
      _pickedImage!.path, // Image path
      _latitude!, // Latitude
      _longitude!, // Longitude
    );
    
    await FirebaseAnalytics.instance.logEvent(
      name: 'spot_saved',
      parameters: {
        'spot_name': _titleController.text,
      },
    );

    // show notification
    await _showNotification(_titleController.text);

    if (!mounted) return; // added this line because of an 'async gap' for context
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
            // Image Preview area
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
            const Divider(),
            // GPS Area
            Text(
              _latitude == null
                  ? 'No Location Selected'
                  : 'Location: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}',
            ), // 4 decimal places
            TextButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
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

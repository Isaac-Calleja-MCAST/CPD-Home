import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/spot_provider.dart';
import 'add_spot_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Malta Spots'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // listener for changes
      body: Consumer<SpotProvider>(
        builder: (ctx, spotProvider, child) => spotProvider.items.isEmpty
            ? const Center(child: Text('No spots added yet. Start exploring!'))
            : ListView.builder(
                itemCount: spotProvider.items.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(
                    // If the image path is empty, show icon. Otherwise, show the photo.
                    backgroundImage: spotProvider.items[i].imagePath.isEmpty
                        ? null
                        : FileImage(File(spotProvider.items[i].imagePath)),
                    child: spotProvider.items[i].imagePath.isEmpty
                        ? const Icon(Icons.pin_drop)
                        : null,
                  ),
                  title: Text(spotProvider.items[i].title),
                  subtitle: Text('Lati: ${spotProvider.items[i].latitude.toStringAsFixed(4)}, Long: ${spotProvider.items[i].longitude.toStringAsFixed(4)}'),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add screen
          Navigator.of(context,).push(
            MaterialPageRoute(builder: (ctx) => const AddSpotScreen()));
        },
        // REQUIREMENT: Platform-aware design choice
        child: Icon(Platform.isIOS ? CupertinoIcons.add : Icons.add),
      ),
    );
  }
}

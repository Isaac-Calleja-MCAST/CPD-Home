import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/spot_provider.dart';

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
                  leading: const CircleAvatar(
                    child: Icon(Icons.place), // Placeholder for image later
                  ),
                  title: Text(spotProvider.items[i].title),
                  subtitle: Text('Lat: ${spotProvider.items[i].latitude}'),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print('Add button clicked');
        },
        tooltip: 'Add Spot',
        child: const Icon(Icons.add),
      ),
    );
  }
}
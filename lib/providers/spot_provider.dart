import 'package:flutter/material.dart';
import '../models/spot.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SpotProvider with ChangeNotifier {
  // list of spots
  List<Spot> _items = [];

  // A way for the UI to see the list
  List<Spot> get items => [..._items];

  // Logic to load data when the app starts
  void loadSpots() {
    final box = Hive.box('spotsBox');

    if (box.isNotEmpty) {
      _items = box.values.map((item) {
        return Spot(
          id: item['id'],
          title: item['title'],
          imagePath: item['imagePath'],
          latitude: item['lat'],
          longitude: item['lng'],
        );
      }).toList();
    }
    notifyListeners();
  }

  // to add a new spot
  void addSpot(String title, String path, double lat, double lng) {
    final newId = DateTime.now().toString();
    final newSpot = Spot(
      id: newId,
      title: title,
      imagePath: path,
      latitude: lat,
      longitude: lng,
    );

    _items.add(newSpot);

    // Save to the database
    final box = Hive.box('spotsBox');
    box.put(newId, {
      'id': newId,
      'title': title,
      'imagePath': path,
      'lat': lat,
      'lng': lng,
    });

    // to refresh screen.
    notifyListeners();
  }
}

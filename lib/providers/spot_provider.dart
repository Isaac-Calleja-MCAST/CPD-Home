import 'package:flutter/material.dart';
import '../models/spot.dart';

class SpotProvider with ChangeNotifier {
  // list of spots 
  final List<Spot> _items = [
  ];

  // A way for the UI to see the list
  List<Spot> get items => [..._items];

  // to add a new spot
  void addSpot(String title, String path, double lat, double lng) {
    final newSpot = Spot(id: DateTime.now().toString(), title: title, imagePath: path, latitude: lat, longitude: lng); // I used the Datetime as an id, because automatically each id will be a unique Id.
    _items.add(newSpot);
    
    // to refresh screen.
    notifyListeners(); 
  }
}
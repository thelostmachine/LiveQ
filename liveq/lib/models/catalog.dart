import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:liveq/utils/services.dart';

class CatalogModel with ChangeNotifier {
  static const String SOUNDCLOUD = 'SoundCloud';
  static const String SPOTIFY = 'Spotify';
  static const String APPLE = 'Apple Music';

  final List<Service> potentialServices = [Spotify(), SoundCloud()];
  Set<Service> connectedServices = {};

  CatalogModel() {
    loadServices();
  }

  /// Adds [service] to connectedServices.
  void addToConnectedServices(Service service) {
    connectedServices.add(service);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Adds [service] to connectedServices.
  void removeFromConnectedServices(Service service) {
    connectedServices.remove(service);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all services from the set of connected services.
  void removeAllFromConnectedServices() {
    connectedServices.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  Future<void> saveServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> serviceStrings = List();
    connectedServices.forEach((s) {
      serviceStrings.add(s.name);
    });

    prefs.setStringList('serviceList', serviceStrings);
  }

  Future<void> loadServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> serviceStrings = prefs.getStringList('serviceList') ?? null;

    if (serviceStrings != null && serviceStrings.isNotEmpty) {
      for (String s in serviceStrings) {
        Service service = Service.fromString(s);
        connectedServices.add(service);
      }
    }
    notifyListeners();
    // return (connectedServices.length > 0)
    //     ? connectedServices.toList()[0]
    //     : null;
  }

  bool canCreateRoom() {
    return connectedServices.isNotEmpty ? true : false;
  }

  Service fromString(String s) {
    Service service;

    switch (s) {
      case SPOTIFY:
        service = Spotify();
        break;
      case SOUNDCLOUD:
        service = SoundCloud();
        break;
      case APPLE:
        break;
    }

    return service;
  }
}

import 'package:flutter/material.dart';

class ServiceConfig {
  final String serviceName;
  final bool premiumRequired;

  ServiceConfig(this.serviceName, this.premiumRequired);
}

List<ServiceConfig> listServiceConfigs() {
  List<ServiceConfig> _serviceConfigs;
  _serviceConfigs.add(ServiceConfig(
    "Spotify",
    true,
  ));
  _serviceConfigs.add(ServiceConfig(
    "Apple Music",
    true,
  ));
  return _serviceConfigs;
}

Image displayServiceImage(String _service) {
  Image _icon;
  switch (_service) {
    case 'Spotify':
      _icon =
          Image(image: AssetImage('assets\images\Spotify_Icon_RGB_Green.png'));
      break;
    case 'Apple Music':
      _icon = Image(image: AssetImage('assets\images\Apple_Music_Icon.psd'));
      break;
    default:
  }
  return _icon;
}

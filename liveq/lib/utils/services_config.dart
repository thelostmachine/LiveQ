import 'package:flutter/material.dart';

class ServiceConfig {
  final String serviceName;
  final bool premiumRequired;
  // final bool accountRequired;
  final Image serviceIcon;

  ServiceConfig(this.serviceName, this.premiumRequired, this.serviceIcon);
}

List<ServiceConfig> listServiceConfigs() {
  List<ServiceConfig> _serviceConfigs;
  _serviceConfigs.add(ServiceConfig("Spotify", true,
      Image(image: AssetImage('assets\images\Spotify_Icon_RGB_Green.png'))));
  _serviceConfigs.add(ServiceConfig("Apple Music", true,
      Image(image: AssetImage('assets\images\Apple_Music_Icon.psd'))));
  return _serviceConfigs;
}

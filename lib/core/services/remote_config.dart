import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  bool get connectDB => _remoteConfig.getBool('connectDB');
}

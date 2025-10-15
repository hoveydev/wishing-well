import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

bool get isIOS {
  return defaultTargetPlatform == TargetPlatform.iOS;
}

bool get isAndroid {
  return defaultTargetPlatform == TargetPlatform.android;
}

bool get isMobile {
  return defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
}
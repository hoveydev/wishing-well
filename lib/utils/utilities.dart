import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

bool get isMobile =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;

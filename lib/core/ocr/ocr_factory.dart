// Safe runtime routing imports
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:spending_docs/core/ocr/ocr_engine_interface.dart';

import 'mobile_ocr_engine.dart'
    if (dart.library.js_interop) 'desktop_ocr_engine.dart'
    as mobile;
import 'desktop_ocr_engine.dart' as desktop;

class OcrEngineFactory {
  static OcrEngineInterface create() {
    if (kIsWeb) {
      return desktop.OcrEngineImpl();
    } else if (Platform.isAndroid || Platform.isIOS) {
      return mobile.OcrEngineImpl();
    } else {
      return desktop.OcrEngineImpl();
    }
  }
}

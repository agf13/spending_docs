import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:spending_docs/core/ocr/ocr_engine_interface.dart';

class OcrEngineImpl implements OcrEngineInterface {
  // 1. Keep this lazy and nullable. Do NOT initialize it here.
  // Initializing it at the class level will instantly crash on Linux.
  TextRecognizer? _textRecognizer;

  @override
  Future<String?> extractTextFromPath(String path) async {
    // 2. Handle Linux using system Tesseract
    if (Platform.isLinux) {
      try {
        final result = await Process.run('tesseract', [
          path,
          'stdout',
          '-l',
          'eng+ron',
        ]);

        if (result.exitCode == 0) {
          return result.stdout.toString().trim();
        } else {
          return "Linux OCR Error: ${result.stderr}";
        }
      } catch (e) {
        return "Linux OCR Failed. Did you run 'sudo apt install tesseract-ocr-ron'?\nError: $e";
      }
    }

    // 3. Handle Mobile using Google ML Kit
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        // Initialize the heavy mobile plugin ONLY when safely on a mobile platform
        _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.latin);

        final inputImage = InputImage.fromFilePath(path);
        final RecognizedText recognizedText = await _textRecognizer!
            .processImage(inputImage);
        return recognizedText.text;
      } catch (e) {
        return "Mobile OCR Error: $e";
      }
    }

    return "Unsupported platform";
  }

  @override
  Future<void> dispose() async {
    // 4. Safe dispose that only fires if the mobile engine was actually spun up
    await _textRecognizer?.close();
    _textRecognizer = null;
  }
}

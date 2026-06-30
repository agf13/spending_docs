import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:spending_docs/core/ocr/ocr_engine_interface.dart';

class OcrEngineImpl implements OcrEngineInterface {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Future<String?> extractTextFromPath(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  @override
  Future<void> dispose() async {
    await _textRecognizer.close();
  }
}

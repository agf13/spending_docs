abstract class OcrEngineInterface {
  Future<String?> extractTextFromPath(String filePath);
  Future<void> dispose();
}

import 'dart:convert' show json;
import 'dart:typed_data' show Uint8List;

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:spending_docs/core/utils/environment.dart';

class ReceiptAnalysizService {
  late final GenerativeModel _model;

  ReceiptAnalysizService() {
    const apiKey = Environment.geminiFreeApiKey;

    if (apiKey.isEmpty) {
      throw StateError(
        'Missing api key. It needs to be defined in config.json and the app run with --dart-define-from-file=config.json?',
      );
    }

    final schemaObject = receiptSchema();
    final instructions = getInstructions();

    initializeModel(apiKey, schemaObject, instructions);
  }

  Schema receiptSchema() {
    return Schema.object(
      properties: {
        'isCashPayment': Schema.boolean(
          description: 'True if paid with cash, false in any other case',
        ),
        'cardLast4Digits': Schema.string(
          description:
              'The last 4 digits of the card used. Null if paid with cash or the card digits cannot be determined',
          nullable: true,
        ),
        'total': Schema.number(description: 'The total cost of the receipt'),
        'items': Schema.array(
          description: 'The list of individual items purchased',
          items: Schema.object(
            properties: {
              'name': Schema.string(
                description: 'The name or description of the item',
              ),
              'price': Schema.number(
                description: 'The price of the specific item',
              ),
            },
            requiredProperties: ['name', 'price'],
          ),
        ),
      },
      requiredProperties: ['isCashPayment', 'total', 'items'],
    );
  }

  String getInstructions() {
    return '''You are an expert OCR receipt parsing assistant. Analyze the provided image and extract data matching the requested JSON schema exactly. Do not invent items. If the payment type cannot be determined, default isCashPayment to true.''';
  }

  void initializeModel(
    String apiKey,
    Schema schemaObject,
    String instructions,
  ) {
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schemaObject,
      ),
      systemInstruction: Content.system(instructions),
    );
  }

  TextPart getPrompt() {
    return TextPart(
      'Extract the receipt details exactly as specified in the schema',
    );
  }

  Future<Map<String, dynamic>> analyzeReceiptImage(
    Uint8List imageBytes,
    String mimeType,
  ) async {
    try {
      final imagePart = DataPart(mimeType, imageBytes);
      final prompt = getPrompt();

      final response = await _model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      final jsonText = response.text;
      if (jsonText == null || jsonText.isEmpty) {
        throw Exception('Gemini returned an empty response');
      }

      final Map<String, dynamic> parsedJson = json.decode(jsonText);
      return parsedJson;
    } catch (e) {
      print('Error during receipt analysis: ${e.toString()}');
      rethrow;
    }
  }
}

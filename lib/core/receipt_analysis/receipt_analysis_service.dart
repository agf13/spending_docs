import 'dart:convert' show json;
import 'dart:typed_data' show Uint8List;

import 'package:drift/drift.dart' show Value;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:spending_docs/core/utils/environment.dart';
import 'package:spending_docs/database/app_database.dart';

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
        'store': Schema.string(
          description: 'The name of the store',
          nullable: true,
        ),
        'cardLast4Digits': Schema.string(
          description:
              'The last 4 digits of the card used. Null if paid with cash or the card digits cannot be determined',
          nullable: true,
        ),
        'total': Schema.number(description: 'The total cost of the receipt'),
        'date': Schema.string(
          description:
              'The date of the receipt in the following ISO 8601 format: YYYY-MM-DDTHH:mm:ssZ (e.g., 2026-07-26T14:30:00Z)',
          nullable: false,
        ),
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
      requiredProperties: ['isCashPayment', 'total', 'items', 'date'],
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

  static ReceiptsCompanion? extractReceipt(Map<String, dynamic> jsonReceipt) {
    try {
      final total = jsonReceipt['total'];
      final card = jsonReceipt['cardLast4Digits'];
      final store = jsonReceipt['store'];
      final date = DateTime.parse(jsonReceipt['date']);

      return ReceiptsCompanion(
        amount: Value(total),
        storeName: Value(store),
        date: Value(date),
        card: Value(card),
      );
    } catch (e) {
      print('Error when parsing the receipt from the json: ${e.toString()}');
    }

    return null;
  }

  static List<ReceiptItemsCompanion> extractReceiptItems(
    Map<String, dynamic> jsonReceipt,
    int receiptId,
  ) {
    List<ReceiptItemsCompanion> result = [];

    try {
      final itemList = jsonReceipt['items'];
      for (var index = 0; index < itemList.length; index++) {
        final price = jsonReceipt['items'][index]['price'];
        final name = jsonReceipt['items'][index]['name'];

        final item = ReceiptItemsCompanion(
          receiptId: Value(receiptId),
          price: Value(price),
          itemName: Value(name),
        );

        result.add(item);
      }
    } catch (e) {
      print('Error when parsing the list of items on receipt: ${e.toString()}');
    }

    return result;
  }
}

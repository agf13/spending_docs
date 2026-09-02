import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:spending_docs/features/scan/data/datasources/receipt_scan_remote_data_source.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';

class GeminiReceiptScanRemoteDataSourceImpl
    implements ReceiptScanRemoteDataSource {
  final String apiKey;
  const GeminiReceiptScanRemoteDataSourceImpl({required this.apiKey});

  @override
  Future<ScannedReceiptDto> analyzeReceiptImage(Uint8List imageBytes) async {
    final model = _getModel();
    final prompt = _getTextPrompt();
    final imagePart = DataPart('image/jpeg', imageBytes);

    Map<String, dynamic> jsonResponse = await _getResponse(
      model,
      prompt,
      imagePart,
    );

    return ScannedReceiptDto.fromJson(jsonResponse);
  }

  GenerativeModel _getModel() {
    return GenerativeModel(
      apiKey: apiKey,
      model: 'gemini-3.6-flash',
      generationConfig: _getGenerationConfig(),
    );
  }

  GenerationConfig _getGenerationConfig() {
    return GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: Schema.object(
        properties: {
          'amount': _getAmountSchema(),
          'storeName': _getStoreNameSchema(),
          'date': _getDateSchema(),
          'card': _getCardSchema(),
          'items': _getItemsSchema(),
        },
        requiredProperties: ['amount', 'storeName', 'date', 'card', 'items'],
      ),
    );
  }

  Schema _getAmountSchema() {
    return Schema.number(
      description:
          'The total paid amount as a number. If you cannot find it, use 0.',
    );
  }

  Schema _getStoreNameSchema() {
    return Schema.string(
      description:
          'The name of the store. If you cannot find it return an empty string.',
    );
  }

  Schema _getDateSchema() {
    return Schema.string(
      description:
          'The date of the payment in the format dd-mm-yyyy hh:mm:ss. If you cannot find it return an empty string.',
    );
  }

  Schema _getCardSchema() {
    return Schema.string(
      description:
          'The last 4 digits of the card used for the payment. If you cannot find the card them judge if the '
          'payment was done cash and return the word "cash". If you cannot judge at all, return empty string.',
    );
  }

  Schema _getItemsSchema() {
    return Schema.array(
      description: '',
      items: Schema.object(
        properties: {
          'price': _getPriceSchema(),
          'itemName': _getItemNameSchema(),
        },
        requiredProperties: ['price', 'itemName'],
      ),
    );
  }

  Schema _getPriceSchema() {
    return Schema.number(
      description:
          'The price of the item. If the item is a discount of any type return it as a negative number.'
          'If you cannot find a price return 0',
    );
  }

  Schema _getItemNameSchema() {
    return Schema.string(
      description:
          'The name of the item. If you cannot find it return an empty string',
    );
  }

  TextPart _getTextPrompt() {
    final prompt = TextPart(
      'Extract the data from this receipt. If you cannot find the specified data use the default '
      'values provided in the schema',
    );

    return prompt;
  }

  Future<Map<String, dynamic>> _getResponse(
    GenerativeModel model,
    TextPart prompt,
    DataPart imagePart,
  ) async {
    final response = await model.generateContent([
      Content.multi([prompt, imagePart]),
    ]);

    final rawText = response.text;

    if (rawText == null || rawText.isEmpty) {
      throw Exception('Empty response from Gemini AI');
    }

    try {
      final Map<String, dynamic> jsonData = json.decode(rawText);
      return jsonData;
    } catch (e) {
      throw Exception('Error in the json received from Gemini AI');
    }
  }
}

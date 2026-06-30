import 'dart:convert';
import 'package:llamadart/llamadart.dart';

class LocalLlmProcessor {
  LlamaEngine? _engine;

  Future<void> initEngine(String modelPath) async {
    _engine = LlamaEngine(LlamaBackend());
    await _engine!.loadModel(
      modelPath,
      modelParams: ModelParams(gpuLayers: 99),
    );
  }

  /// Strips out markdown code fences if the model falls back to text blocks
  String _sanitizeJson(String input) {
    String clean = input.trim();
    if (clean.startsWith('```')) {
      clean = clean.replaceAll(RegExp(r'^```(?:json)?\s*\n|```$'), '').trim();
    }
    return clean;
  }

  /// Fallback regex scanner to salvage item triplets if JSON parsing breaks
  List<Map<String, dynamic>> _recoverItemsViaRegex(String input) {
    final List<Map<String, dynamic>> recovered = [];
    final RegExp objectBlockRegex = RegExp(r'\{([^}]+)\}');
    final blockMatches = objectBlockRegex.allMatches(input);

    final RegExp nameRegex = RegExp(
      r'''["']?itemName["']?\s*:\s*["']([^"']+)["']''',
      caseSensitive: false,
    );
    final RegExp priceRegex = RegExp(
      r'''["']?price["']?\s*:\s*([0-9.]+)''',
      caseSensitive: false,
    );
    final RegExp qtyRegex = RegExp(
      r'''["']?quantity["']?\s*:\s*([0-9]+)''',
      caseSensitive: false,
    );

    for (final blockMatch in blockMatches) {
      final blockText = blockMatch.group(1) ?? '';
      final nameMatch = nameRegex.firstMatch(blockText);
      final priceMatch = priceRegex.firstMatch(blockText);
      final qtyMatch = qtyRegex.firstMatch(blockText);

      if (nameMatch != null && priceMatch != null) {
        recovered.add({
          "itemName": nameMatch.group(1)?.trim() ?? 'Unknown Item',
          "quantity": qtyMatch != null
              ? int.tryParse(qtyMatch.group(1) ?? '1') ?? 1
              : 1,
          "price": double.tryParse(priceMatch.group(1) ?? '0.00') ?? 0.00,
        });
      }
    }
    return recovered;
  }

  /// Fallback regex scanner to salvage payment metadata if JSON parsing breaks
  Map<String, dynamic> _recoverPaymentViaRegex(String input) {
    final RegExp methodRegex = RegExp(
      r'''["']?paymentMethod["']?\s*:\s*["'](card|cash)["']''',
      caseSensitive: false,
    );
    final RegExp cardRegex = RegExp(
      r'''["']?cardLast4["']?\s*:\s*["']?([0-9]{4})["']?''',
      caseSensitive: false,
    );

    final methodMatch = methodRegex.firstMatch(input);
    final cardMatch = cardRegex.firstMatch(input);

    return {
      "paymentMethod": methodMatch?.group(1)?.toLowerCase() ?? "unknown",
      "cardLast4": cardMatch?.group(1),
    };
  }

  /// Parses receipt OCR text and returns a Map containing structured item data and payment details.
  Future<Map<String, dynamic>> parseOcrToReceiptJson(String ocrText) async {
    if (_engine == null) throw Exception("LLM Engine not initialized");

    // FIXED PROMPT: Uses generic type schemas to keep the array-loop rule intact
    // while preventing negative anchor validation problems.
    const systemPrompt = """
You are a strict data extraction engine. Analyze the OCR text of a receipt and extract ALL line items and payment details into a single JSON object.

Expected JSON Structure:
{
  "items": [
    {"itemName": "TEXT_A", "quantity": 0, "price": 0.00},
    {"itemName": "TEXT_B", "quantity": 0, "price": 0.00}
  ],
  "paymentMethod": "card",
  "cardLast4": "0000"
}

Rules:
1. The values in the example above ("TEXT_A", 0, 0.00, "0000") are purely format placeholders showing the JSON layout keys. Do not repeat these exact placeholder strings or numbers unless they literally appear in the user's receipt text.
2. Extract EVERY SINGLE line item listed on the receipt text. Do not stop after extracting just one item. Iterate through the entire document from top to bottom.
3. "paymentMethod" must be "card" or "cash". If not explicitly clear, use "unknown".
4. "cardLast4" must be a string of the last 4 digits of the card if paid by card, or null if paid by cash or not found.
5. Quantities must be integers. Prices must be numbers.
6. Do not include markdown wraps or dialogue commentary.
""";

    final session = ChatSession(_engine!, systemPrompt: systemPrompt);
    final jsonBuffer = StringBuffer();

    final Map<String, dynamic> fallbackResult = {
      "items": <Map<String, dynamic>>[],
      "paymentMethod": "unknown",
      "cardLast4": null,
    };

    try {
      final stream = session.create([
        LlamaTextContent("Analyze this OCR text:\n\n$ocrText"),
      ]);

      await for (final chunk in stream) {
        final content = chunk.choices.first.delta.content ?? '';
        jsonBuffer.write(content);
      }

      final rawSlmResult = jsonBuffer.toString();

      print("=================== SLM DEBUG WINDOW ===================");
      print("Raw payload received from local model:\n$rawSlmResult");
      print("========================================================");

      final cleanedOutput = _sanitizeJson(rawSlmResult);
      if (cleanedOutput.isEmpty) return fallbackResult;

      try {
        final decoded = json.decode(cleanedOutput);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (jsonError) {
        print(
          "Strict JSON decoding failed. Triggering recovery regex scrapers: $jsonError",
        );

        final recoveredItems = _recoverItemsViaRegex(cleanedOutput);
        final recoveredPayment = _recoverPaymentViaRegex(cleanedOutput);

        if (recoveredItems.isNotEmpty ||
            recoveredPayment["paymentMethod"] != "unknown") {
          return {
            "items": recoveredItems,
            "paymentMethod": recoveredPayment["paymentMethod"],
            "cardLast4": recoveredPayment["cardLast4"],
          };
        }
      }

      return fallbackResult;
    } catch (e) {
      print("Failed processing local LLM stream output: $e");
      return fallbackResult;
    }
  }

  Future<void> dispose() async {
    if (_engine != null) {
      await _engine!.dispose();
      _engine = null;
    }
  }
}

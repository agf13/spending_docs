import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:spending_docs/core/ai/local_llm_processor.dart';

enum AiState { uninitialized, downloading, loadingEngine, ready, error }

class ReceiptAiController extends ChangeNotifier {
  final _processor = LocalLlmProcessor();

  AiState state = AiState.uninitialized;
  double downloadProgress = 0.0;
  String errorMessage = '';

  // Data State Elements
  List<Map<String, dynamic>> parsedItems = [];
  String paymentMethod = 'unknown';
  String? cardLast4;

  // A direct mirror link to the Qwen 1.5B Q4 model on Hugging Face
  final String _modelUrl =
      "https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf";
  final String _fileName = "qwen2.5-1.5b-instruct-q4_k_m.gguf";

  /// Boots up the local AI system. Call this during app loading or when navigating to the scanning view.
  Future<void> initialize() async {
    if (state == AiState.ready) return;

    try {
      final directory = await getApplicationSupportDirectory();
      final modelPath = "${directory.path}/$_fileName";
      final modelFile = File(modelPath);

      if (!await modelFile.exists()) {
        state = AiState.downloading;
        notifyListeners();

        await _downloadModel(modelPath);
      }

      state = AiState.loadingEngine;
      notifyListeners();

      await _processor.initEngine(modelPath);

      state = AiState.ready;
      notifyListeners();
    } catch (e) {
      state = AiState.error;
      errorMessage = "AI Boot Failure: $e";
      notifyListeners();
    }
  }

  Future<void> _downloadModel(String savePath) async {
    final dio = Dio();
    await dio.download(
      _modelUrl,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          downloadProgress = received / total;
          notifyListeners();
        }
      },
    );
  }

  /// Sends the processed text to the local LLM and returns the structured results
  Future<void> processReceiptText(String ocrText) async {
    if (state != AiState.ready) return;

    state = AiState
        .loadingEngine; // Re-use loading state as a 'processing' indicator
    notifyListeners();

    try {
      final data = await _processor.parseOcrToReceiptJson(ocrText);

      // Safely transform internal types to ensure casting errors don't crash runtime UI maps
      if (data['items'] is List) {
        parsedItems = (data['items'] as List)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      } else {
        parsedItems = [];
      }

      paymentMethod = data['paymentMethod']?.toString() ?? 'unknown';
      cardLast4 = data['cardLast4']?.toString();
    } catch (e) {
      print("Error extracting receipt payload states: $e");
      parsedItems = [];
      paymentMethod = 'unknown';
      cardLast4 = null;
    }

    state = AiState.ready;
    notifyListeners();
  }

  @override
  void dispose() {
    _processor.dispose();
    super.dispose();
  }
}

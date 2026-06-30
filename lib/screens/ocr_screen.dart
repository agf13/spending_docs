import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spending_docs/core/ai/receipt_ai_controller.dart';
import 'package:spending_docs/core/ocr/ocr_engine_interface.dart';
import 'package:spending_docs/core/ocr/ocr_factory.dart';
import 'package:spending_docs/core/ocr/text_normalizer.dart';

class OcrScannerView extends StatefulWidget {
  const OcrScannerView({super.key});

  @override
  State<OcrScannerView> createState() => _OcrScannerViewState();
}

class _OcrScannerViewState extends State<OcrScannerView> {
  final OcrEngineInterface _ocrEngine = OcrEngineFactory.create();
  final ImagePicker _imagePicker = ImagePicker();
  final _aiController = ReceiptAiController();

  String _processedText = "Select an option above to import a receipt.";
  bool _isOcrLoading = false;

  @override
  void initState() {
    super.initState();
    _aiController.initialize();
    _aiController.addListener(_onAiStateChanged);
  }

  void _onAiStateChanged() {
    if (mounted) setState(() {});
  }

  /// Handles picking, text extraction, and automatic local AI parsing
  Future<void> _processReceipt(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (image == null) return;

      setState(() {
        _isOcrLoading = true;
        _processedText = "Extracting text from image...";
      });

      // Step 1: Run the OCR Engine
      final String? rawText = await _ocrEngine.extractTextFromPath(image.path);

      if (rawText != null && rawText.trim().isNotEmpty) {
        _processedText = TextNormalizer.removeRomanianDiacritics(rawText);
        setState(() => _isOcrLoading = false);

        // Step 2: Auto-trigger AI if the local model engine is initialized and ready
        if (_aiController.state == AiState.ready) {
          await _aiController.processReceiptText(_processedText);
        }
      } else {
        setState(() {
          _processedText = "No readable text found inside the selected photo.";
          _isOcrLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _processedText = "Processing Error: $e";
        _isOcrLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _ocrEngine.dispose();
    _aiController.removeListener(_onAiStateChanged);
    _aiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Local OCR & AI Parser")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row providing dual choices for image input source
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isOcrLoading
                        ? null
                        : () => _processReceipt(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isOcrLoading
                        ? null
                        : () => _processReceipt(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Raw OCR Output collapse card to save vertical layout space
            Card(
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Raw OCR Output:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Text(
                          _processedText,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Unified AI and Results presentation block
            Expanded(
              child: _isOcrLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildAiAndResultsEngine(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiAndResultsEngine(BuildContext context) {
    return switch (_aiController.state) {
      AiState.uninitialized => const Center(
        child: Text("Preparing background tasks..."),
      ),

      AiState.downloading => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Downloading 1.1GB Local AI Model on first setup...",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: _aiController.downloadProgress),
          const SizedBox(height: 8),
          Text(
            "${(_aiController.downloadProgress * 100).toStringAsFixed(1)}% Completed",
          ),
        ],
      ),

      AiState.loadingEngine => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            "Thinking... Local SLM parsing items and prices.",
            textAlign: TextAlign.center,
          ),
        ],
      ),

      AiState.error => Center(
        child: Text(
          _aiController.errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      ),

      AiState.ready => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Extracted Items:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "${_aiController.parsedItems.length} items found",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: _aiController.parsedItems.isEmpty
                ? const Center(
                    child: Text(
                      "No structured items parsed yet.\nScan a receipt to auto-analyze.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _aiController.parsedItems.length,
                    itemBuilder: (context, index) {
                      final item = _aiController.parsedItems[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: Text(
                          item['itemName']?.toString() ?? 'Unknown Item',
                        ),
                        trailing: Text(
                          "${item['price']?.toString() ?? '0.00'} RON",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    };
  }
}

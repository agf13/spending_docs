import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ScanCameraScreen({super.key, required this.cameras});

  @override
  State<ScanCameraScreen> createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final backCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => widget.cameras.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: cameraScreenBody(),
    );
  }

  Widget cameraScreenBody() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: futureBuilder,
    );
  }

  Widget futureBuilder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Center(child: CircularProgressIndicator());
    }

    return futureBuilderStack();
  }

  Widget futureBuilderStack() {
    return Stack(
      children: [
        // Camera main body
        cameraMainBody(),
        // Close button
        closeButton(),
        // Controls
        controlButtons(),
      ],
    );
  }

  Widget cameraMainBody() {
    return Positioned.fill(child: CameraPreview(_controller));
  }

  Widget closeButton() {
    return Positioned(
      top: 40,
      left: 16,
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 28),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget controlButtons() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Spacer
          SizedBox(width: 10),
          // Open galery button
          galeryButton(),
          // Take photo button
          takePhotoButton(),
          // Spacer
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget galeryButton() {
    return IconButton(
      icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
      onPressed: _pickFromGallery,
      tooltip: 'Galery',
    );
  }

  Widget takePhotoButton() {
    return GestureDetector(
      onTap: _takePicture,
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondaryContainer,
            width: 4,
          ),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      // Some initialization of the chosen camera
      await _initializeControllerFuture;

      // Trigger image capture
      final XFile image = await _controller.takePicture();

      // If the widget is no longer mounted, return
      if (!mounted) return;

      // Return the image path
      Navigator.pop(context, image.path);
    } catch (e) {
      print('Error when taking picture');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null && mounted) {
        Navigator.pop(context, image.path);
      }
    } catch (e) {
      print('Error when picking image: $e');
    }
  }
}

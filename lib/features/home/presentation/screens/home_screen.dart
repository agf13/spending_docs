import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:spending_docs/features/filter/presentation/widgets/filter.dart';
import 'package:spending_docs/features/home/presentation/widgets/receipt_list_view.dart';
import 'package:spending_docs/features/receipts/presentation/widgets/receipt_form.dart';
import 'package:spending_docs/features/scan/cubits/receipt_scan_image_cubit.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';
import 'package:spending_docs/features/scan/presentation/utils/image_picker_util.dart';
import 'package:spending_docs/features/scan/presentation/widgets/scan_form.dart';
import 'package:spending_docs/l10n/app_localizations.dart'
    show AppLocalizations;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex =
      0; // For the NagivationBar to handle selected button style
  int _currentPage = 0; // To handle the correct widget to show
  List<Widget> widgetList = [
    ReceiptListView(),
    FilterWidget(),
  ]; // A list of widgets to show using _currentPage as index

  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
      bottomNavigationBar: navigationBar(),
      floatingActionButton: floatingActionButton(),
    );
  }

  AppBar appBar() {
    return AppBar(title: Text(AppLocalizations.of(context)!.homeTitle));
  }

  Widget body() {
    return IndexedStack(index: _currentPage, children: widgetList);
  }

  NavigationBar navigationBar() {
    return NavigationBar(
      onDestinationSelected: _handleDestionationChanged,
      selectedIndex: _selectedIndex,
      destinations: [homeScreenButton(), scanButton(), searchScreenButton()],
      labelTextStyle: _getNagivationLabelStyle(),
    );
  }

  WidgetStateProperty<TextStyle> _getNagivationLabelStyle() {
    return WidgetStateProperty.resolveWith<TextStyle>((states) {
      final isSelected = states.contains(WidgetState.selected);
      final textBodyLarge = Theme.of(context).textTheme.bodyLarge?.fontSize;
      final textBodyMedium = Theme.of(context).textTheme.bodyMedium?.fontSize;

      return TextStyle(
        fontSize: isSelected ? textBodyLarge : textBodyMedium,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      );
    });
  }

  // Custom mapping of navigation bar itens to screens
  void _handleDestionationChanged(int index) async {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
        _currentPage = 0;
      });
    } else if (index == 1) {
      setState(() {
        _selectedIndex = index;
      });

      // Scan and extract
      final String? imagePath = await _imagePickerUtil.startScanProcess(
        context,
      );
      if (imagePath != null && imagePath.isNotEmpty) {
        Uint8List imageBytes = await _getImageBytesFromPath(imagePath);
        context.read<ReceiptScanImageCubit>().processImage(imageBytes);
        ScanForm.showScanResultPopup(context: context);
      }

      if (imagePath != null) {
        print('we can process the image: $imagePath');
      }

      setState(() {
        _selectedIndex = 0;
        _currentPage = 0;
      });
    } else if (index == 2) {
      // The third button maps to the second screen
      setState(() {
        _selectedIndex = index;
        _currentPage = 1;
      });
    }
  }

  NavigationDestination homeScreenButton() {
    return NavigationDestination(
      icon: Icon(Icons.home),
      label: AppLocalizations.of(context)!.appBarNavigationHome,
    );
  }

  NavigationDestination scanButton() {
    return NavigationDestination(
      icon: Icon(Icons.camera_sharp),
      label: AppLocalizations.of(context)!.appBarNavigationScan,
    );
  }

  NavigationDestination searchScreenButton() {
    return NavigationDestination(
      icon: Icon(Icons.search),
      label: AppLocalizations.of(context)!.appBarNavigationSearch,
    );
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(onPressed: handleAdd, child: Icon(Icons.add));
  }

  void handleAdd() {
    ReceiptForm.showFormPopup(context: context);
  }

  Future<Uint8List> _getImageBytesFromPath(String imagePath) async {
    final File imageFile = File(imagePath);
    final Uint8List bytes = await imageFile.readAsBytes();
    return bytes;
  }
}

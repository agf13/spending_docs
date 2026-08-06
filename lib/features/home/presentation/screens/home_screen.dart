import 'package:flutter/material.dart';
import 'package:spending_docs/features/home/presentation/widgets/receipt_list_view.dart';
import 'package:spending_docs/features/receipts/presentation/widgets/new_receipt_form.dart';
import 'package:spending_docs/l10n/app_localizations.dart'
    show AppLocalizations;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
      bottomNavigationBar: bottomNavigationBar(),
      floatingActionButton: floatingActionButton(),
    );
  }

  AppBar appBar() {
    return AppBar(title: Text(AppLocalizations.of(context)!.homeTitle));
  }

  Widget body() {
    return ReceiptListView();
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      onTap: handleNavigationButton,
      items: [homeScreenButton(), scanButton(), searchScreenButton()],
    );
  }

  void handleNavigationButton(int index) {
    print('button $index clicked');
  }

  BottomNavigationBarItem homeScreenButton() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: AppLocalizations.of(context)!.appBarNavigationHome,
    );
  }

  BottomNavigationBarItem scanButton() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.camera_sharp),
      label: AppLocalizations.of(context)!.appBarNavigationScan,
    );
  }

  BottomNavigationBarItem searchScreenButton() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: AppLocalizations.of(context)!.appBarNavigationSearch,
    );
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(onPressed: handleAdd, child: Icon(Icons.add));
  }

  void handleAdd() {
    NewReceiptForm.showFormPopup(context);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/receipt_list_cubit.dart';
import 'package:spending_docs/blocs/side_menu_cubit.dart';
import 'package:spending_docs/screens/homepage.dart';
import 'package:spending_docs/storage/receipt_storage_support_directory.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ReceiptStorageSupportDirectory receiptStorage =
      ReceiptStorageSupportDirectory();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ReceiptListCubit injection in context
        BlocProvider<ReceiptListCubit>(
          create: (context) =>
              ReceiptListCubit(receiptStorage: receiptStorage)..loadItems(),
        ),
        // SideMenuCubit injection in context
        BlocProvider<SideMenuCubit>(create: (context) => SideMenuCubit()),
      ],
      child: MaterialApp(home: HomePage()),
    );
  }
}

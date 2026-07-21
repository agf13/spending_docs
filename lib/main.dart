import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/popup_widget_cubit.dart';
import 'package:spending_docs/blocs/receipt_items_list_cubit.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/database/app_database.dart';
import 'package:spending_docs/repositories/receipt_items_repository.dart';
import 'package:spending_docs/repositories/receipts_repository.dart';
import 'package:spending_docs/screens/homepage_screen.dart';

void main() {
  final database = AppDatabase();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase _database;
  const MyApp({super.key, required this._database});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // ReceiptsRepository
        RepositoryProvider<ReceiptsRepository>(
          create: (_) => ReceiptsRepository(_database),
        ),

        //ReceiptItemsRepository
        RepositoryProvider<ReceiptItemsRepository>(
          create: (_) => ReceiptItemsRepository(_database),
        ),
      ],

      child: MultiBlocProvider(
        providers: [
          // PopupWidgetCubit injection in context
          BlocProvider<PopupWidgetCubit>(
            create: (context) => PopupWidgetCubit(),
          ),

          // ReceiptsListCubit (to handle the list of receipts)
          BlocProvider<ReceiptsListCubit>(
            create: (context) {
              final repository = context.read<ReceiptsRepository>();
              return ReceiptsListCubit(repository)..getItems();
            },
          ),

          // ReceiptItemsListCubit (to handle the list of items from a receipt)
          BlocProvider<ReceiptItemsListCubit>(
            create: (context) {
              final repository = context.read<ReceiptItemsRepository>();
              return ReceiptItemsListCubit(repository)..getItems();
            },
          ),
        ],
        child: MaterialApp(home: HomepageScreen()),
      ),
    );
  }
}

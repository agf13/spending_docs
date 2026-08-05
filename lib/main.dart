import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spending_docs/blocs/popup_widget_cubit.dart';
import 'package:spending_docs/core/database/app_database.dart';
import 'package:spending_docs/features/home/presentation/screens/home_screen.dart';
import 'package:spending_docs/features/receipt_items/blocs/receipt_items_list_cubit.dart';
import 'package:spending_docs/features/receipt_items/data/repositories/receipt_items_repository.dart';
import 'package:spending_docs/features/receipts/blocs/receipt_list_bloc.dart';
import 'package:spending_docs/features/receipts/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';
import 'package:spending_docs/l10n/app_localizations.dart';
import 'package:spending_docs/themes/app_theme.dart';

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
          BlocProvider<ReceiptListBloc>(
            create: (context) {
              final repository = context.read<ReceiptsRepository>();
              return ReceiptListBloc(repository: repository)
                ..add(ReceiptFetched());
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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: const Locale('en'),
          //home: HomepageScreen(),
          home: HomeScreen(),
          theme: AppTheme.emeraldTheme,
        ),
      ),
    );
  }
}

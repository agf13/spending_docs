import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/blocs/side_menu_cubit.dart';
import 'package:spending_docs/database/app_database.dart';
import 'package:spending_docs/repositories/receipts_repository.dart';
import 'package:spending_docs/screens/homepage.dart';

void main() {
  final database = AppDatabase();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase _database;
  MyApp({super.key, required this._database});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // ReceiptsRepository
        RepositoryProvider<ReceiptsRepository>(
          create: (_) => ReceiptsRepository(_database),
        ),
      ],

      child: MultiBlocProvider(
        providers: [
          // SideMenuCubit injection in context
          BlocProvider<SideMenuCubit>(create: (context) => SideMenuCubit()),

          // ReceiptsListCubit (to handle the list of receipts)
          BlocProvider<ReceiptsListCubit>(
            create: (context) {
              final repository = context.read<ReceiptsRepository>();
              return ReceiptsListCubit(repository)..getItems();
            },
          ),
        ],
        child: MaterialApp(home: HomePage()),
      ),
    );
  }
}

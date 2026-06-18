import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/side_menu_cubit.dart';

class SideMenu extends StatefulWidget {
  SideMenu({super.key});

  State<SideMenu> createState() {
    return _SideMenuState();
  }
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          // Add receipt button
          _menuButton(
            onPressed: () {
              onAddPressed(context);
            },
            icon: Icon(Icons.add),
          ),

          // Filter button
          _menuButton(
            onPressed: () {
              onFilterPressed(context);
            },
            icon: Icon(Icons.filter_alt),
          ),
        ],
      ),
    );
  }

  Widget _menuButton({required void Function() onPressed, required Icon icon}) {
    // Add button
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
        child: icon,
      ),
    );
  }

  void onAddPressed(BuildContext context) {
    context.read<SideMenuCubit>().setSubMenuIndex(1);
  }

  void onFilterPressed(BuildContext context) {
    context.read<SideMenuCubit>().setSubMenuIndex(2);
  }
}

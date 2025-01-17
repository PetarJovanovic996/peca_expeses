import 'package:flutter/material.dart';
import 'package:peca_expenses/main/routes.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(Routes.filter),
            icon: const Icon(
              Icons.filter_alt_sharp,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 120,
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(Routes.addNew),
            label: const Text(
              'Add new Expense',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

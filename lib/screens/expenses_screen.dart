import 'package:flutter/material.dart';
import 'package:peca_expenses/providers/add_expense_provider.dart';
import 'package:peca_expenses/providers/filters_provider.dart';
import 'package:provider/provider.dart';
import 'package:peca_expenses/models/date.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddExpenseProvider>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('Add Your Expanses'),
    );

    final allItems = context.watch<AddExpenseProvider>().expenseItems;

    if (context.read<AddExpenseProvider>().isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (allItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: allItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            context.read<AddExpenseProvider>().removeItem(allItems[index]);
          },
          key: ValueKey(allItems[index].name),
          child: ListTile(
            title: Text(allItems[index].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(allItems[index].description),
                Text(MyDateFormat().formatDate(allItems[index].date)),
              ],
            ),
            leading: Icon(allItems[index].category.icon.icon),
            trailing: Text('\$${allItems[index].amount}'),
          ),
        ),
      );
      // } else if (filteredItems.isNotEmpty) {
      //   content = ListView.builder(
      //     itemCount: filteredItems.length,
      //     itemBuilder: (ctx, index) => ListTile(
      //       title: Text(filteredItems[index].name),
      //       subtitle: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(filteredItems[index].description),
      //           Text(MyDateFormat().formatDate(filteredItems[index].date)),
      //         ],
      //       ),
      //       leading: Icon(filteredItems[index].category.icon.icon),
      //       trailing: Text('\$${filteredItems[index].amount}'),
      //     ),
      //   );
    }

    if (context.read<AddExpenseProvider>().error != null) {
      content = Center(
        child: Text(context.watch<AddExpenseProvider>().error!),
      );
    }

    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 46, 43, 43),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, 'filter');
                },
                icon: const Icon(
                  Icons.filter_alt_sharp,
                  size: 40,
                ),
              ),
              const SizedBox(
                width: 120,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, 'addnew');
                },
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
        ),
        appBar: AppBar(
          title: const Center(
            child: Text('My Expenses'),
          ),
          actions: [
            const SizedBox(
              width: 50,
            ),
            TextButton.icon(
              onPressed: () {
                context.read<FiltersProvider>().clearFilters();
              },
              label: const Text(
                'Clear all Filters',
                style: TextStyle(color: Colors.black),
              ),
              icon: const Icon(
                Icons.filter_alt_off_sharp,
                color: Colors.black,
              ),
            ),
          ],
        ),

        //
        //
        // OVDJE POCINJE LISTA

        body: content);
  }
}

//visual overvierw of the users expenses with filtering option
//implement pull to refresh logic for filtering / kada su prikazatni 
// da na dugme se automatski resetuje i lista i prikaze svi troskovi
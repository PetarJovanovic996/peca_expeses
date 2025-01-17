import 'package:flutter/material.dart';
import 'package:peca_expenses/models/expense_item.dart';
import 'package:peca_expenses/providers/expense_provider.dart';
import 'package:peca_expenses/providers/filters_provider.dart';
import 'package:peca_expenses/widgets/app_bars/expense_list_item.dart';
import 'package:provider/provider.dart';

class ExpenseScreenContent extends StatelessWidget {
  const ExpenseScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredItems = context.watch<FiltersProvider>().filteredExpenses;
    final allItems = context.watch<ExpenseProvider>().expenseItems;
    final isLoading = context.watch<ExpenseProvider>().isLoading;
    final hasError = context.watch<ExpenseProvider>().error != null;
    final isFilterActive = context.watch<FiltersProvider>().isFilterActive;

    final List<ExpenseItem> itemsToDisplay = isFilterActive
        ? (filteredItems.isEmpty ? [] : filteredItems)
        : allItems;

    final isEmpty = itemsToDisplay.isEmpty;

    if (isLoading) {
      // Just for cleaner code extract to custom widget, example given at the bottom of this file.

      return const _LoadingWidget();
    }

    if (isEmpty) {
      if (isFilterActive) {
        return const _FilterEmptyWidget(); // Nema stavki nakon filtriranja
      } else {
        return const _EmptyWidget(); // Nema stavki, ali filter nije aktivan
      }
    }

    if (hasError) {
      // Just for cleaner code extract to custom widget, example given at the bottom of this file.
      // Similarly as for _LoadingWidget
      return const _ErrorWidget();
    }

    // Example how we can achieve the same logic, and have it be more clear to someone who
    // looks at the code for the first time

    // final isLoading = context.watch<AddExpenseProvider>().isLoading;
    // final isEmpty = itemsToDisplay.isEmpty;
    // final hasError = context.watch<AddExpenseProvider>().error != null;
    //
    // if (isLoading) return const _LoadingWidget();
    // if (isEmpty) return const _EmptyWidget();
    // if (hasError) return const _ErrorWidget();

    return ListView.builder(
      itemCount: itemsToDisplay.length,
      itemBuilder: (ctx, index) => Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          context.read<ExpenseProvider>().removeItem(itemsToDisplay[index]);
        },
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ), // done: Extract single list item as a separate widget
        child: Provider.value(
          value: itemsToDisplay[index],
          child: ExpenseListItem(index: index),
        ),
      ),
    );
  }
}

// Example loading widget, we can declare it as private widget because it will only be used here
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _FilterEmptyWidget extends StatelessWidget {
  const _FilterEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('There is no Expenses in selected dates'),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Add Your Expanses'),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.watch<ExpenseProvider>().error!),
    );
  }
}

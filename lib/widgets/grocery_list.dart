import 'package:flutter/material.dart';
import 'package:grocories_tracker/models/grocery_model.dart';
import 'package:grocories_tracker/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryList();
}

class _GroceryList extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addNewItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (BuildContext context) => const NewItem()),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items Available'),
    );
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: Container(
            height: 24,
            width: 24,
            color: _groceryItems[index].category.color,
          ),
          title: Text(_groceryItems[index].name),
          trailing: Text(_groceryItems[index].quantity.toString()),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Groceries List'),
          actions: [
            IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add)),
          ],
        ),
        body: content);
  }
}

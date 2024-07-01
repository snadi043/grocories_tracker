import 'package:flutter/material.dart';
import 'package:grocories_tracker/data/dummy_items.dart';
import 'package:grocories_tracker/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryList();
}

class _GroceryList extends State<GroceryList> {
  void _addNewItem() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => const NewItem()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries List'),
        actions: [
          IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: Container(
            height: 24,
            width: 24,
            color: groceryItems[index].category.color,
          ),
          title: Text(groceryItems[index].name),
          trailing: Text(groceryItems[index].quantity.toString()),
        ),
      ),
    );
  }
}

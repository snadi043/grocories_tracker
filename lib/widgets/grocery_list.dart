import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocories_tracker/data/categories.dart';
import 'package:grocories_tracker/models/grocery_model.dart';
import 'package:grocories_tracker/widgets/new_item.dart';

import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryList();
}

class _GroceryList extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  @override
  initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-mobile-app-4c151-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
    });
  }

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

  void onRemove(item) {
    setState(() {
      _groceryItems.remove(item);
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
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) => {
            onRemove(_groceryItems[index]),
          },
          child: ListTile(
            leading: Container(
              height: 24,
              width: 24,
              color: _groceryItems[index].category.color,
            ),
            title: Text(_groceryItems[index].name),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
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

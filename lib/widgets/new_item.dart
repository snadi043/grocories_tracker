import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocories_tracker/data/categories.dart';
import 'package:grocories_tracker/models/category_model.dart';
import 'package:grocories_tracker/models/grocery_model.dart';
// import 'package:grocories_tracker/models/grocery_model.dart';

import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItem();
  }
}

class _NewItem extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitleValue = '';
  var _enteredQuantityValue = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _onAddItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-mobile-app-4c151-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode({
          'name': _enteredTitleValue,
          'quantity': _enteredQuantityValue,
          'category': _selectedCategory.title,
        }),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: _enteredTitleValue,
        quantity: _enteredQuantityValue,
        category: _selectedCategory,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Item'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onSaved: (value) {
                    _enteredTitleValue = value!;
                  },
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text('Name')),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must enter the name less than 50 letters';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onSaved: (value) {
                          _enteredQuantityValue = int.parse(value!);
                        },
                        initialValue: _enteredQuantityValue.toString(),
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value)! <= 1 ||
                              int.tryParse(value) == null) {
                            return 'Must enter valid positive integer';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: _selectedCategory,
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                        width: 16,
                                        height: 16,
                                        color: category.value.color),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(category.value.title),
                                  ],
                                ),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text('Reset')),
                    ElevatedButton(
                        onPressed: _onAddItem, child: const Text('Add Item')),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

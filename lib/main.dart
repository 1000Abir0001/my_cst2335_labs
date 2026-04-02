import 'package:flutter/material.dart';
import 'list_page.dart';
import 'details_page.dart';
import 'shopping_item.dart';
import 'database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Layouts Lab',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ResponsiveLayoutPage(),
    );
  }
}

class ResponsiveLayoutPage extends StatefulWidget {
  const ResponsiveLayoutPage({super.key});

  @override
  State<ResponsiveLayoutPage> createState() => _ResponsiveLayoutPageState();
}

class _ResponsiveLayoutPageState extends State<ResponsiveLayoutPage> {
  ShoppingItem? selectedItem;
  List<ShoppingItem> items = [];
  AppDatabase? _database; // Single database instance

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build();

    // Check if the database is empty — if so, insert some sample items
    final existing = await _database!.shoppingItemDao.findAllItems();
    if (existing.isEmpty) {
      await _database!.shoppingItemDao.insertItem(ShoppingItem(1, 'Apples', '5'));
      await _database!.shoppingItemDao.insertItem(ShoppingItem(2, 'Bananas', '12'));
      await _database!.shoppingItemDao.insertItem(ShoppingItem(3, 'Oranges', '3'));
      await _database!.shoppingItemDao.insertItem(ShoppingItem(4, 'Milk', '2'));
      await _database!.shoppingItemDao.insertItem(ShoppingItem(5, 'Bread', '1'));
    }

    _loadItemsFromDatabase();
  }

  Future<void> _loadItemsFromDatabase() async {
    final dbItems = await _database!.shoppingItemDao.findAllItems();
    setState(() {
      items = dbItems;
    });
  }

  void handleSelectItem(ShoppingItem item) {
    setState(() {
      selectedItem = item;
    });
  }

  void handleClose() {
    setState(() {
      selectedItem = null;
    });
  }

  Future<void> handleDelete() async {
    if (selectedItem != null) {
      await _database!.shoppingItemDao.deleteItem(selectedItem!);
      setState(() {
        items.removeWhere((i) => i.id == selectedItem!.id);
        selectedItem = null;
      });
    }
  }

  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: ListPage(items: items, onSelect: handleSelectItem),
          ),
          Expanded(
            flex: 2,
            child: selectedItem == null
                ? const Center(child: Text("Please select an item..."))
                : DetailsPage(
              item: selectedItem!,
              onClose: handleClose,
              onDelete: handleDelete,
            ),
          ),
        ],
      );
    } else {
      if (selectedItem == null) {
        return ListPage(items: items, onSelect: handleSelectItem);
      } else {
        return DetailsPage(
          item: selectedItem!,
          onClose: handleClose,
          onDelete: handleDelete,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Week 9 Lab - Responsive Layout"),
      ),
      body: reactiveLayout(),
    );
  }
}
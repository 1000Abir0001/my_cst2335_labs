import 'package:flutter/material.dart';

import 'database.dart';
import 'shopping_item.dart';
import 'shopping_item_dao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Controllers for the two TextFields
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // --- NEW DATABASE VARIABLES ---
  late ShoppingItemDao itemDao;
  List<ShoppingItem> shoppingList = [];
  int currentId = 1;
  bool isDatabaseReady = false; // flag to know when it's safe to draw the screen

  // --- INITIALIZE DATABASE ---
  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {

    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    itemDao = database.shoppingItemDao;

    // Load items from last time
    final items = await itemDao.findAllItems();
    setState(() {
      shoppingList = items;
      // next ID higher than the loaded
      for (var item in items) {
        if (item.id >= currentId) {
          currentId = item.id + 1;
        }
      }
      isDatabaseReady = true;
    });
  }

  // Add item function
  Future<void> _addItem() async {
    if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty ) {

      // Create the new item
      final newItem = ShoppingItem(
          currentId++,
          _itemController.text,
          _quantityController.text
      );

      // Save on database
      await itemDao.insertItem(newItem);

      // Update screen
      setState(() {
        shoppingList.add(newItem);

        // Clear both fields after adding
        _itemController.text = '';
        _quantityController.text = '';
      });
    }
  }

  // Delete dialog on long press
  void _showDeleteDialog(ShoppingItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Do you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Remove from database first
                await itemDao.deleteItem(item);

                setState(() {
                  shoppingList.remove(item); // Remove item from screen
                });
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Widget ListPage() {
    // if the database loading,show loading spinner
    if (!isDatabaseReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Input Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: _itemController,
                decoration: const InputDecoration(
                  hintText: 'Type the item here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  hintText: 'Type the quantity here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Click here'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ListView or Empty message
        Expanded(
          child: shoppingList.isEmpty ? const Center(
            child: Text('There are no items in the list'),
          )
              : ListView.builder(
            itemCount: shoppingList.length,
            itemBuilder: (context, rowNum) {
              final currentItem = shoppingList[rowNum]; // grab item

              return GestureDetector(
                onLongPress: () => _showDeleteDialog(currentItem), // Pass the whole item
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        '${rowNum + 1}: ${currentItem.name}  quantity: ${currentItem.quantity}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple[200],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListPage(),
      ),
    );
  }
}
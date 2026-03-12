import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
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

  // List to store items as maps {name, quantity}
  List<Map<String, String>> shoppingList = [];

  // Add item function
  void _addItem() {
    if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
      setState(() {
        shoppingList.add({
          'name': _itemController.text,
          'quantity': _quantityController.text,
        });
        // Clear both fields after adding
        _itemController.text = '';
        _quantityController.text = '';
      });
    }
  }

  // Delete dialog on long press
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Do you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  shoppingList.removeAt(index); // Remove item
                });
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Just close, do nothing
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Widget ListPage() {
    return Column(
      children: [
        // Input Row - two TextFields + Button
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
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  hintText: 'Type the quantity here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Click here'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ListView or Empty message
        Expanded(
          child: shoppingList.isEmpty
              ? const Center(
            child: Text('There are no items in the list'),
          )
              : ListView.builder(
            itemCount: shoppingList.length,
            itemBuilder: (context, rowNum) {
              return GestureDetector(
                onLongPress: () => _showDeleteDialog(rowNum),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${rowNum + 1}: ${shoppingList[rowNum]['name']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'quantity: ${shoppingList[rowNum]['quantity']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
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
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListPage(),
      ),
    );
  }
}

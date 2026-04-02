import 'package:flutter/material.dart';
import 'shopping_item.dart';

class DetailsPage extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  const DetailsPage({
    super.key,
    required this.item,
    required this.onClose,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Database ID: ${item.id}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Item Name: ${item.name}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("Quantity: ${item.quantity}", style: const TextStyle(fontSize: 18)),

          const SizedBox(height: 30),

          Row(
            children: [
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Delete", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                onPressed: onClose,
                child: const Text("Close"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
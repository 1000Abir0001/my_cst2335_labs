import 'package:flutter/material.dart';
import 'shopping_item.dart';

class ListPage extends StatelessWidget {
  final List<ShoppingItem> items;
  final Function(ShoppingItem) onSelect;

  const ListPage({
    super.key,
    required this.items,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    // I added a tiny little check here! If your database is empty,
    // it will gently tell you instead of just showing a scary blank white screen.
    if (items.isEmpty) {
      return const Center(child: Text("Your list is empty! Please add some items."));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final currentItem = items[index];
        return ListTile(
          title: Text(currentItem.name),
          subtitle: Text("Quantity: ${currentItem.quantity}"),
          onTap: () {
            onSelect(currentItem);
          },
        );
      },
    );
  }
}
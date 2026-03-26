import 'package:floor/floor.dart';

@entity
class ShoppingItem {
  @primaryKey
  final int id;
  final String name;
  final String quantity;

  ShoppingItem(this.id, this.name, this.quantity);
}
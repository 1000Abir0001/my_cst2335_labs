import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'shopping_item_dao.dart';
import 'shopping_item.dart';

//  tells the generator what to name the new file
part 'database.g.dart';

@Database(version: 1, entities: [ShoppingItem])
abstract class AppDatabase extends FloorDatabase {
  ShoppingItemDao get shoppingItemDao;

}
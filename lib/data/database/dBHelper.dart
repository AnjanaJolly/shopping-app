import 'package:food_delivery/data/models/cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id VARCHAR PRIMARY KEY, productId VARCHAR UNIQUE, productName TEXT, initialPrice DOUBLE, productPrice DOUBLE, quantity INTEGER, calories DOUBLE, image TEXT)');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    var queryResult = await dbClient!
        .rawQuery('SELECT * FROM cart WHERE productId="${cart.productId}"');
    if (queryResult.isEmpty) {
      await dbClient.insert('cart', cart.toMap());
    } else {
      updateQuantity(cart);
    }
    return cart;
  }

  Future clearTable() async {
    var db = await database;
    await db!.delete('cart');
    var queryResult = await db.rawQuery('SELECT * FROM cart');
    print(queryResult.isEmpty);
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cart');
    return queryResult.map((result) => Cart.fromMap(result)).toList();
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await database;
    var res = await dbClient!.update('cart', cart.quantityMap(),
        where: "productId = ?", whereArgs: [cart.productId]);

    return res;
  }
}

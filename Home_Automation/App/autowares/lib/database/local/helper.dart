import 'package:autowares/database/local/elementDetail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'widgetDetail.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';

class ProductDBHelper {
  static Database _db;
  static const String ID = 'id';
  
  static const String DEVICE_ID = 'deviceId';
  static const String NAME = 'name';

  static const String PRODUCT = 'product';
  static const String IP = 'ip';
  static const String PORT = 'port';
  static const String TABLE = 'widgets';
  static const String DB_NAME = 'room.db';

  static const String ELEMENT_ID = 'element_id';
  static const String ELEMENT_NAME = 'element_name';
  static const String ELEMENT_INDEX = 'element_index';


  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: onCreated);
    return db;
  }

  onCreated(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY ,$DEVICE_ID TEXT, $NAME TEXT,$PRODUCT TEXT,$IP TEXT,$PORT)");
        print('Device table created');
  }

  Future<ProductDetail> save(ProductDetail widgets) async {
    var dbClient = await db;
    widgets.id = await dbClient.insert(TABLE, widgets.toMap());
    createDeviceTable(widgets.name);
    return widgets;
  }

  Future<ProductDetail> update(ProductDetail widgets) async {
    var dbClient = await db;
    widgets.id = await dbClient.update(TABLE, widgets.toMap(),
        whereArgs: [widgets.id], where: '$ID = ?');
    return widgets;
  }

  Future<List<ProductDetail>> getWidgets() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID,DEVICE_ID, NAME,PRODUCT,IP,PORT]);
    List<ProductDetail> widgets = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        widgets.add(ProductDetail.fromMap(maps[i]));
      }
    }
    return widgets;
  }

  Future<ProductDetail> getParticularWidgetsById(int id) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery('SELECT * FROM $TABLE WHERE $ID = $id');
    var data = ProductDetail.fromMap(maps[0]);
    return data;
  }

  Future<List<ProductDetail>> getParticularWidgetsByProduct(String product) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery('SELECT * FROM $TABLE WHERE $PRODUCT = $product');
    List<ProductDetail> widgets = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        widgets.add(ProductDetail.fromMap(maps[i]));
      }
    }
    return widgets;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  createDeviceTable(String table)async{
    var dbClient = await db;
    await dbClient.execute("CREATE TABLE $table ($ELEMENT_ID INTEGER PRIMARY KEY ,$ELEMENT_INDEX INTEGER ,$ELEMENT_NAME TEXT)");
    print('element table created');
  }

  save_elements(ElementDetail elementDetail,String table)async{
    var dbClient = await db;
    await dbClient.insert(table, elementDetail.toMap());
  }

  Future<List<ElementDetail>> getElements(String table) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(table, columns: [ELEMENT_ID,ELEMENT_INDEX,ELEMENT_NAME]);
    List<ElementDetail> elements = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        elements.add(ElementDetail.fromMap(maps[i]));
      }
    }
    return elements;
  }
}

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/profil.dart';
import '../models/kategori.dart';
import '../models/subkategori.dart';
import '../models/produk.dart';
import '../models/carouselx.dart';
import '../models/keranjang.dart';

class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper==null) {
      _dbHelper = DbHelper._createObject();
    }else{}
    return _dbHelper!;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'tokoonline.db';

    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return todoDatabase;
  }

  //buat tabel baru
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profil (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userid TEXT,
        email TEXT,
        nama TEXT,
        alamat TEXT,
        kota TEXT,
        propinsi TEXT,
        kodepos TEXT,
        telp TEXT
      );   
    ''');
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT
      );   
    ''');
    await db.execute('''
      CREATE TABLE subkategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idkategori INTEGER,
        nama TEXT
      );   
    ''');
    await db.execute('''
      CREATE TABLE produk (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idkategori INTEGER,
        judul TEXT,
        harga TEXT,
        hargax TEXT,
        deskripsi TEXT,
        thumbnail TEXT
      );  
    ''');
    await db.execute('''
      CREATE TABLE carousel (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT,
        thumbnail TEXT,
        idproduk INTEGER,
        judul2 TEXT,
        harga2 TEXT,
        harga2x TEXT,
        deskripsi TEXT,
        thumbnail2 TEXT
      );  
    ''');
    await db.execute('''
      CREATE TABLE keranjang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idproduk INTEGER,
        judul TEXT,
        harga TEXT,
        hargax TEXT,
        thumbnail TEXT,
        jumlah INTEGER,
        userid TEXT,
        idcabang TEXT
      );  
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }else{}
    return _database!;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await database;
    var mapList = await db.query('profil', orderBy: 'nama');
    return mapList;
  }

  Future<int> insert(Profil object) async {
    Database db = await database;
    db.execute('delete from profil');
    int count = await db.insert('profil', object.toMap());
    return count;
  }

  Future<int> update(String nama, String alamat, String id) async {
    Database db = await database;
    db.execute(
        'update profil set nama=?,alamat=? where id=?', [nama, alamat, id]);
    int count = 1;
    return count;
  }

  Future<int> delete(int id) async {
    Database db = await database;
    int count = await db.delete('profil', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Profil>> getProfil() async {
    var profilMapList = await select();
    int count = profilMapList.length;
    List<Profil> profilList = List<Profil>.empty();
    profilList = profilList.toList();
    for (int i = 0; i < count; i++) {
      profilList.add(Profil.fromMap(profilMapList[i]));
    }
    return profilList;
  }

  //======================================================================================//
  Future<int> insertkategori(Kategori object) async {
    Database db = await database;
    int count = await db.insert("kategori", object.toMap());
    return count;
  }

  Future<int> deletekategori() async {
    Database db = await database;
    db.execute("delete from kategori");
    int count=1;
    //int count = await db.delete("kategori");
    return count;
  }

  Future<List<Map<String, dynamic>>> selectkategori() async {
    Database db = await database;
    var mapList = await db.query('kategori', orderBy: 'id');
    return mapList;
  }

  Future<List<Kategori>> getkategori() async {
    var mapList = await selectkategori();
    int count = mapList.length;
    List<Kategori> list = List<Kategori>.empty();
    list = list.toList();
    for (int i = 0; i < count; i++) {
      list.add(Kategori.fromMap(mapList[i]));
    }
    return list;
  }

  //======================================================================================//
  Future<int> insertsubkategori(Subkategori object) async {
    Database db = await database;
    int count = await db.insert("subkategori", object.toMap());
    return count;
  }

  Future<int> deletesubkategori() async {
    Database db = await database;
    //db.execute("delete from subkategori");
    int count = await db.delete('subkategori');
    return count;
  }

  Future<List<Map<String, dynamic>>> selectsubkategori(int idkategori) async {
    Database db = await database;
    var mapList = await db.query('subkategori', where: 'idkategori=?', whereArgs: [idkategori], orderBy: 'id');
    return mapList;
  }

  Future<List<Subkategori>> getsubkategori(int idkategori) async {
    var mapList = await selectsubkategori(idkategori);
    int count = mapList.length;
    List<Subkategori> list = List<Subkategori>.empty();
    list = list.toList();
    for (int i = 0; i < count; i++) {
      list.add(Subkategori.fromMap(mapList[i]));
    }
    return list;
  }

  //======================================================================================//
  Future<int> insertproduk(Produk object) async {
    Database db = await database;
    int count = await db.insert("produk", object.toMap());
    return count;
  }

  Future<int> deleteproduk(int idkategori) async {
    Database db = await database;
    int count = await db.delete('produk', where: 'idkategori=?', whereArgs: [idkategori]);
    return count;
  }

  Future<List<Map<String, dynamic>>> selectproduk(int idkategori) async {
    Database db = await database;
    var mapList = await db.query('produk', where: 'idkategori=?', whereArgs: [idkategori]);
    return mapList;
  }

  Future<List<Produk>> getproduk(int idkategori) async {
    var mapList = await selectproduk(idkategori);
    int count = mapList.length;
    List<Produk> list = List<Produk>.empty();
    list = list.toList();
    for (int i = 0; i < count; i++) {
      list.add(Produk.fromMap(mapList[i]));
    }
    return list;
  }

  //======================================================================================//
  Future<int> insertcarousel(Carouselx object) async {
    Database db = await database;
    int count = await db.insert("carousel", object.toMap());
    return count;
  }

  Future<int> deletecarousel() async {
    Database db = await database;
    //db.execute("delete from carousel");
    int count = await db.delete("carousel");
    return count;
  }

  Future<List<Map<String, dynamic>>> selectcarousel() async {
    Database db = await database;
    var mapList = await db.query('carousel', orderBy: 'judul');
    return mapList;
  }

  Future<List<Carouselx>> getcarousel() async {
    var mapList = await selectcarousel();
    int count = mapList.length;
    List<Carouselx> list = List<Carouselx>.empty();
    list = list.toList();
    for (int i = 0; i < count; i++) {
      list.add(Carouselx.fromMap(mapList[i]));
    }
    return list;
  }
  //======================================================================================//

  Future<List<Map<String, dynamic>>> selectkeranjang() async {
    Database db = await database;
    var mapList = await db.query('keranjang');
    return mapList;
  }

  Future<List<Keranjang>> getkeranjang() async {
    var mapList = await selectkeranjang();
    int count = mapList.length;
    List<Keranjang> list = List<Keranjang>.empty();
    list = list.toList();
    for (int i = 0; i < count; i++) {
      list.add(Keranjang.fromMap(mapList[i]));
    }
    return list;
  }



}

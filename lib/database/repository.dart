import 'dart:async';

import 'package:hive/hive.dart';

import '../models/models.dart';

import 'database.dart';

class Repository<T extends BoxModel> {
  late Box<T> _box;

  final _completer = Completer();

  /// getter to wait until the db is fully loaded when init is called from the constructor
  Future get isReady => _completer.future;

  Repository(String boxName) {
    init(boxName);
  }

  Future init(String boxName) async {
    // just to ensure the connections is done
    await Database.init();
    _box = await Hive.openBox<T>(boxName);
    _completer.complete();
  }

  Future<void> put(T model) async {
    return _box.put(model.id, model);
  }

  Future delete(T model) {
    return _box.delete(model.id);
  }

  Iterable<T> get values {
    return _box.values;
  }
}

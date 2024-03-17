import 'package:acccountmonthly/data/arus_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class ArusCubit extends Cubit<List<ArusData>> {
  ArusCubit() : super(<ArusData>[]);
  // static final data = [] as List<ArusData>;
  void addingAll(List<ArusData> data) {
    data.addAll(state);
    data.sort((a, b) => a.date.compareTo(b.date));
    emit(data);
  }

  void adding(ArusData data) {
    List<ArusData> datas = [data, ...state];
    datas.sort((a, b) => a.date.compareTo(b.date));
    emit(datas);
  }

  void clearAll() {
    emit([]);
  }

  Future<void> fetch(Database db) async {
    List<Map<String, Object?>> data =
        await db.query('notes', orderBy: 'date desc');
    List<ArusData> list = data.map((e) {
      return ArusData(
        id: e['id'] as int,
        description: e['description'] as String,
        date: e['date'] as String,
        money: e['money'] as int,
        type: e['type'] as String,
      );
    }).toList();
    // print(list);
    emit(list);
  }

  Future<void> insert(Database db, ArusData value) async {
    try {
      final res = await db.insert('notes', value.toMap());
      if (res != 0) {
        adding(value);
      }
    } catch (e) {
      print(e);
    }
  }
}

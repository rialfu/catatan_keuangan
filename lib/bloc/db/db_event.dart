import 'package:acccountmonthly/data/arus_data.dart';
import 'package:acccountmonthly/data/category_data.dart';
import 'package:acccountmonthly/data/grouping_category_data.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBEvent {}

class ConnectToDatabase extends DBEvent {}

class FirstTime extends DBEvent {}

class FirstTime2 extends DBEvent {}

class FetchData extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  final DateTime? date;
  // final DateTime? after;
  // final String before;
  // final String after;
  FetchData(
    this.db,
    this.data,
    this.categoryData, {
    this.date,
    this.weeklyData = const [],
  });
}

class FetchDataCategory extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  final DateTime? date;
  FetchDataCategory(
    this.db,
    this.data,
    this.categoryData, {
    this.date,
    this.weeklyData = const [],
  });
}

class FetchDataCategoryMonth extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  final DateTime? date;
  FetchDataCategoryMonth(
    this.db,
    this.data,
    this.categoryData, {
    this.date,
    this.weeklyData = const [],
  });
}

class ResetStatus extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  ResetStatus(
    this.db,
    this.data,
    this.categoryData, {
    this.weeklyData = const [],
  });
}

class InsertData extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final Map<String, Object> ins;
  List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  InsertData(this.db, this.data, this.ins,
      {this.categoryData = const [], this.weeklyData = const []});
}

class UpdateData extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final Map<String, Object> ins;
  final int id;
  List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  UpdateData(
    this.db,
    this.data,
    this.id,
    this.ins, {
    this.weeklyData = const [],
    this.categoryData = const [],
  });
}

class DeleteData extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final int id;
  List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  DeleteData(this.db, this.data, this.id,
      {this.categoryData = const [], this.weeklyData = const []});
}

class InsertDataCategory extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final Map<String, Object> ins;
  List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  InsertDataCategory(
    this.db,
    this.data,
    this.ins,
    this.weeklyData,
    this.categoryData,
  );
}

class UpdateDataCategory extends DBEvent {
  final Database db;
  final List<ArusData> data;
  final Map<String, Object> ins;
  List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  final int id;
  UpdateDataCategory(
    this.db,
    this.data,
    this.ins,
    this.weeklyData,
    this.categoryData,
    this.id,
  );
}

class DeleteDataCategory extends DBEvent {
  final Database db;
  final List<ArusData> data;
  List<GroupingCategoryData> weeklyData;
  final List<CategoryData> categoryData;
  final int id;
  DeleteDataCategory(
    this.db,
    this.data,
    this.weeklyData,
    this.categoryData,
    this.id,
  );
}

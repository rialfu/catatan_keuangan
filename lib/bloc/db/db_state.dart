import 'package:acccountmonthly/data/arus_data.dart';
import 'package:acccountmonthly/data/category_data.dart';
import 'package:acccountmonthly/data/grouping_category_data.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBState {
  List<CategoryData> get categoryData;
  List<ArusData> get data;
  List<GroupingCategoryData> get weeklyData;
  Database? get db;
}

class DBStateInitial implements DBState {
  @override
  List<CategoryData> categoryData = [];
  @override
  List<ArusData> data = [];
  @override
  List<GroupingCategoryData> weeklyData = [];
  @override
  Database? db;
}

class DBStateConnecting extends DBState {
  // override
  // List<CategoryData> categoryData = [];
  @override
  List<ArusData> data = [];
  @override
  List<GroupingCategoryData> weeklyData = [];
  @override
  List<CategoryData> categoryData = [];
  @override
  Database? db;
}

class DBStateConnected extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  final List<GroupingCategoryData> weeklyData;
  @override
  List<CategoryData> categoryData = [];

  DBStateConnected(
    this.db,
    this.categoryData, {
    this.data = const [],
    this.weeklyData = const [],
  });

  List<Object> get props => [db, data];
}

class DBStateConnectFailed extends DBState {
  @override
  List<ArusData> data = [];
  @override
  List<GroupingCategoryData> weeklyData = [];
  @override
  List<CategoryData> categoryData = [];
  @override
  Database? db;
}

class DBStateGetDataLoading extends DBState {
  @override
  final Database db;

  @override
  final List<ArusData> data;
  @override
  final List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  DBStateGetDataLoading(
    this.db,
    this.data,
    this.categoryData, {
    this.weeklyData = const [],
  });
}

class DBStateGetFailed extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  final List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  final String reason;
  DBStateGetFailed(
    this.db,
    this.data,
    this.categoryData, {
    this.reason = "",
    this.weeklyData = const [],
  });
}

class DBStateInsertDataLoading extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  DBStateInsertDataLoading(this.db, this.data, this.categoryData,
      {this.weeklyData = const []});
}

class DBStateInsertSuccess extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  DBStateInsertSuccess(this.db, this.data, this.categoryData,
      {this.weeklyData = const []});
}

class DBStateInsertFailed extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  final List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  final String reason;
  DBStateInsertFailed(
    this.db,
    this.data,
    this.categoryData, {
    this.reason = "",
    this.weeklyData = const [],
  });
}

class DBStateUpdateDataLoading extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  DBStateUpdateDataLoading(
    this.db,
    this.data,
    this.categoryData, {
    this.weeklyData = const [],
  });
}

class DBStateUpdateSuccess extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  DBStateUpdateSuccess(
    this.db,
    this.data,
    this.categoryData, {
    this.weeklyData = const [],
  });
}

class DBStateUpdateFailed extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  final List<GroupingCategoryData> weeklyData;

  @override
  final List<CategoryData> categoryData;
  final String reason;
  DBStateUpdateFailed(
    this.db,
    this.data,
    this.categoryData, {
    this.reason = "",
    this.weeklyData = const [],
  });
}

class DBStateDeleteDataLoading extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  DBStateDeleteDataLoading(this.db, this.data, this.categoryData,
      {this.weeklyData = const []});
}

class DBStateDeleteSuccess extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  List<GroupingCategoryData> weeklyData;
  @override
  final List<CategoryData> categoryData;
  DBStateDeleteSuccess(this.db, this.data, this.categoryData,
      {this.weeklyData = const []});
}

class DBStateDeleteFailed extends DBState {
  @override
  final Database db;
  @override
  final List<ArusData> data;
  @override
  final List<GroupingCategoryData> weeklyData;
  final String reason;
  @override
  final List<CategoryData> categoryData;
  DBStateDeleteFailed(
    this.db,
    this.data,
    this.categoryData, {
    this.reason = "",
    this.weeklyData = const [],
  });
}

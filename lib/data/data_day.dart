import 'package:acccountmonthly/data/arus_data.dart';
import 'package:equatable/equatable.dart';

class DataDay extends Equatable {
  // DateDay(this.day);
  final String day;
  final int totalIn;
  final int totalOut;
  final List<ArusData> data;
  const DataDay(
    this.day, {
    this.data = const [],
    this.totalIn = 0,
    this.totalOut = 0,
  });

  DataDay addingIn(int add) {
    return DataDay(
      day,
      data: data,
      totalIn: totalIn + add,
      totalOut: totalOut,
    );
  }

  DataDay addingOut(int add) {
    return DataDay(
      day,
      data: data,
      totalIn: totalIn,
      totalOut: totalOut + add,
    );
  }

  DataDay copyWith({
    String? day,
    List<ArusData>? data,
    int? totalIn,
    int? totalOut,
  }) {
    return DataDay(
      day ?? this.day,
      data: this.data,
      totalIn: totalIn ?? this.totalIn,
      totalOut: totalOut ?? this.totalOut,
    );
  }

  void add(ArusData value) {
    data.add(value);
  }

  @override
  List<Object> get props => [day, data];
}

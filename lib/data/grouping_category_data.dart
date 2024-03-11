import 'package:equatable/equatable.dart';

class GroupingCategoryData extends Equatable {
  final String category;
  final int totalIn;
  final int totalOut;
  const GroupingCategoryData({
    required this.category,
    this.totalIn = 0,
    this.totalOut = 0,
  });

  @override
  List<Object> get props => [category, totalIn, totalOut];
}

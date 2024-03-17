import 'package:equatable/equatable.dart';

class CategoryData extends Equatable {
  final int id;
  final String category;
  final String type;
  const CategoryData(this.id, this.category, this.type);
  @override
  List<Object> get props => [id, category, type];
  Map<String, Object> toMap() {
    return {
      'id': id,
      'category': category,
      'type': type,
    };
  }

  Map<String, Object> toMapWithoutId() {
    return {
      'category': category,
      'type': type,
    };
  }

  CategoryData copyWith({
    int? id,
    String? category,
    String? type,
  }) {
    return CategoryData(
      id ?? this.id,
      category ?? this.category,
      type ?? this.type,
    );
  }
}

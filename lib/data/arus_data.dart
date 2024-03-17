import 'package:equatable/equatable.dart';

class ArusData extends Equatable {
  final int id;
  final String description;
  final String date;
  final int money;
  final String type;
  final String category;

  const ArusData({
    required this.id,
    required this.description,
    required this.money,
    required this.date,
    required this.type,
    this.category = '',
  });

  @override
  List<Object> get props => [id, description, date, money, type];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'description': description,
      'money': money,
      'date': date,
      'type': type,
    };
  }
}

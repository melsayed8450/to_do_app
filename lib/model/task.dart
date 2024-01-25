import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Task extends Equatable {
  @HiveField(0)
  final String title;
  @HiveField(0)
  final String? description;
  @HiveField(0)
  final DateTime? dateTime;
  const Task({
    required this.title,
    this.description,
    this.dateTime,
  });

  @override
  List<Object> get props => [title, description ?? '', dateTime ?? ''];
}

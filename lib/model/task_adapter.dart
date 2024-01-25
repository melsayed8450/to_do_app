// person_adapter.dart

import 'package:hive/hive.dart';
import 'task.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 0;

  @override
  Task read(BinaryReader reader) {
    return Task(
      title: reader.read(),
      description: reader.read(),
      dateTime: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.write(obj.title);
    writer.write(obj.description);
    writer.write(obj.dateTime);
  }
}

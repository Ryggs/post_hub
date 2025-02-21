// Manually created adapter
import 'package:hive/hive.dart';

import 'data/models/post_hive_model.dart';

class PostHiveModelAdapter extends TypeAdapter<PostHiveModel> {
  @override
  final int typeId = 0;

  @override
  PostHiveModel read(BinaryReader reader) {
    final id = reader.readInt();
    final title = reader.readString();
    final body = reader.readString();
    final userId = reader.readInt();

    return PostHiveModel(
      id: id,
      title: title,
      body: body,
      userId: userId,
    );
  }

  @override
  void write(BinaryWriter writer, PostHiveModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.body);
    writer.writeInt(obj.userId);
  }
}
import 'package:hive/hive.dart';
import 'package:post_hub/domain/entities/post.dart';

@HiveType(typeId: 0)
class PostHiveModel extends HiveObject {

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final int userId;

  PostHiveModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

factory PostHiveModel.fromEntity(Post post) {
    return PostHiveModel(
      id: post.id,
      title: post.title,
      body: post.body,
      userId: post.userId,
    );
}

  Post toEntity() {
    return Post(
      id: id,
      title: title,
      body: body,
      userId: userId,
    );
  }
}
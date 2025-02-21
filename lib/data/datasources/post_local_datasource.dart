import 'package:hive/hive.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/post.dart';
import '../models/post_hive_model.dart';

abstract class PostLocalDatasource {
  Future<List<Post>> getCachedPosts();
  Future<void> cachePosts(List<Post> posts);
  Future<void> clearCache();
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  final Box<PostHiveModel> box;

  PostLocalDatasourceImpl({required this.box});

  @override
  Future<List<Post>> getCachedPosts() async {
    try {
      final posts = box.values.map((model) => model.toEntity()).toList();
      if (posts.isEmpty) {
        throw const CacheFailure('No cached posts available');
      }
      return posts;
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {
    try {
      await box.clear();
      final postModels = posts.map((post) => PostHiveModel.fromEntity(post)).toList();

      // Adding each model with a key
      for (int i = 0; i < postModels.length; i++) {
        await box.put(i, postModels[i]);
      }
    } catch (e) {
      throw CacheFailure('Failed to cache posts: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await box.clear();
    } catch (e) {
      throw CacheFailure('Failed to clear cache: ${e.toString()}');
    }
  }
}
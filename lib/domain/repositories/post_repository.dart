import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts(int page);

  Future<Either<Failure, Post>> getPostDetails(int id);

  Future<Either<Failure, List<Post>>> getCachedPosts();

  //Additional : resfreshing posts
  Future<Either<Failure, List<Post>>> refreshPosts();
}
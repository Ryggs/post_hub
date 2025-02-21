import 'package:dartz/dartz.dart';
import 'package:post_hub/core/errors/failures.dart';
import 'package:post_hub/core/network/network_info.dart';
import 'package:post_hub/data/datasources/post_remote_datasource.dart';
import 'package:post_hub/domain/entities/post.dart';
import 'package:post_hub/domain/repositories/post_repository.dart';

import '../datasources/post_local_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource remoteDatasource;
  final PostLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
});
  @override
  Future<Either<Failure, List<Post>>> getCachedPosts() async {

    try {
      final posts = await localDatasource.getCachedPosts();
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> getPostDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDatasource.getPostDetails(id);
        return Right(remotePost as Post);
      } catch (e)
      {
        return Left(ServerFailure(e.toString()));
      }
      } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts(int page) async{
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDatasource.getPosts(page);
        if (page == 1) {
          await localDatasource.cachePosts(remotePosts);
        }
        return Right(remotePosts);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final localPosts = await localDatasource.getCachedPosts();
        return Right(localPosts);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<Post>>> refreshPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDatasource.getPosts(1);
        await localDatasource.cachePosts(remotePosts);
        return Right(remotePosts);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

}
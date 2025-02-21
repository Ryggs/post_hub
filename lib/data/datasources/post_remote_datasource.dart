import 'package:post_hub/core/constants/api_constants.dart';
import 'package:post_hub/core/errors/failures.dart';
import 'package:post_hub/core/network/api_client.dart';
import 'package:post_hub/data/models/post_model.dart';

abstract class PostRemoteDatasource {
  Future<List<PostModel>> getPosts(int page);
  Future<List<PostModel>> getPostDetails(int id);
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final ApiClient client;
  PostRemoteDatasourceImpl({required this.client});

  @override
  Future<List<PostModel>> getPostDetails(int id) async {
    try {
      final response = await client.get(ApiConstants.getPostDetails(id));
      if (response.statusCode == 200) {
        return [PostModel.fromJson(response.data as Map<String, dynamic>)];
      } else {
        throw const ServerFailure('Failed to load post details');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getPosts(int page) async {
    try {
      final start = ( page - 1) * ApiConstants.postsPerPage;
      final response = await client.get(
        ApiConstants.posts,
        queryParameters: {
          '_start': start,
          '_limit': ApiConstants.postsPerPage,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data as List;
        return jsonList.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();

      } else {
        throw const ServerFailure('Failed to fetch posts');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
import 'package:equatable/equatable.dart';

import '../../domain/entities/post.dart';

abstract class PostState extends Equatable {
  const PostState();
  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  const PostsLoaded(this.posts, {this.hasReachedMax = false});

  @override
  List<Object> get props => [posts, hasReachedMax];
}

class PostError extends PostState {
  final String message;
  const PostError(this.message);
  @override
  List<Object> get props => [message];

}
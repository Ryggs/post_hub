import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object> get props => [];
}

class FetchPosts extends PostEvent {}

class FetchPostDetails extends PostEvent {
  final int postId;

  const FetchPostDetails(this.postId);
  @override
  List<Object> get props => [postId];
}

class LoadMorePosts extends PostEvent {}

class RefreshPosts extends PostEvent {}
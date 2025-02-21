import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_hub/presentation/bloc/post_event.dart';
import 'package:post_hub/presentation/bloc/post_state.dart';

import '../../domain/repositories/post_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;
  int _currentPage = 1;

  PostBloc(this.repository) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<FetchPostDetails>(_onFetchPostDetails);
    on<LoadMorePosts>(_onLoadMorePosts);
    on<RefreshPosts>(_onRefreshPosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await repository.getPosts(1);

    result.fold(
          (failure) => emit(PostError(failure.message)),
          (posts) {
        _currentPage = 1;
        emit(PostsLoaded(posts, hasReachedMax: posts.length < 10));
      },
    );
  }


  FutureOr<void> _onFetchPostDetails(FetchPostDetails event, Emitter<dynamic> emit) {
  }

  FutureOr<void> _onLoadMorePosts(LoadMorePosts event, Emitter<dynamic> emit) async {
    final currentState = state;
    if (currentState is PostsLoaded && !currentState.hasReachedMax) {
      final result = await repository.getPosts(++_currentPage);

      result.fold (
          (failure) => emit(PostError(failure.message)),
          (newPosts) {
            _currentPage++;
            final allPosts =  List.of(currentState.posts)..addAll(newPosts);
            emit(PostsLoaded(allPosts, hasReachedMax: newPosts.length < 10));
          },
      );
    }
  }

  FutureOr<void> _onRefreshPosts(RefreshPosts event, Emitter<PostState> emit) async {
    final result = await repository.refreshPosts();

    result.fold(
            (failure) => emit(PostError(failure.message)),
             (posts) {
                _currentPage = 1;
               emit(PostsLoaded(posts, hasReachedMax: posts.length < 10));
             },
    );
  }
}
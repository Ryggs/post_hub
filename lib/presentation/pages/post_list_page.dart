import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_hub/presentation/pages/post_detail_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/post_card.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final RefreshController _refreshController = RefreshController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _previousPostCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              title: Text('Posts'),
              centerTitle: true,
              floating: true,
              snap: true,
            ),
          ];
        },
        body: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            // Handle animated insertion of new items
            if (state is PostsLoaded && _previousPostCount > 0 &&
                state.posts.length > _previousPostCount) {

              final int newItemCount = state.posts.length - _previousPostCount;
              final int oldCount = _previousPostCount;
              _previousPostCount = state.posts.length;

              // Add a slight delay before starting animations
              Future.delayed(const Duration(milliseconds: 100), () {
                if (_listKey.currentState != null) {
                  for (int i = 0; i < newItemCount; i++) {
                    // Make sure we don't exceed list bounds
                    final insertIndex = oldCount + i;
                    if (insertIndex < state.posts.length) {
                      // Add a delay between each item animation
                      Future.delayed(Duration(milliseconds: 50 * i), () {
                        // Check if the widget is still mounted before inserting
                        if (mounted && _listKey.currentState != null) {
                          try {
                            _listKey.currentState!.insertItem(insertIndex);
                          } catch (e) {
                            // Handle any insertion errors silently
                            print('Animation insertion error: $e');
                          }
                        }
                      });
                    }
                  }
                }
              });
            } else if (state is PostsLoaded) {
              // Update the count for next comparison
              _previousPostCount = state.posts.length;
            }
          },
          builder: (context, state) {
            if (state is PostInitial || (state is PostLoading && state is! PostsLoaded)) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PostsLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: false,
                      onRefresh: () {
                        // Reset the list key to handle refresh properly
                        setState(() {
                          _previousPostCount = 0; // Reset for fresh data
                        });
                        context.read<PostBloc>().add(RefreshPosts());
                        _refreshController.refreshCompleted();
                      },
                      child: AnimatedList(
                        key: _listKey,
                        initialItemCount: state.posts.length,
                        itemBuilder: (context, index, animation) {
                          // Make sure we don't try to access out of bounds
                          if (index >= state.posts.length) {
                            return const SizedBox.shrink();
                          }

                          final post = state.posts[index];
                          return SlideTransition(
                            position: animation.drive(
                              Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                                  .chain(CurveTween(curve: Curves.easeOutQuint)),
                            ),
                            child: PostCard(
                              post: post,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<PostBloc>(context),
                                    child: PostDetailPage(post: post),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Load More button
                  if (!state.hasReachedMax)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PostBloc>().add(LoadMorePosts());
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Load More'),
                      ),
                    ),
                ],
              );
            }

            if (state is PostError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => context.read<PostBloc>().add(FetchPosts()),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
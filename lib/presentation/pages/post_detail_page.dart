import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_hub/presentation/bloc/post_bloc.dart';

import '../../domain/entities/post.dart';
import '../bloc/post_state.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();

}

class _PostDetailPageState extends State<PostDetailPage> {
  late Post post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<PostBloc, PostState>(
          builder: (BuildContext context, state) {
            if (state is PostsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post details content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.body,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    // Other Posts section
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Other Posts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Column(
                      children: state.posts
                          .where((p) => p.id != post.id)
                          .take(5) // Show only 5 other posts
                          .map<Widget>((otherPost) => ListTile(
                          title: Text(otherPost.title),
                          onTap: () {
                            setState(() {
                              post = otherPost;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BlocProvider.value(
                                      value: context.read<PostBloc>(),
                                      // Pass the existing bloc
                                      child: PostDetailPage(post: post),
                                    ),
                              ),
                            );
                          }
                      )
                      ) // Close the ListTile parenthesis here
                          .toList(),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }

}



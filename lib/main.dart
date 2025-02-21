import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:post_hub/presentation/bloc/post_bloc.dart';
import 'package:post_hub/presentation/pages/post_list_page.dart';

import 'injection_container.dart' as di;
import 'data/models/post_hive_model.dart';
import 'hive_adapter.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(const MyApp());
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PostHiveModelAdapter());
  await Hive.openBox<PostHiveModel>('posts_box');

  // Initialize dependencies
  await di.init();

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PostHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => di.sl<PostBloc>(),
        child: const PostListPage(),
      ),
    );
  }
}
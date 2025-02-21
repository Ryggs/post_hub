import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'data/datasources/post_local_datasource.dart';
import 'data/datasources/post_remote_datasource.dart';
import 'data/models/post_hive_model.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/post_repository.dart';
import 'hive_adapter.dart';
import 'presentation/bloc/post_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Inititalize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PostHiveModelAdapter());

  final postsBox = await Hive.openBox<PostHiveModel>('posts');

  sl.registerSingleton<Box<PostHiveModel>>(postsBox);

  // BLoC
  sl.registerFactory(() => PostBloc(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
        () => PostRepositoryImpl(
      remoteDatasource: sl<PostRemoteDatasource>(),
      localDatasource: sl<PostLocalDatasource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<PostRemoteDatasource>(
          () => PostRemoteDatasourceImpl(client: sl()),
  );

  sl.registerLazySingleton<PostLocalDatasource>(
          () => PostLocalDatasourceImpl(box: sl()),
  );
  // Core
  sl.registerLazySingleton<NetworkInfo>(
          () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton(
          () => ApiClient(),
  );


  //External
  sl.registerLazySingleton(
      () => InternetConnectionChecker(),
  );
  sl.registerLazySingleton<Box>(
      () => Hive.box('posts_box')
  );
}
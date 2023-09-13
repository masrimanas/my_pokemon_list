import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pokemon_list/src/bloc/pokemon_detail_bloc.dart';
import 'package:my_pokemon_list/src/cubit/pokemon_list_cubit.dart';
import 'package:my_pokemon_list/src/data/data.dart';
import 'package:my_pokemon_list/src/router/router.dart';
import 'package:my_pokemon_list/src/utils/http_client/http_client.dart';

final sl = GetIt.instance;

Future<void> initializeInstances() async {
  sl
    ..registerLazySingleton<GoRouter>(() => goRouter)
    ..registerLazySingleton<HttpClient>(HttpClient.new)
    ..registerLazySingleton<DataSource>(() => DataSource(client: sl()))
    ..registerLazySingleton<Repository>(() => Repository(dataSource: sl()))
    ..registerFactory<PokemonListCubit>(
      () => PokemonListCubit(repository: sl()),
    )
    ..registerFactory<PokemonDetailBloc>(
      () => PokemonDetailBloc(repository: sl()),
    );
}

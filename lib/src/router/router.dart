import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pokemon_list/injection.dart';
import 'package:my_pokemon_list/src/bloc/pokemon_detail_bloc.dart';
import 'package:my_pokemon_list/src/bloc/pokemon_detail_event.dart';
import 'package:my_pokemon_list/src/cubit/pokemon_list_cubit.dart';
import 'package:my_pokemon_list/src/utils/context_extension.dart';
import 'package:my_pokemon_list/src/view/view.dart';

part 'error_page.dart';

final goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: AppRoutes.home.path,
  routes: [..._routes],
  errorBuilder: (context, state) => const ErrorPage(),
);

final _routes = [
  GoRoute(
    path: AppRoutes.home.path,
    name: AppRoutes.home.name,
    builder: (context, state) {
      return BlocProvider<PokemonListCubit>(
        create: (context) => sl(),
        child: const HomeScreen(),
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.detail.path,
        name: AppRoutes.detail.name,
        builder: (context, state) {
          return BlocProvider<PokemonDetailBloc>(
            create: (context) => sl()
              ..add(
                PokemonDetailFetchCalled(
                  id: int.parse(state.pathParameters['id']!),
                ),
              ),
            child: const DetailScreen(),
          );
        },
      ),
    ],
  ),
];

enum AppRoutes {
  home(path: '/', name: 'home'),
  detail(path: 'detail/:id', name: 'detail');

  const AppRoutes({required this.name, required this.path});

  final String name;
  final String path;
}

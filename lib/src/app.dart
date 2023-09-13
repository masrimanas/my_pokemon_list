import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pokemon_list/injection.dart';
import 'package:my_pokemon_list/src/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: sl<GoRouter>(),
      theme: customAppTheme,
      restorationScopeId: 'app',
      // theme: customLightTheme,
    );
  }
}

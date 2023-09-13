import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_pokemon_list/injection.dart';
import 'package:my_pokemon_list/src/common/widgets/custom_error.dart';
import 'package:my_pokemon_list/src/cubit/pokemon_list_cubit.dart';
import 'package:my_pokemon_list/src/data/data.dart';
import 'package:my_pokemon_list/src/router/router.dart';
import 'package:my_pokemon_list/src/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -100,
              child: SvgPicture.asset(
                'assets/pokeball.svg',
                width: 300,
                height: 300,
                colorFilter: ColorFilter.mode(
                  context.colors.pokeballColor!,
                  BlendMode.dstIn,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: context.height,
              width: context.width,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Text(
                      'Pokedex',
                      style: context.textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(child: Center(child: _PokemonGrid())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PokemonGrid extends StatefulWidget {
  const _PokemonGrid();

  @override
  State<_PokemonGrid> createState() => _PokemonGridState();
}

class _PokemonGridState extends State<_PokemonGrid> {
  late final _cubit = sl<PokemonListCubit>();
  List<Pokemon> data = <Pokemon>[];
  int itemLength = 0;

  final PagingController<int, Pokemon> _pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    await _cubit.fetchPokemonList(offset: pageKey * 20);
    switch (_cubit.state) {
      case PokemonListLoaded(pokemonList: final value):
        final isLastPage = value.length < 20;
        if (isLastPage) {
          _pagingController.appendLastPage(value);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(value, nextPageKey);
        }
        setState(() {
          itemLength = _pagingController.itemList!.length;
        });

      case PokemonListError(message: final errorMessage):
        _pagingController.error = errorMessage;
      default:
        _pagingController.error = 'Unknown error occured';
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    _cubit.close();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, Pokemon>(
      shrinkWrap: true,
      pagingController: _pagingController,
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          for (int i = 0; i < itemLength; i++) const QuiltedGridTile(2, 3),
          const QuiltedGridTile(3, 6),
        ],
      ),
      builderDelegate: PagedChildBuilderDelegate<Pokemon>(
        newPageErrorIndicatorBuilder: (_) => CustomErrorWidget(
          message: 'Error in fetching data!',
          onRetry: _pagingController.retryLastFailedRequest,
        ),
        itemBuilder: (context, item, index) {
          return PokemonCard(
            pokemon: item,
            onPressed: () => context.goNamed(
              AppRoutes.detail.name,
              pathParameters: {'id': item.id.toString()},
            ),
          );
        },
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    required this.pokemon,
    this.onPressed,
    super.key,
  });

  final Pokemon pokemon;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: switch (pokemon.types[0]) {
            'fire' => context.colors.redSpeciesColor,
            'grass' => context.colors.greenSpeciesColor,
            'water' => context.colors.blueSpeciesColor,
            _ => context.colors.defaultCardColor,
          },
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(-.8, -.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name.capitalize,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colors.textWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  for (final type in pokemon.types)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: context.colors.backgroundColor?.withOpacity(.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type.capitalize,
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: context.colors.textWhiteColor),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: -15,
              bottom: -20,
              child: SvgPicture.asset(
                'assets/pokeball.svg',
                width: 120,
                height: 120,
                colorFilter: ColorFilter.mode(
                  context.colors.pokeballColor!,
                  BlendMode.dstIn,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(1, 0.8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

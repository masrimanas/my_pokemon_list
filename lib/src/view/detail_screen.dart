// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_pokemon_list/src/bloc/pokemon_detail_bloc.dart';
import 'package:my_pokemon_list/src/common/widgets/custom_loading.dart';
import 'package:my_pokemon_list/src/data/models/pokemon_detail.dart';
import 'package:my_pokemon_list/src/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
        builder: (context, state) {
          return switch (state) {
            PokemonDetailLoading() => const CustomLoadingWidget(
                child: _DetailPage(pokemon: _dummyPokemon),
              ),
            PokemonDetailLoaded(pokemonDetail: final pokemon) =>
              _DetailPage(pokemon: pokemon),
            _ => Container()
          };
        },
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({
    required this.pokemon,
  });

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: switch (pokemon.types[0]) {
        'fire' => context.colors.redSpeciesColor,
        'grass' => context.colors.greenSpeciesColor,
        'water' => context.colors.blueSpeciesColor,
        _ => context.colors.defaultCardColor,
      },
      appBar: AppBar(
        title: const Text('Pokemon Detail'),
      ),
      body: Stack(
        children: [
          Positioned(
            right: -50,
            top: 100,
            child: Skeleton.ignore(
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
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: _SectionName(pokemon: pokemon)),
              const Spacer(flex: 2),
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: context.colors.backgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),
                          child: DefaultTabController(
                            length: 4,
                            child: Skeleton.ignore(
                              child: Scaffold(
                                appBar: AppBar(
                                  toolbarHeight: 0,
                                  bottom: const TabBar(
                                    padding: EdgeInsets.zero,
                                    labelPadding: EdgeInsets.zero,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: [
                                      Tab(child: Text('About')),
                                      Tab(child: Text('Base Stats')),
                                      Tab(child: Text('Evolution')),
                                      Tab(child: Text('Moves')),
                                    ],
                                  ),
                                ),
                                body: TabBarView(
                                  children: [
                                    _AboutSection(pokemon: pokemon),
                                    _StatsSection(pokemon: pokemon),
                                    _EvolutionSection(pokemon: pokemon),
                                    _MovesSection(pokemon: pokemon),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -130,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: CachedNetworkImage(
                            imageUrl: pokemon.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionName extends StatelessWidget {
  const _SectionName({
    required this.pokemon,
  });

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pokemon.name.capitalize,
                style: context.textTheme.displaySmall?.copyWith(
                  color: context.colors.textWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  for (final type in pokemon.types)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(top: 4, right: 10),
                      decoration: BoxDecoration(
                        color: context.colors.backgroundColor?.withOpacity(.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type.capitalize,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colors.textWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(),
            ],
          ),
          Text(
            '#${pokemon.id}',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colors.textWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({
    required this.pokemon,
  });

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          _DetailText(
            name: 'Species',
            detail: '${pokemon.about['species']}',
          ),
          _DetailText(
            name: 'Weight',
            detail: '${(pokemon.about['weight'] as int) / 10} kg',
          ),
          _DetailText(
            name: 'Height',
            detail: '${(pokemon.about['height'] as int) / 10} m',
          ),
          _DetailText(
            name: 'Abilities',
            detail: (pokemon.about['abilities'] as List<String>)
                .map((e) => e.capitalize)
                .join(', '),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({
    required this.pokemon,
  });

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 18),
        for (final stat in pokemon.stats)
          _DetailProgressBar(
            name:
                // ignore: avoid_dynamic_calls
                '${stat['stat']['name']}'.replaceAll('-', ' '),
            value: stat['base_stat'] as int,
          ),
        const SizedBox(height: 18),
      ],
    );
  }
}

class _EvolutionSection extends StatelessWidget {
  const _EvolutionSection({
    required this.pokemon,
  });

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          for (final (index, evo) in pokemon.evolution.indexed)
            _DetailText(
              name: 'Evolution ${index + 1}',
              detail: evo.capitalizeAll,
            ),
        ],
      ),
    );
  }
}

class _MovesSection extends StatelessWidget {
  const _MovesSection({
    required this.pokemon,
  });

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 18),
        for (final (index, move) in pokemon.moves.indexed)
          _DetailText(
            name: 'Move ${index + 1}',
            // ignore: avoid_dynamic_calls
            detail: (move['move']['name'] as String)
                .replaceAll('-', ' ')
                .capitalizeAll,
          ),
        const SizedBox(height: 18),
      ],
    );
  }
}

class _DetailText extends StatelessWidget {
  const _DetailText({
    required this.name,
    required this.detail,
  });

  final String name;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              width: 70,
              child: Text(
                name,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colors.textColor?.withOpacity(.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              detail,
              textAlign: TextAlign.start,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailProgressBar extends StatelessWidget {
  const _DetailProgressBar({
    required this.name,
    required this.value,
  });

  final String name;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 70,
              child: Text(
                name.length > 2 ? name.capitalizeAll : name.toUpperCase(),
                maxLines: 1,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colors.textColor?.withOpacity(.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colors.textColor?.withOpacity(.5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: value / 100,
              borderRadius: BorderRadius.circular(25),
              color: switch (value <= 50) {
                true => context.colors.greenSpeciesColor,
                false => context.colors.redSpeciesColor,
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _dummyPokemon = PokemonDetail(
  id: 1,
  name: 'bulbasaur',
  types: [
    'grass',
  ],
  about: {
    'height': '70cm',
  },
  stats: [
    {'stats': 'stats'},
  ],
  evolution: [
    'Ivisaur',
  ],
  moves: [
    {'move': 'move'},
  ],
);

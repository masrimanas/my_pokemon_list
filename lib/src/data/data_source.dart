// ignore_for_file: avoid_dynamic_calls

import 'package:my_pokemon_list/src/common/constants.dart';
import 'package:my_pokemon_list/src/data/data.dart';
import 'package:my_pokemon_list/src/utils/utils.dart';

class DataSource {
  DataSource({required HttpClient client}) : _client = client;

  final HttpClient _client;

  Future<List<Pokemon>> getPokemonList({
    required int offset,
    required int limit,
  }) async {
    final response = await _client.call<dynamic>(
      url: '/pokemon',
      requestType: RequestType.GET,
      queryParameters: <String, dynamic>{
        'offset': offset,
        'limit': limit,
      },
    );

    final pokemonList = <Pokemon>[];

    switch (response) {
      case ResponseSuccess(response: final value):
        for (final pokemon in value['results'] as List<dynamic>) {
          final pokemonDetail = await _client.call<dynamic>(
            url:
                '/pokemon/${(pokemon['url'] as String).split('/').firstWhere((value) => int.tryParse(value) != null)}',
            requestType: RequestType.GET,
          );

          switch (pokemonDetail) {
            case ResponseSuccess(response: final detailValue):
              final types = (detailValue['types'] as List<dynamic>)
                  .map((e) => e as Map<String, dynamic>)
                  .toList()
                  .map((e) => e['type'] as Map<String, dynamic>)
                  .toList();
              pokemonList.add(
                Pokemon(
                  name: detailValue['name'] as String,
                  url: pokemon['url'] as String,
                  types: types.map((e) => e.values.first as String).toList(),
                ),
              );

            case ResponseFailure(exception: final error):
              throw error;
            default:
              throw Exception('Unknown error occured!');
          }
        }
        {}
      case ResponseFailure(exception: final error):
        throw error;
      default:
        throw Exception('Unknown error occured!');
    }
    return pokemonList;
  }

  Future<PokemonDetail> getPokemonDetail(int id) async {
    final response = await _client.call<dynamic>(
      url: '/pokemon/$id',
      requestType: RequestType.GET,
    );

    final responseSpecies = await _client.call<dynamic>(
      url: '/pokemon-species/$id',
      requestType: RequestType.GET,
    );

    switch (response) {
      case ResponseSuccess(response: final value):
        final types = (value['types'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList()
            .map((e) => e['type'] as Map<String, dynamic>)
            .toList();
        final about = {
          'height': value['height'],
          'weight': value['weight'],
          'species': ((responseSpecies! as ResponseSuccess)
                  .response['genera']
                  .firstWhere(
                    // ignore: inference_failure_on_untyped_parameter
                    (e) => e['language']['name'] == 'en',
                  )['genus'] as String)
              .replaceAll('Pokémon', ''),
          'abilities': (value['abilities'] as List<dynamic>)
              .map((e) => e as Map<String, dynamic>)
              .toList()
              .map((e) => e['ability'] as Map<String, dynamic>)
              .toList()
              .map((e) => e['name'] as String)
              .toList(),
        };
        final stats = (value['stats'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        final evolution = await _getEvolutionChain(id);
        final moves = (value['moves'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        return PokemonDetail(
          id: id,
          name: value['name'] as String,
          types: types.map((e) => e.values.first as String).toList(),
          about: about,
          stats: stats,
          evolution: evolution,
          moves: moves,
        );
      case ResponseFailure(exception: final error):
        throw error;
      default:
        throw Exception('Unknown error occured!');
    }
  }

  Future<List<String>> _getEvolutionChain(int id) async {
    final response = await _client.call<dynamic>(
      url: '/evolution-chain/$id',
      requestType: RequestType.GET,
    );

    switch (response) {
      case ResponseSuccess(response: final value):
        final evolution = <dynamic>[];
        final chain = value['chain'] as Map<String, dynamic>;
        evolution.add(chain['species']['name']);
        if (chain['evolves_to'] != null) {
          final evolvesTo = chain['evolves_to'] as List<dynamic>;
          for (final pokemon in evolvesTo) {
            evolution.add(pokemon['species']['name']);
            if (pokemon['evolves_to'] != null) {
              final evolvesTo = pokemon['evolves_to'] as List<dynamic>;
              for (final pokemon in evolvesTo) {
                evolution.add(pokemon['species']['name']);
              }
            }
          }
        }
        return evolution.map((e) => e as String).toList();
      case ResponseFailure(exception: final error):
        throw error;
      default:
        throw Exception('Unknown error occured!');
    }
  }
}

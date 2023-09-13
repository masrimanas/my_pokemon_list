import 'package:my_pokemon_list/src/data/data.dart';
import 'package:my_pokemon_list/src/utils/utils.dart';

class Repository {
  Repository({required DataSource dataSource}) : _dataSource = dataSource;

  final DataSource _dataSource;

  Future<Result<List<Pokemon>, Exception>> getPokemonList({
    required int offset,
    required int limit,
  }) async {
    try {
      final pokemonList = await _dataSource.getPokemonList(
        offset: offset,
        limit: limit,
      );
      return Success(pokemonList);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<PokemonDetail, Exception>> getPokemonDetail(int id) async {
    try {
      final pokemonDetail = await _dataSource.getPokemonDetail(id);
      return Success(pokemonDetail);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}

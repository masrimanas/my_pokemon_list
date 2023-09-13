// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PokemonDetail extends Equatable {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.types,
    required this.about,
    required this.stats,
    required this.evolution,
    required this.moves,
  });

  final int id;
  final String name;
  final List<String> types;
  final Map<String, dynamic> about;
  final List<Map<String, dynamic>> stats;
  final List<String> evolution;
  final List<Map<String, dynamic>> moves;

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  PokemonDetail copyWith({
    int? id,
    String? name,
    List<String>? types,
    Map<String, dynamic>? about,
    List<Map<String, dynamic>>? stats,
    List<String>? evolution,
    List<Map<String, dynamic>>? moves,
  }) {
    return PokemonDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      types: types ?? this.types,
      about: about ?? this.about,
      stats: stats ?? this.stats,
      evolution: evolution ?? this.evolution,
      moves: moves ?? this.moves,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      types,
      about,
      stats,
      evolution,
      moves,
    ];
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  const Pokemon({
    required this.types,
    required this.name,
    required this.url,
  });

  final List<String> types;
  final String name;
  final String url;

  int get id => int.parse(
        url.split('/').firstWhere((value) => int.tryParse(value) != null),
      );
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  Pokemon copyWith({
    List<String>? types,
    String? name,
    String? url,
  }) {
    return Pokemon(
      types: types ?? this.types,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [types, name, url];
}

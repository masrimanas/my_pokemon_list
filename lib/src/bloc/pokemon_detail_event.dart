import 'package:equatable/equatable.dart';

abstract class PokemonDetailEvent extends Equatable {
  const PokemonDetailEvent();
  @override
  List<Object?> get props => [];
}

class PokemonDetailFetchCalled extends PokemonDetailEvent {
  const PokemonDetailFetchCalled({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

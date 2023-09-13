part of 'pokemon_detail_bloc.dart';

sealed class PokemonDetailState extends Equatable {
  const PokemonDetailState();
  @override
  List<Object?> get props => [];
}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailLoaded extends PokemonDetailState {
  const PokemonDetailLoaded({required this.pokemonDetail});

  final PokemonDetail pokemonDetail;

  @override
  List<Object?> get props => [pokemonDetail];
}

class PokemonDetailError extends PokemonDetailState {
  const PokemonDetailError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

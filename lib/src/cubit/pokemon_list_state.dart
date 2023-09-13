part of 'pokemon_list_cubit.dart';

sealed class PokemonListState extends Equatable {
  const PokemonListState();
  @override
  List<Object?> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

class PokemonListLoaded extends PokemonListState {
  const PokemonListLoaded({required this.pokemonList});

  final List<Pokemon> pokemonList;

  @override
  List<Object?> get props => [pokemonList];
}

class PokemonListError extends PokemonListState {
  const PokemonListError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

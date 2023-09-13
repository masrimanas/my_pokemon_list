// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_pokemon_list/src/data/data.dart';
import 'package:my_pokemon_list/src/utils/utils.dart';

part 'pokemon_list_state.dart';

class PokemonListCubit extends Cubit<PokemonListState> {
  PokemonListCubit({
    required Repository repository,
  })  : _repository = repository,
        super(PokemonListInitial());

  final Repository _repository;

  FutureOr<void> fetchPokemonList({
    int offset = 0,
    int limit = 20,
  }) async {
    emit(PokemonListLoading());

    final result = await _repository.getPokemonList(
      offset: offset,
      limit: limit,
    );

    switch (result) {
      case Success(value: final pokemonList):
        emit(PokemonListLoaded(pokemonList: pokemonList));
      case Failure(exception: final exception):
        emit(PokemonListError(message: exception.toString()));
    }
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_pokemon_list/src/bloc/pokemon_detail_event.dart';
import 'package:my_pokemon_list/src/data/data.dart';
import 'package:my_pokemon_list/src/utils/utils.dart';

part 'pokemon_detail_state.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  PokemonDetailBloc({
    required Repository repository,
  })  : _repository = repository,
        super(PokemonDetailInitial()) {
    on<PokemonDetailFetchCalled>(_onFetch);
  }
  final Repository _repository;

  FutureOr<void> _onFetch(
    PokemonDetailFetchCalled event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(PokemonDetailLoading());
    final result = await _repository.getPokemonDetail(event.id);

    switch (result) {
      case Success(value: final pokemonDetail):
        emit(PokemonDetailLoaded(pokemonDetail: pokemonDetail));
      case Failure(exception: final exception):
        emit(PokemonDetailError(message: exception.toString()));
    }
  }
}

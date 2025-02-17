import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/pokemon_repository.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';
import 'dart:async';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository repository;
  int currentPage = 0;
  final int limit = 20; // Cambiado a 20 para la paginación correcta
  bool hasReachedMax = false;
  bool isSearching = false;

  PokemonBloc(this.repository) : super(PokemonLoading()) {
    on<LoadPokemons>(_onLoadPokemons);
    on<LoadMorePokemons>(_onLoadMorePokemons);
    on<SearchPokemons>(_onSearchPokemons);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadPokemons(
      LoadPokemons event, Emitter<PokemonState> emit) async {
    isSearching = false;
    emit(PokemonLoading());
    try {
      currentPage = 0;
      hasReachedMax = false;

      final pokemons = await repository.fetchPokemons(page: currentPage, limit: limit);
      emit(PokemonLoaded(
        pokemons: pokemons,
        hasReachedMax: pokemons.length < limit,
        currentPage: currentPage,
        isSearching: isSearching,
        pokemonCount: pokemons.length,
      ));
    } catch (e) {
      emit(PokemonError("Error al cargar Pokémon: ${e.toString()}"));
    }
  }

  Future<void> _onLoadMorePokemons(
      LoadMorePokemons event, Emitter<PokemonState> emit) async {
    if (hasReachedMax) return;
    final currentState = state;

    if (currentState is PokemonLoaded) {
      try {
        emit(PokemonLoadingMore()); // Nueva animación de carga con GIF
        await Future.delayed(Duration(seconds: 5)); // Simulación de carga con animación

        currentPage++;
        final newPokemons = await repository.fetchPokemons(page: currentPage, limit: limit);

        if (newPokemons.isEmpty) {
          hasReachedMax = true;
        }

        emit(currentState.copyWith(
          pokemons: List.from(currentState.pokemons)..addAll(newPokemons),
          hasReachedMax: newPokemons.isEmpty,
          currentPage: currentPage,
          pokemonCount: currentState.pokemonCount + newPokemons.length,
        ));
      } catch (e) {
        emit(PokemonError("Error al cargar más Pokémon: ${e.toString()}"));
      }
    }
  }

  Future<void> _onSearchPokemons(
      SearchPokemons event, Emitter<PokemonState> emit) async {
    isSearching = true;
    emit(PokemonLoading());
    try {
      final pokemons = await repository.searchPokemons(event.query);
      emit(PokemonLoaded(
        pokemons: pokemons,
        hasReachedMax: true,
        currentPage: 0,
        isSearching: true,
        pokemonCount: pokemons.length, // Cuenta correctamente los resultados de la búsqueda
      ));
    } catch (e) {
      emit(PokemonError("Error al buscar Pokémon: ${e.toString()}"));
    }
  }

  Future<void> _onClearSearch(
      ClearSearch event, Emitter<PokemonState> emit) async {
    isSearching = false;
    add(LoadPokemons()); // Recargar Pokémon desde el inicio
  }
}

class PokemonLoadingMore extends PokemonState {}

class PokemonLoadingMoreWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/pikachu.gif', height: 50),
          const SizedBox(height: 10),
          const Text("Cargando más Pokémon...", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

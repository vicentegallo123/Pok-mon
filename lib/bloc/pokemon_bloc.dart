import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/pokemon_repository.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';
import 'dart:async';

// Bloc para manejar los estados y eventos de la carga de Pokémon
class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository repository;
  int currentPage = 0; // Página actual para la paginación
  final int limit = 20; // Límite de Pokémon por carga
  bool hasReachedMax = false; // Indica si se ha alcanzado el límite de datos
  bool isSearching = false; // Indica si se está realizando una búsqueda

  PokemonBloc(this.repository) : super(PokemonLoading()) {
    on<LoadPokemons>(_onLoadPokemons);
    on<LoadMorePokemons>(_onLoadMorePokemons);
    on<SearchPokemons>(_onSearchPokemons);
    on<ClearSearch>(_onClearSearch);
  }

  // Maneja el evento de carga inicial de Pokémon
  Future<void> _onLoadPokemons(
      LoadPokemons event, Emitter<PokemonState> emit) async {
    isSearching = false;
    emit(PokemonLoading()); // Emitir estado de carga inicial
    try {
      currentPage = 0;
      hasReachedMax = false;

      final pokemons =
      await repository.fetchPokemons(page: currentPage, limit: limit);
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

  // Maneja el evento para cargar más Pokémon en la lista (paginación)
  Future<void> _onLoadMorePokemons(
      LoadMorePokemons event, Emitter<PokemonState> emit) async {
    if (hasReachedMax) return; // Si ya se alcanzó el límite, no cargar más
    final currentState = state;

    if (currentState is PokemonLoaded) {
      try {
        emit(PokemonLoadingMore()); // Mostrar el estado de carga adicional

        await Future.delayed(Duration(seconds: 2)); // Simulación de carga

        currentPage++;
        final newPokemons = await repository.fetchPokemons(page: currentPage, limit: limit);

        if (newPokemons.isEmpty) {
          hasReachedMax = true; // Si no hay más Pokémon, marcar como límite alcanzado
        }

        // Emitir el estado con la lista actualizada
        emit(PokemonLoaded(
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

  // Maneja la búsqueda de Pokémon
  Future<void> _onSearchPokemons(
      SearchPokemons event, Emitter<PokemonState> emit) async {
    isSearching = true;
    emit(PokemonLoading()); // Emitir estado de carga mientras se busca
    try {
      final pokemons = await repository.searchPokemons(event.query);
      emit(PokemonLoaded(
        pokemons: pokemons,
        hasReachedMax: true,
        currentPage: 0,
        isSearching: true,
        pokemonCount: pokemons.length,
      ));
    } catch (e) {
      emit(PokemonError("Error al buscar Pokémon: ${e.toString()}"));
    }
  }

  // Maneja la limpieza de la búsqueda y recarga la lista original
  Future<void> _onClearSearch(
      ClearSearch event, Emitter<PokemonState> emit) async {
    isSearching = false;
    add(LoadPokemons()); // Dispara un nuevo evento para cargar la lista original
  }
}

// Widget de carga con animación de Pikachu
class PokemonLoadingMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/pikachu.gif', height: 80, width: 80),
          const SizedBox(height: 10),
          const Text("Cargando más Pokémon...",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

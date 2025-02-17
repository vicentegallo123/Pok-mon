import 'package:equatable/equatable.dart';
import '../../data/models/pokemon.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => [];
}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  final bool hasReachedMax;
  final int currentPage;
  final bool isSearching;
  final int pokemonCount; // Contador de Pokémon

  const PokemonLoaded({
    required this.pokemons,
    required this.currentPage,
    required this.pokemonCount,
    this.hasReachedMax = false,
    this.isSearching = false,
  });

  PokemonLoaded copyWith({
    List<Pokemon>? pokemons,
    bool? hasReachedMax,
    int? currentPage,
    bool? isSearching,
    int? pokemonCount,
  }) {
    return PokemonLoaded(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isSearching: isSearching ?? this.isSearching,
      pokemonCount: pokemonCount ?? this.pokemonCount,
    );
  }

  @override
  List<Object> get props => [pokemons, hasReachedMax, currentPage, isSearching,pokemonCount];
}

class PokemonError extends PokemonState {
  final String message;
  const PokemonError(this.message);

  @override
  List<Object> get props => [message];
}

class PokemonSearchHistoryLoaded extends PokemonState {
  final List<String> history;
  const PokemonSearchHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

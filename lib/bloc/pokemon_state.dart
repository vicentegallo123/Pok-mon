import 'package:equatable/equatable.dart'; // Importamos equatable para facilitar la comparación de objetos en los estados
import '../../data/models/pokemon.dart'; // Importamos el modelo de datos de Pokémon

// Definimos una clase abstracta que representa el estado base de los Pokémon
abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => []; // Definimos una lista vacía de props para evitar advertencias
}

// Estado que indica que se está cargando la lista de Pokémon
class PokemonLoading extends PokemonState {}

// Estado que indica que se está cargando más datos (paginación)
class PokemonLoadingMore extends PokemonState {}

// Estado que indica que los Pokémon han sido cargados exitosamente
class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons; // Lista de Pokémon obtenidos
  final bool hasReachedMax; // Indica si se han obtenido todos los Pokémon disponibles
  final int currentPage; // Página actual de la lista paginada
  final bool isSearching; // Indica si el usuario está buscando Pokémon
  final int pokemonCount; // Número total de Pokémon obtenidos

  // Constructor del estado con parámetros requeridos y valores por defecto
  const PokemonLoaded({
    required this.pokemons,
    required this.currentPage,
    required this.pokemonCount,
    this.hasReachedMax = false,
    this.isSearching = false,
  });

  // Método para copiar el estado actual y modificar ciertos valores sin perder los demás datos
  PokemonLoaded copyWith({
    List<Pokemon>? pokemons,
    bool? hasReachedMax,
    int? currentPage,
    bool? isSearching,
    int? pokemonCount,
  }) {
    return PokemonLoaded(
      pokemons: pokemons ?? this.pokemons, // Si no se pasa un nuevo valor, se mantiene el actual
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isSearching: isSearching ?? this.isSearching,
      pokemonCount: pokemonCount ?? this.pokemonCount,
    );
  }

  @override
  List<Object> get props => [pokemons, hasReachedMax, currentPage, isSearching, pokemonCount];
// Se definen las propiedades para la comparación eficiente de objetos con Equatable
}

// Estado que indica que ocurrió un error al obtener los Pokémon
class PokemonError extends PokemonState {
  final String message; // Mensaje de error

  const PokemonError(this.message);

  @override
  List<Object> get props => [message]; // Se usa Equatable para comparar errores basados en su mensaje
}

// Estado que indica que el historial de búsqueda ha sido cargado
class PokemonSearchHistoryLoaded extends PokemonState {
  final List<String> history; // Lista de términos de búsqueda guardados

  const PokemonSearchHistoryLoaded(this.history);

  @override
  List<Object> get props => [history]; // Se usa Equatable para la comparación de estados
}

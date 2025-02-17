import 'package:equatable/equatable.dart';

/// Clase abstracta que define los eventos relacionados con Pokémon.
/// Extiende `Equatable` para facilitar la comparación de objetos en el Bloc.
abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

/// Evento para cargar la lista inicial de Pokémon.
class LoadPokemons extends PokemonEvent {}

/// Evento para cargar más Pokémon a la lista actual (paginación).
class LoadMorePokemons extends PokemonEvent {}

/// Evento para buscar Pokémon por nombre o criterio de búsqueda.
class SearchPokemons extends PokemonEvent {
  final String query;

  /// Constructor que recibe la consulta de búsqueda.
  const SearchPokemons(this.query);

  @override
  List<Object> get props => [query];
}

/// Evento para limpiar la búsqueda y volver a mostrar la lista completa.
class ClearSearch extends PokemonEvent {}

/// Evento para cargar el historial de búsquedas previas.
class LoadSearchHistory extends PokemonEvent {}

/// Evento para eliminar una consulta del historial de búsqueda.
class RemoveSearchHistory extends PokemonEvent {
  final String query;

  /// Constructor que recibe la consulta que se eliminará del historial.
  const RemoveSearchHistory(this.query);

  @override
  List<Object> get props => [query];
}

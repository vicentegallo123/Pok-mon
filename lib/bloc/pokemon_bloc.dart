import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/pokemon.dart';
import '../../data/repositories/pokemon_repository.dart';

/// Eventos para manejar las interacciones con la lista de Pokémon.
abstract class PokemonEvent {}

/// Evento para cargar la lista completa de Pokémon.
class LoadPokemons extends PokemonEvent {}

/// Evento para buscar Pokémon según un término de búsqueda.
class SearchPokemons extends PokemonEvent {
  /// Término de búsqueda ingresado por el usuario.
  final String query;

  /// Constructor que recibe el término de búsqueda.
  SearchPokemons(this.query);
}

/// Estados posibles del `Bloc` al manejar la lista de Pokémon.
abstract class PokemonState {}

/// Estado que indica que los datos están siendo cargados.
class PokemonLoading extends PokemonState {}

/// Estado que indica que los Pokémon han sido cargados correctamente.
class PokemonLoaded extends PokemonState {
  /// Lista de Pokémon obtenidos.
  final List<Pokemon> pokemons;

  /// Constructor que recibe la lista de Pokémon cargados.
  PokemonLoaded(this.pokemons);
}

/// Estado que indica que ha ocurrido un error al obtener los Pokémon.
class PokemonError extends PokemonState {}

/// `Bloc` que maneja la lógica de carga y búsqueda de Pokémon.
class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  /// Repositorio para obtener los datos de Pokémon.
  final PokemonRepository repository;

  /// Constructor del Bloc que inicializa el estado en [PokemonLoading].
  PokemonBloc(this.repository) : super(PokemonLoading()) {
    /// Maneja el evento [LoadPokemons] para cargar los datos de Pokémon.
    on<LoadPokemons>((event, emit) async {
      try {
        final pokemons = await repository.fetchPokemons();
        emit(PokemonLoaded(pokemons));
      } catch (_) {
        emit(PokemonError());
      }
    });

    /// Maneja el evento [SearchPokemons] para filtrar Pokémon por nombre.
    on<SearchPokemons>((event, emit) async {
      if (state is PokemonLoaded) {
        final pokemons = (state as PokemonLoaded).pokemons;
        final filteredPokemons = pokemons
            .where((p) => p.name.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(PokemonLoaded(filteredPokemons));
      }
    });
  }
}

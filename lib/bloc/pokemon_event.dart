import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class LoadPokemons extends PokemonEvent {}

class LoadMorePokemons extends PokemonEvent {}

class SearchPokemons extends PokemonEvent {
  final String query;
  const SearchPokemons(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends PokemonEvent {}

class LoadSearchHistory extends PokemonEvent {}

class RemoveSearchHistory extends PokemonEvent {
  final String query;
  const RemoveSearchHistory(this.query);

  @override
  List<Object> get props => [query];
}

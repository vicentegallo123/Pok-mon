import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/pokemon.dart';

/// Repositorio encargado de obtener datos de Pokémon desde la API.
class PokemonRepository {
  /// URL base de la API de Pokémon con un límite de 500 resultados.
  final String apiUrl = 'https://pokeapi.co/api/v2/pokemon?limit=200';

  /// Obtiene la lista de Pokémon desde la API.
  ///
  /// Retorna una lista de instancias de [Pokemon].
  /// En caso de error, lanza una excepción.
  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> results = data['results'];

      List<Pokemon> pokemons = [];
      for (var pokemon in results) {
        final pokeDetail = await http.get(Uri.parse(pokemon['url']));
        final pokeData = jsonDecode(pokeDetail.body);
        pokemons.add(Pokemon.fromJson(pokeData));
      }
      return pokemons;
    } else {
      throw Exception('Error al obtener Pokémon');
    }
  }
}

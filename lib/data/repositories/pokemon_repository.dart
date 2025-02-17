import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonRepository {
  static const int apiLimit = 1000; // Límite total de la API

  // Obtener Pokémon con paginación
  Future<List<Pokemon>> fetchPokemons({int page = 0, int limit = 20}) async {
    final offset = page * limit;
    if (offset >= apiLimit) return [];

    final url = 'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> results = data['results'];
      List<Pokemon> pokemons = [];

      for (var pokemon in results) {
        final detailResponse = await http.get(Uri.parse(pokemon['url']));
        if (detailResponse.statusCode == 200) {
          final detailData = jsonDecode(detailResponse.body);
          pokemons.add(Pokemon.fromJson(detailData));
        }
      }
      return pokemons;
    } else {
      throw Exception('Error al obtener Pokémon.');
    }
  }

  // Búsqueda en la API
  Future<List<Pokemon>> searchPokemons(String query) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return [Pokemon.fromJson(data)];
    } else {
      return []; // No se encontró el Pokémon
    }
  }
}

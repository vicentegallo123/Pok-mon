import 'dart:convert'; // Importamos para decodificar los datos JSON
import 'package:http/http.dart' as http; // Importamos la librería para hacer peticiones HTTP
import '../models/pokemon.dart'; // Importamos el modelo de datos de Pokémon

// Repositorio encargado de gestionar la obtención de datos desde la API de Pokémon
class PokemonRepository {
  static const int apiLimit = 1000; // Límite total de Pokémon en la API (según la PokéAPI)

  // Método para obtener Pokémon con paginación
  Future<List<Pokemon>> fetchPokemons({int page = 0, int limit = 20}) async {
    final offset = page * limit; // Calculamos el desplazamiento en la API
    if (offset >= apiLimit) return []; // Si el offset supera el límite, devolvemos una lista vacía

    // URL para obtener la lista de Pokémon según la página y el límite
    final url = 'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url)); // Hacemos la petición GET

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Decodificamos la respuesta JSON
      List<dynamic> results = data['results']; // Extraemos la lista de Pokémon
      List<Pokemon> pokemons = [];

      // Recorremos cada Pokémon obtenido en la lista de resultados
      for (var pokemon in results) {
        final detailResponse = await http.get(Uri.parse(pokemon['url'])); // Obtenemos los detalles del Pokémon
        if (detailResponse.statusCode == 200) {
          final detailData = jsonDecode(detailResponse.body); // Decodificamos los detalles
          pokemons.add(Pokemon.fromJson(detailData)); // Convertimos los datos a un objeto Pokemon y lo agregamos a la lista
        }
      }
      return pokemons; // Retornamos la lista de Pokémon obtenidos
    } else {
      throw Exception('Error al obtener Pokémon.'); // Si la API falla, lanzamos una excepción
    }
  }

  // Método para buscar un Pokémon por nombre o ID en la API
  Future<List<Pokemon>> searchPokemons(String query) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$query'; // Endpoint para buscar un Pokémon por su nombre o ID
    final response = await http.get(Uri.parse(url)); // Hacemos la petición GET

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Decodificamos la respuesta JSON
      return [Pokemon.fromJson(data)]; // Retornamos una lista con el Pokémon encontrado
    } else {
      return []; // Si no se encuentra, retornamos una lista vacía
    }
  }
}

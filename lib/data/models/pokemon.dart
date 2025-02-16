/// Representa un Pokémon con su nombre, imagen, ID, tipo, habilidades y movimiento principal.
class Pokemon {
  final String name;
  final String imageUrl;
  final int id;
  final String type;
  final List<String> abilities;  // Lista de habilidades
  final String mainMove;  // Movimiento principal

  /// Constructor de la clase [Pokemon].
  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.type,
    required this.abilities,
    required this.mainMove,
  });

  /// Crea una instancia de [Pokemon] a partir de un JSON.
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    var abilities = <String>[];
    for (var ability in json['abilities']) {
      abilities.add(ability['ability']['name']);
    }

    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      id: json['id'],
      type: json['types'][0]['type']['name'],
      abilities: abilities,
      mainMove: json['moves'][0]['move']['name'],  // Asumiendo el primer movimiento
    );
  }
}

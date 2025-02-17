// Definimos la clase Pokemon que representa un Pokémon con sus atributos principales
class Pokemon {
  final String name; // Nombre del Pokémon
  final String imageUrl; // URL de la imagen del Pokémon
  final int id; // ID único del Pokémon
  final String type; // Tipo principal del Pokémon (ej. Agua, Fuego, Planta)
  final List<String> abilities; // Lista de habilidades del Pokémon
  final String mainMove; // Movimiento principal del Pokémon
  final int hp; // Puntos de vida (HP)
  final int attack; // Estadística de ataque
  final int defense; // Estadística de defensa
  final int speed; // Velocidad del Pokémon
  final int spAttack; // Ataque especial
  final int spDefense; // Defensa especial
  final int accuracy; // Precisión del Pokémon (valor por defecto: 100)
  final int evasion; // Evasión del Pokémon (valor por defecto: 100)

  // Constructor de la clase, donde todos los parámetros son obligatorios
  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.type,
    required this.abilities,
    required this.mainMove,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.spAttack,
    required this.spDefense,
    required this.accuracy,
    required this.evasion,
  });

  // Método factory para crear un objeto Pokemon a partir de un JSON (usado para consumir API)
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extraemos la lista de habilidades del JSON
    var abilities = <String>[];
    for (var ability in json['abilities']) {
      abilities.add(ability['ability']['name']); // Extraemos el nombre de cada habilidad
    }

    return Pokemon(
      name: json['name'], // Nombre del Pokémon
      imageUrl: json['sprites']['front_default'], // URL de la imagen del Pokémon
      id: json['id'], // ID del Pokémon
      type: json['types'][0]['type']['name'], // Tomamos el primer tipo del Pokémon
      abilities: abilities, // Lista de habilidades extraída previamente
      mainMove: json['moves'][0]['move']['name'], // Primer movimiento disponible en la API
      hp: json['stats'][0]['base_stat'], // HP del Pokémon
      attack: json['stats'][1]['base_stat'], // Ataque del Pokémon
      defense: json['stats'][2]['base_stat'], // Defensa del Pokémon
      speed: json['stats'][5]['base_stat'], // Velocidad del Pokémon
      spAttack: json['stats'][3]['base_stat'], // Ataque especial del Pokémon
      spDefense: json['stats'][4]['base_stat'], // Defensa especial del Pokémon
      accuracy: 100,
      evasion: 100,
    );
  }
}

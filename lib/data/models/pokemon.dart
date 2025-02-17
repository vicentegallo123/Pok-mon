class Pokemon {
  final String name;
  final String imageUrl;
  final int id;
  final String type;
  final List<String> abilities;
  final String mainMove;
  final int hp;
  final int attack;
  final int defense;
  final int speed;
  final int spAttack;
  final int spDefense;
  final int accuracy;
  final int evasion;

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
      mainMove: json['moves'][0]['move']['name'],
      hp: json['stats'][0]['base_stat'],
      attack: json['stats'][1]['base_stat'],
      defense: json['stats'][2]['base_stat'],
      speed: json['stats'][5]['base_stat'],
      spAttack: json['stats'][3]['base_stat'],
      spDefense: json['stats'][4]['base_stat'],
      accuracy: 100,
      evasion: 100,
    );
  }
}

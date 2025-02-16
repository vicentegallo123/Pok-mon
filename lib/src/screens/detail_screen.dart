import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/pokemon.dart';


class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pokemon pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
    final Color typeColor = getTypeColor(pokemon.type);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.name.toUpperCase(),
          style: GoogleFonts.pressStart2p(),
        ),
        backgroundColor: typeColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: typeColor.withOpacity(0.5),
              child: Image.network(pokemon.imageUrl, height: 150 ),
            ),
            SizedBox(height: 16),
            Text('#${pokemon.id}', style: GoogleFonts.pressStart2p(fontSize: 14)),
            Text('Type: ${pokemon.type}',
                style: GoogleFonts.pressStart2p(fontSize: 14, color: typeColor)),
            SizedBox(height: 10),
            Text('Abilities:',
                style: GoogleFonts.pressStart2p(fontSize: 14, fontWeight: FontWeight.bold)),
            ...pokemon.abilities.map((ability) => Text(ability, style: GoogleFonts.pressStart2p(fontSize: 12))),
            SizedBox(height: 10),
            Text('Main Move:',
                style: GoogleFonts.pressStart2p(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(pokemon.mainMove, style: GoogleFonts.pressStart2p(fontSize: 12)),
            SizedBox(height: 20),
            Text('Stats:',
                style: GoogleFonts.pressStart2p(fontSize: 14, fontWeight: FontWeight.bold)),
            StatBar(label: 'Attack', value: 70),
            StatBar(label: 'Defense', value: 60),
            StatBar(label: 'Speed', value: 80),
          ],
        ),
      ),
    );
  }
}

class StatBar extends StatelessWidget {
  final String label;
  final int value;

  const StatBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: GoogleFonts.pressStart2p(fontSize: 12))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: value / 100,
                color: Colors.blue,
                backgroundColor: Colors.grey[300],
                minHeight: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'fire': return Colors.red;
    case 'water': return Colors.blue;
    case 'grass': return Colors.green;
    case 'electric': return Colors.yellow;
    case 'psychic': return Colors.purple;
    default: return Colors.grey;
  }
}

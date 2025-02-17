import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pokemon/data/models/pokemon.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  Color primaryColor = Colors.grey;
  Color secondaryColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _updatePalette();
  }

  Future<void> _updatePalette() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.pokemon.imageUrl),
      maximumColorCount: 10,
    );
    setState(() {
      primaryColor = paletteGenerator.dominantColor?.color ?? Colors.grey;
      secondaryColor = paletteGenerator.darkMutedColor?.color ?? Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              widget.pokemon.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.pokemon.name.toUpperCase(),
            style: TextStyle(
              color: secondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '#${widget.pokemon.id}',
            style: TextStyle(
              color: secondaryColor.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon/data/models/pokemon.dart';
import 'package:palette_generator/palette_generator.dart';

class DetailScreen extends StatefulWidget {
  final Pokemon pokemon;
  const DetailScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Color primaryColor = Colors.grey;
  Color secondaryColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _fetchPalette();
  }

  Future<void> _fetchPalette() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.pokemon.imageUrl),
      maximumColorCount: 5,
    );
    setState(() {
      primaryColor = paletteGenerator.dominantColor?.color ?? Colors.grey;
      secondaryColor = paletteGenerator.vibrantColor?.color ??
          paletteGenerator.lightVibrantColor?.color ??
          paletteGenerator.darkMutedColor?.color ??
          Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double circleSize = screenHeight * 0.4; // El círculo ocupa el 40% de la pantalla

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pokemon.name.toUpperCase(),
          style: GoogleFonts.pressStart2p(),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: circleSize,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              Image.network(
                widget.pokemon.imageUrl,
                height: circleSize * 1, // Imagen más grande dentro del círculo
                fit: BoxFit.contain,
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('#${widget.pokemon.id}' ,
                        style: GoogleFonts.pressStart2p(fontSize: 14)),
                    Text('Type: ${widget.pokemon.type}',
                        style: GoogleFonts.pressStart2p(
                            fontSize: 14, color: primaryColor)),
                    const SizedBox(height: 20),
                    _buildStatBar('HP', widget.pokemon.hp),
                    _buildStatBar('Attack', widget.pokemon.attack),
                    _buildStatBar('Defense', widget.pokemon.defense),
                    _buildStatBar('Speed', widget.pokemon.speed),
                    _buildStatBar('Sp. Attack', widget.pokemon.spAttack),
                    _buildStatBar('Sp. Defense', widget.pokemon.spDefense),
                    _buildStatBar('Accuracy', widget.pokemon.accuracy),
                    _buildStatBar('Evasion', widget.pokemon.evasion),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: GoogleFonts.pressStart2p(fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: value / 100,
                color: primaryColor, // Color dinámico según la paleta del Pokémon
                backgroundColor: secondaryColor.withOpacity(0.3),
                minHeight: 10,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text('$value', style: GoogleFonts.pressStart2p(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Fuente personalizada
import 'package:pokemon/data/models/pokemon.dart'; // Modelo de datos de Pokémon
import 'package:palette_generator/palette_generator.dart'; // Generador de colores basado en imágenes

// Pantalla de detalles de un Pokémon
class DetailScreen extends StatefulWidget {
  final Pokemon pokemon; // Recibe un objeto Pokémon
  const DetailScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Color primaryColor = Colors.grey; // Color principal del fondo
  Color secondaryColor = Colors.grey; // Color secundario

  @override
  void initState() {
    super.initState();
    _fetchPalette(); // Llamamos a la función para obtener la paleta de colores
  }

  // Método para generar colores a partir de la imagen del Pokémon
  Future<void> _fetchPalette() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.pokemon.imageUrl), // Usa la imagen del Pokémon
      maximumColorCount: 5, // Número máximo de colores a extraer
    );
    setState(() {
      primaryColor = paletteGenerator.dominantColor?.color ?? Colors.grey; // Color dominante
      secondaryColor = paletteGenerator.vibrantColor?.color ??
          paletteGenerator.lightVibrantColor?.color ??
          paletteGenerator.darkMutedColor?.color ??
          Colors.black; // Color secundario basado en la paleta generada
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height; // Altura de la pantalla
    final double circleSize = screenHeight * 0.4; // Tamaño del círculo (40% de la pantalla)

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pokemon.name.toUpperCase(), // Nombre del Pokémon en mayúsculas
          style: GoogleFonts.pressStart2p(), // Fuente personalizada
        ),
        backgroundColor: primaryColor, // Color de la barra de navegación
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
                  color: primaryColor.withOpacity(0.3), // Círculo de fondo con opacidad
                  shape: BoxShape.circle,
                ),
              ),
              Image.network(
                widget.pokemon.imageUrl, // Imagen del Pokémon
                height: circleSize * 1, // Tamaño relativo al círculo
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
                    Text('#${widget.pokemon.id}',
                        style: GoogleFonts.pressStart2p(fontSize: 14)), // ID del Pokémon
                    Text('Type: ${widget.pokemon.type}',
                        style: GoogleFonts.pressStart2p(
                            fontSize: 14, color: primaryColor)), // Tipo del Pokémon
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

  // Método para construir la barra de estadísticas
  Widget _buildStatBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: GoogleFonts.pressStart2p(fontSize: 12)), // Etiqueta de la estadística
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Bordes redondeados
              child: LinearProgressIndicator(
                value: value / 100, // Normaliza la estadística para la barra de progreso
                color: primaryColor, // Usa el color principal
                backgroundColor: secondaryColor.withOpacity(0.3), // Color de fondo de la barra
                minHeight: 10, // Altura de la barra
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text('$value', style: GoogleFonts.pressStart2p(fontSize: 12)), // Valor numérico
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart'; // Para extraer colores de la imagen del Pokémon
import 'package:pokemon/data/models/pokemon.dart'; // Importamos el modelo de Pokémon

// Widget que representa una tarjeta de Pokémon
class PokemonCard extends StatefulWidget {
  final Pokemon pokemon; // Objeto Pokémon a mostrar en la tarjeta

  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  Color primaryColor = Colors.grey; // Color de fondo de la tarjeta
  Color secondaryColor = Colors.grey; // Color del texto

  @override
  void initState() {
    super.initState();
    _updatePalette(); // Se obtiene la paleta de colores de la imagen del Pokémon
  }

  // Método para extraer los colores dominantes de la imagen del Pokémon
  Future<void> _updatePalette() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.pokemon.imageUrl), // Se obtiene la imagen del Pokémon
      maximumColorCount: 10, // Número máximo de colores a extraer
    );
    setState(() {
      primaryColor = paletteGenerator.dominantColor?.color ?? Colors.grey; // Color dominante
      secondaryColor = paletteGenerator.darkMutedColor?.color ?? Colors.black; // Color secundario
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryColor, // Fondo de la tarjeta basado en la imagen del Pokémon
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bordes redondeados
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centrar los elementos en la tarjeta
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25), // Bordes redondeados para la imagen
            child: Image.network(
              widget.pokemon.imageUrl, // Imagen del Pokémon
              height: 100, // Altura de la imagen
              width: 100, // Ancho de la imagen
              fit: BoxFit.cover, // Ajuste de la imagen dentro del contenedor
            ),
          ),
          const SizedBox(height: 5), // Espacio entre la imagen y el texto
          Text(
            widget.pokemon.name.toUpperCase(), // Nombre del Pokémon en mayúsculas
            style: TextStyle(
              color: secondaryColor, // Color del texto según la paleta generada
              fontSize: 16, // Tamaño del texto
              fontWeight: FontWeight.bold, // Negrita para resaltar el nombre
            ),
          ),
          Text(
            '#${widget.pokemon.id}', // ID del Pokémon
            style: TextStyle(
              color: secondaryColor.withOpacity(0.8), // Color con opacidad
              fontSize: 14, // Tamaño del texto
            ),
          ),
        ],
      ),
    );
  }
}

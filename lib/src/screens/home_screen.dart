import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pokemon_bloc.dart';


/// HomeScreen es la pantalla principal de la aplicación.
/// Muestra una lista de Pokémon y permite buscarlos por nombre.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Barra de navegación superior con una imagen como título.
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Logo de la aplicación en la barra de navegación.
            Image.asset('assets/descarga.png', height: 60),
          ],
        ),
      ),
      body: Column(
        children: [
          /// Campo de búsqueda para filtrar Pokémon.
          Padding(
            padding: EdgeInsets.all(7.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              /// Se dispara un evento de búsqueda cuando el usuario escribe.
              onChanged: (query) {
                context.read<PokemonBloc>().add(SearchPokemons(query));
              },
            ),
          ),
          /// Muestra la lista de Pokémon utilizando el Bloc.
          Expanded(
            child: BlocBuilder<PokemonBloc, PokemonState>(
              builder: (context, state) {
                if (state is PokemonLoading) {
                  /// Muestra un indicador de carga mientras se obtienen los datos.
                  return Center(child: CircularProgressIndicator());
                } else if (state is PokemonLoaded) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      /// Define el número de columnas según el tamaño de la pantalla.
                      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: .8,
                        ),
                        itemCount: state.pokemons.length,
                        itemBuilder: (context, index) {
                          final pokemon = state.pokemons[index];
                          final Color typeColor = getTypeColor(pokemon.type);
                          return GestureDetector(
                            /// Al tocar, navega a la pantalla de detalles del Pokémon.
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: pokemon,
                              );
                            },
                            child: Card(
                              /// Color de fondo basado en el tipo del Pokémon.
                              color: typeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /// Imagen del Pokémon con bordes redondeados.
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      pokemon.imageUrl,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  /// Nombre del Pokémon en mayúsculas.
                                  Text(
                                    pokemon.name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  /// Número identificador del Pokémon.
                                  Text(
                                    '#${pokemon.id}',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  /// Muestra un mensaje de error si no se pudieron cargar los Pokémon.
                  return Center(child: Text('Error al cargar Pokémon'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Retorna un color basado en el tipo de Pokémon.
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

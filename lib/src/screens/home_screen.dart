import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Para la gestión de estado con BLoC
import 'package:shared_preferences/shared_preferences.dart'; // Para almacenar el historial de búsqueda
import 'package:pokemon/bloc/pokemon_state.dart'; // Importación del estado del BLoC
import 'package:pokemon/bloc/pokemon_event.dart'; // Importación de los eventos del BLoC
import 'package:pokemon/bloc/pokemon_bloc.dart'; // Importación del BLoC de Pokémon
import '../widgets/pokemon_card.dart'; // Widget personalizado para mostrar las tarjetas de Pokémon

// Pantalla principal de la aplicación
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController(); // Controlador para detectar el scroll
  final TextEditingController _searchController = TextEditingController(); // Controlador del campo de búsqueda
  String currentSearch = ''; // Almacena la búsqueda actual
  List<String> searchHistory = []; // Historial de búsquedas guardado
  bool isReloading = false; // Indica si se está recargando la lista de Pokémon
  bool isSearching = false; // Indica si se está realizando una búsqueda

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll); // Agrega un listener al scroll
    _loadSearchHistory(); // Carga el historial de búsqueda almacenado en caché
    context.read<PokemonBloc>().add(LoadSearchHistory()); // Carga el historial en el BLoC
  }

  // Método que detecta cuando se llega al final del scroll
  void _onScroll() {
    if (_isBottom && !isSearching) {
      context.read<PokemonBloc>().add(LoadMorePokemons()); // Cargar más Pokémon cuando se llega al final
    }
  }

  // Comprueba si se ha llegado al final del scroll
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  // Cargar el historial de búsqueda desde SharedPreferences
  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  // Guardar una nueva búsqueda en el historial
  void _saveSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!searchHistory.contains(query)) {
        searchHistory.insert(0, query);
        if (searchHistory.length > 10) {
          searchHistory.removeLast();
        }
        prefs.setStringList('searchHistory', searchHistory);
      }
    });
  }

  // Acción cuando se realiza una búsqueda
  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      setState(() {
        currentSearch = query;
        isSearching = true;
      });

      _saveSearchHistory(query);
      context.read<PokemonBloc>().add(SearchPokemons(query));
    }
  }

  // Eliminar un elemento del historial de búsqueda
  void _onDeleteHistoryItem(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory.remove(query);
      prefs.setStringList('searchHistory', searchHistory);
    });
  }

  // Recargar la lista de Pokémon
  void _reloadPokemonList() {
    setState(() {
      isReloading = true;
      _searchController.clear();
      currentSearch = '';
      isSearching = false;
    });

    context.read<PokemonBloc>().add(LoadPokemons());

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isReloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _reloadPokemonList,
          child: isReloading
              ? Image.asset('assets/descarga2.png', height: 50)
              : Image.asset('assets/descarga.png', height: 50), // Cambia la imagen al recargar
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  // Muestra la cantidad total de Pokémon obtenidos
                  BlocBuilder<PokemonBloc, PokemonState>(
                    builder: (context, state) {
                      if (state is PokemonLoaded) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 7),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Total Pokémon: ${state.pokemonCount}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  // Campo de búsqueda
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Buscar Pokémon...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _onSearchSubmitted,
                  ),
                  // Muestra el historial de búsqueda
                  if (searchHistory.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Wrap(
                        spacing: 2.0,
                        runSpacing: 2.0,
                        children: searchHistory.map((query) {
                          return GestureDetector(
                            onTap: () {
                              _searchController.text = query;
                              _onSearchSubmitted(query);
                            },
                            child: Chip(
                              label: Text(query,
                                  style: const TextStyle(fontSize: 10)),
                              backgroundColor: Colors.blue.shade100,
                              deleteIcon: const Icon(Icons.close, size: 15),
                              onDeleted: () => _onDeleteHistoryItem(query),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
            // Mensaje de búsqueda actual
            if (isSearching)
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  "Resultados para: \"$currentSearch\"",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
            // Lista de Pokémon en formato Grid
            Expanded(
              child: BlocBuilder<PokemonBloc, PokemonState>(
                builder: (context, state) {
                  if (state is PokemonLoading) {
                    return const Center(child: CircularProgressIndicator()); // Cargando Pokémon
                  } else if (state is PokemonLoadingMore) {
                    return const Center(child: CircularProgressIndicator()); // Cargando más Pokémon
                  } else if (state is PokemonLoaded) {
                    if (state.pokemons.isEmpty) {
                      return _buildErrorWidget("No se encontraron resultados.");
                    }
                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: state.pokemons.length,
                      itemBuilder: (context, index) {
                        final pokemon = state.pokemons[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: pokemon,
                            );
                          },
                          child: PokemonCard(pokemon: pokemon), // Widget que muestra un Pokémon
                        );
                      },
                    );
                  } else if (state is PokemonError) {
                    return _buildErrorWidget(state.message);
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar errores
  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/error.png', height: 150),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

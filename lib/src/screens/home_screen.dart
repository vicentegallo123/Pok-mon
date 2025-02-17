import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pokemon/bloc/pokemon_state.dart';
import 'package:pokemon/bloc/pokemon_event.dart';
import 'package:pokemon/bloc/pokemon_bloc.dart';
import '../widgets/pokemon_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String currentSearch = '';
  List<String> searchHistory = [];
  bool isReloading = false;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadSearchHistory();
    context.read<PokemonBloc>().add(LoadSearchHistory());
  }

  void _onScroll() {
    if (_isBottom && !isSearching) {
      context.read<PokemonBloc>().add(LoadMorePokemons());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

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

  void _onDeleteHistoryItem(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory.remove(query);
      prefs.setStringList('searchHistory', searchHistory);
    });
  }

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
              : Image.asset('assets/descarga.png', height: 50),
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
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Buscar Pokémon...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _onSearchSubmitted,
                  ),
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
            Expanded(
              child: BlocBuilder<PokemonBloc, PokemonState>(
                builder: (context, state) {
                  if (state is PokemonLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PokemonLoaded) {
                    if (state.pokemons.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/error.png', height: 150),
                            const SizedBox(height: 20),
                            const Text(
                              "No se encontraron resultados.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                          child: PokemonCard(pokemon: pokemon),
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

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/error.png', height: 150),
          const SizedBox(height: 20),
          Text(
            message.isNotEmpty ? message : "Error desconocido",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

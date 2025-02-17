import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Para la gestión de estado con BLoC
import 'data/repositories/pokemon_repository.dart'; // Repositorio para obtener datos de Pokémon
import 'package:pokemon/bloc/pokemon_bloc.dart'; // BLoC que maneja la lógica de Pokémon
import 'package:pokemon/bloc/pokemon_event.dart'; // Eventos para gestionar estados en BLoC
import 'package:pokemon/src/screens/home_screen.dart'; // Pantalla principal (lista de Pokémon)
import 'package:pokemon/src/screens/detail_screen.dart'; // Pantalla de detalles de un Pokémon
import 'package:pokemon/data/models/pokemon.dart'; // Modelo de datos de Pokémon
import 'package:shared_preferences/shared_preferences.dart'; // Para el almacenamiento de datos locales

// Función principal que inicia la aplicación
void main() {
  runApp(const MyApp()); // Lanza la aplicación
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PokemonRepository repository = PokemonRepository(); // Se crea una instancia del repositorio

    return BlocProvider(
      create: (_) => PokemonBloc(repository)..add(LoadPokemons()),
      // Se crea el BLoC de Pokémon y se lanza el evento LoadPokemons() para cargar datos iniciales

      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Oculta la marca de depuración en la esquina superior derecha
        theme: ThemeData(primarySwatch: Colors.red), // Define el tema con un color principal rojo

        // Definición de rutas de navegación
        routes: {
          '/': (context) => const HomeScreen(), // Ruta principal que carga la lista de Pokémon
          '/detail': (context) {
            // Ruta de detalle que recibe un objeto Pokémon como argumento
            final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
            return DetailScreen(pokemon: pokemon);
          },
        },
      ),
    );
  }
}

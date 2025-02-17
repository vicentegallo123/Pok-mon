import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/pokemon_repository.dart';
import 'package:pokemon/bloc/pokemon_bloc.dart';
import 'package:pokemon/bloc/pokemon_event.dart';
import 'package:pokemon/src/screens/home_screen.dart';
import 'package:pokemon/src/screens/detail_screen.dart';
import 'package:pokemon/data/models/pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PokemonRepository repository = PokemonRepository();

    return BlocProvider(
      create: (_) => PokemonBloc(repository)..add(LoadPokemons()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        routes: {
          '/': (context) => const HomeScreen(),
          '/detail': (context) {
            final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
            return DetailScreen(pokemon: pokemon);
          },
        },
      ),
    );
  }
}

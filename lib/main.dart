import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/pokemon_repository.dart';
import 'bloc/pokemon_bloc.dart';
import 'src/screens/routes.dart';
import 'src/screens/home_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PokemonRepository repository = PokemonRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonBloc(repository)..add(LoadPokemons()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Arial',
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/detail': (context) => DetailScreen(),
        },

      ),
    );
  }
}
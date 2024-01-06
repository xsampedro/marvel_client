import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marvel_client/bloc/favorites_cubit.dart';
import 'package:marvel_client/bloc/marvel_bloc.dart';
import 'package:marvel_client/pages/characters_page.dart';
import 'package:marvel_client/pages/comics_page.dart';
import 'package:marvel_client/services/favorites_service.dart';
import 'package:marvel_client/services/marvel_service.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FavoritesService>(
          create: (_) => FavoritesService(),
        ),
        Provider<MarvelService>(
          create: (_) => MarvelService(),
        ),
        BlocProvider<MarvelBloc>(
          create: (context) =>
              MarvelBloc(Provider.of<MarvelService>(context, listen: false))
                ..add(FetchCharacters()),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(
            Provider.of<FavoritesService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Marvel API Client',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return CharactersPage();
      case 1:
        return const ComicsPage();
      default:
        return CharactersPage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final MarvelBloc marvelBloc = context.read<MarvelBloc>();

    if (index == 0) {
      marvelBloc.add(FetchCharacters()); // Reload characters
    } else if (index == 1) {
      marvelBloc.add(FetchComics()); // Reload comics
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel API Client'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _buildPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Comics',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_client/bloc/marvel_bloc.dart';
import 'package:marvel_client/services/favorites_service.dart';
import 'package:marvel_client/widgets/character_tile.dart';
import 'package:marvel_client/widgets/marvel_search_bar.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  CharactersPageState createState() => CharactersPageState();
}

class CharactersPageState extends State<CharactersPage> {
  final ScrollController _scrollController = ScrollController();
  late MarvelBloc marvelBloc;
  late FavoritesService favoritesService;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    marvelBloc = context.read<MarvelBloc>();
    favoritesService = context.read<FavoritesService>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        marvelBloc.add(LoadMoreCharacters());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Characters'),
      ),
      body: Column(
        children: [
          MarvelSearchBar(onSearch: (query) {
            marvelBloc.add(FetchCharactersWithSearch(query));
          }),
          _buildSegmentedControl(),
          Expanded(
            child: _selectedIndex == 0
                ? _buildCharactersList()
                : _buildFavoritesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ChoiceChip(
            label: const Text('All Characters'),
            selected: _selectedIndex == 0,
            onSelected: (selected) {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Favorites'),
            selected: _selectedIndex == 1,
            onSelected: (selected) {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCharactersList() {
    return BlocBuilder<MarvelBloc, (MarvelState, List<dynamic>?)>(
      builder: (context, state) {
        if (state.$1 == MarvelState.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.$1 == MarvelState.loaded) {
          final characters = state.$2 ?? [];
          return ListView.builder(
            controller: _scrollController,
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterTile(character: character);
            },
          );
        } else {
          // MarvelState.error
          return Center(child: Text('Failed to load data'));
        }
      },
    );
  }

  Widget _buildFavoritesList() {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: favoritesService.favoritesNotifier,
      builder: (context, favoriteIds, _) {
        if (favoriteIds.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }
        return ListView.builder(
          itemCount: favoriteIds.length,
          itemBuilder: (context, index) {
            final characterId = favoriteIds.elementAt(index);
            final character = marvelBloc.state.$2!.firstWhere(
              (char) => char['id'].toString() == characterId,
              orElse: () => null,
            );

            if (character != null) {
              return CharacterTile(character: character);
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}

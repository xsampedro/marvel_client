import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_client/services/marvel_service.dart';

enum MarvelState { loading, loaded, error }

abstract class MarvelEvent {}

class FetchCharacters extends MarvelEvent {}
class LoadMoreCharacters extends MarvelEvent {}
class FetchCharactersWithSearch extends MarvelEvent {
  final String searchQuery;
  FetchCharactersWithSearch(this.searchQuery);
}

class FetchComics extends MarvelEvent {}
class LoadMoreComics extends MarvelEvent {}
class FetchComicsWithSearch extends MarvelEvent {
  final String searchQuery;
  FetchComicsWithSearch(this.searchQuery);
}

class MarvelBloc extends Bloc<MarvelEvent, (MarvelState, List<dynamic>?)> {
  final MarvelService marvelService;

  MarvelBloc(this.marvelService) : super((MarvelState.loaded, []));

  @override
  Stream<(MarvelState, List<dynamic>?)> mapEventToState(
      MarvelEvent event) async* {
    if (event is FetchCharacters ||
        event is FetchComics ||
        event is FetchCharactersWithSearch ||
        event is FetchComicsWithSearch) {
      yield (MarvelState.loading, null); // Start with loading state for initial fetch
    }

    try {
      if (event is FetchCharacters) {
        final characters = await marvelService.getCharacters();
        yield (MarvelState.loaded, characters);
      } else if (event is FetchComics) {
        final comics = await marvelService.getComics();
        yield (MarvelState.loaded, comics);
      } else if (event is FetchCharactersWithSearch) {
        final characters = await marvelService.getCharacters(searchQuery: event.searchQuery);
        yield (MarvelState.loaded, characters);
      } else if (event is FetchComicsWithSearch) {
        final comics = await marvelService.getComics(searchQuery: event.searchQuery);
        yield (MarvelState.loaded, comics);
      } else if (event is LoadMoreCharacters) {
        final currentCharacters = state.$2 ?? [];
        final newCharacters = await marvelService.getCharacters(
          limit: 20,
          offset: currentCharacters.length,
        );
        yield (MarvelState.loaded, currentCharacters + newCharacters);
      } else if (event is LoadMoreComics) {
        final currentComics = state.$2 ?? [];
        final newComics = await marvelService.getComics(
          limit: 20,
          offset: currentComics.length,
        );
        yield (MarvelState.loaded, currentComics + newComics);
      }
    } catch (_) {
      yield (MarvelState.error, []);
    }
  }
}

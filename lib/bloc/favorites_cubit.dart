import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_client/services/favorites_service.dart';

class FavoritesCubit extends Cubit<Set<String>> {
  final FavoritesService favoritesService;

  FavoritesCubit(this.favoritesService) : super({}) {
    _loadFavorites();
  }

  void _loadFavorites() async {
    emit(await favoritesService.getFavorites());
  }

  void toggleFavorite(String characterId) async {
    await favoritesService.toggleFavorite(characterId);
    _loadFavorites();
  }
}

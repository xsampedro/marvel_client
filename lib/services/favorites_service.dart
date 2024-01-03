import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _favoritesKey = 'favorites';
  ValueNotifier<Set<String>> favoritesNotifier = ValueNotifier({});

  FavoritesService() {
    _loadInitialFavorites();
  }

  Future<void> _loadInitialFavorites() async {
    favoritesNotifier.value = await getFavorites();
  }

  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey)?.toSet() ?? {};
  }

  Future<void> toggleFavorite(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (favorites.contains(characterId)) {
      favorites.remove(characterId);
    } else {
      favorites.add(characterId);
    }

    await prefs.setStringList(_favoritesKey, favorites.toList());
    favoritesNotifier.value = favorites;
  }
}

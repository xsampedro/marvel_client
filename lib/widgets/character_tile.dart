import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_client/bloc/favorites_cubit.dart';
import 'package:marvel_client/widgets/character_detail_sheet.dart';
import 'package:marvel_client/services/favorites_service.dart';

class CharacterTile extends StatelessWidget {
  final dynamic character;

  CharacterTile({required this.character});

  @override
  Widget build(BuildContext context) {
    String imageUrl = character['thumbnail']['path'] + '.jpg';
    imageUrl = imageUrl.replaceFirst('http://', 'https://');

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      title: Text(
        character['name'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Click for more details',
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return CharacterDetailSheet(character: character);
          },
        );
      },
      trailing: BlocBuilder<FavoritesCubit, Set<String>>(
        builder: (context, favorites) {
          final isFavorite = favorites.contains(character['id'].toString());
          return IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite ? Colors.red : null,
            onPressed: () => context
                .read<FavoritesCubit>()
                .toggleFavorite(character['id'].toString()),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharacterDetailSheet extends StatelessWidget {
  final dynamic character;

  CharacterDetailSheet({required this.character});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    String imageUrl = character['thumbnail']['path'] + '.jpg';
    imageUrl = imageUrl.replaceFirst('http://', 'https://');

    return Container(
      width: width,
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: width,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCharacterDetailSection('Name', character['name']),
                  _buildCharacterDetailSection(
                      'Description',
                      character['description'] != ""
                          ? character['description']
                          : "No description available."),
                  _buildCharacterDetailListSection(
                      'Comics', character['comics']['items']),
                  _buildCharacterDetailListSection(
                      'Series', character['series']['items']),
                  _buildCharacterDetailListSection(
                      'Stories', character['stories']['items']),
                  _buildCharacterDetailListSection(
                      'Events', character['events']['items']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(content, textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  Widget _buildCharacterDetailListSection(String title, List<dynamic> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 5),
          for (var item in items)
            Text(item['name'], textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}

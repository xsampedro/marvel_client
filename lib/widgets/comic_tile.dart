import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ComicTile extends StatelessWidget {
  final dynamic comic;

  ComicTile({required this.comic});

  @override
  Widget build(BuildContext context) {
    // Check if the thumbnail path is null
    String imageUrl =
        comic['thumbnail'] != null && comic['thumbnail']['path'] != null
            ? comic['thumbnail']['path'] + '.jpg'
            : 'https://via.placeholder.com/150'; // Placeholder image URL

    imageUrl = imageUrl.replaceFirst('http://', 'https://');

    // Providing a default value for the title if null
    String title = comic['title'] ?? 'No Title';

    // Providing a default value for the issue number if null
    String issueNumber =
        comic.containsKey('issueNumber') && comic['issueNumber'] != null
            ? comic['issueNumber'].toString()
            : 'N/A'; // Default text if issue number is null

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
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Issue Number: $issueNumber',
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      onTap: () {
        // Implement navigation or action on tap
        // For example, showing comic details
      },
      // Add trailing widget if needed, e.g., favorite icon
      // trailing: Icon(Icons.more_vert),
    );
  }
}

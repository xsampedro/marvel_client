import 'package:flutter/material.dart';

class MarvelSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const MarvelSearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.lightBlue[100],
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search',
          suffixIcon: Icon(Icons.search),
        ),
        onChanged: onSearch,
      ),
    );
  }
}

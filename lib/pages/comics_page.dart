import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_client/bloc/marvel_bloc.dart';
import 'package:marvel_client/widgets/comic_tile.dart';
import 'package:marvel_client/widgets/marvel_search_bar.dart';

class ComicsPage extends StatefulWidget {
  const ComicsPage({super.key});

  @override
  ComicsPageState createState() => ComicsPageState();
}

class ComicsPageState extends State<ComicsPage> {
  final ScrollController _scrollController = ScrollController();
  late MarvelBloc marvelBloc;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    marvelBloc = context.read<MarvelBloc>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (marvelBloc.state.$1 == MarvelState.loaded && !isLoadingMore) {
          isLoadingMore = true;
          marvelBloc.add(LoadMoreComics());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MarvelSearchBar(onSearch: (query) {
            marvelBloc.add(FetchComicsWithSearch(query));
          }),
          Expanded(
            child: BlocBuilder<MarvelBloc, (MarvelState, List<dynamic>?)>(
              builder: (context, state) {
                // Reset isLoadingMore when new data is loaded or an error occurs
                if (state.$1 != MarvelState.loading) {
                  isLoadingMore = false;
                }

                if (state.$1 == MarvelState.loading &&
                    (state.$2 == null || state.$2!.isEmpty)) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.$1 == MarvelState.loaded ||
                    (state.$1 == MarvelState.loading && !isLoadingMore)) {
                  final comics = state.$2 ?? [];
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: comics.length,
                    itemBuilder: (context, index) {
                      final comic = comics[index];
                      return ComicTile(comic: comic);
                    },
                  );
                } else {
                  // MarvelState.error
                  return Center(child: Text('Failed to load data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_example/widget_tools/search/search_detail_page.dart';

final List<String> wordList = [
  "Hello",
  "Good morning",
  "Good afternoon",
  "Good evening",
  "Good night",
  "Good bye",
  "Bye",
  "See you later",
];

final onSearchProvider = StateProvider((ref) => false);
final StateProvider<List<int>> searchIndexListProvider =
StateProvider((ref) => []);

class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onSearchNotifier = ref.watch(onSearchProvider.notifier);
    final onSearch = ref.watch(onSearchProvider);
    final searchIndexListNotifier = ref.watch(searchIndexListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
          title: onSearch
              ? _searchTextField(ref)
              : const Text("Search"),
          actions: onSearch
              ? [
            IconButton(
                onPressed: () {
                  onSearchNotifier.state = false;
                },
                icon: const Icon(Icons.clear)),
          ]
              : [
            IconButton(
                onPressed: () {
                  onSearchNotifier.state = true;
                  searchIndexListNotifier.state = [];
                },
                icon: const Icon(Icons.search)),
          ]),
      body: onSearch ? _searchListView(ref) : _defaultListView(),
    );
  }

  Widget _searchTextField(WidgetRef ref) {
    final searchIndexListNotifier = ref.watch(searchIndexListProvider.notifier);
    final List<int> searchIndexList = ref.watch(searchIndexListProvider);
    return TextField(
      autofocus: true,
      onChanged: (String text) {
        searchIndexListNotifier.state = [];
        for (int i = 0; i < wordList.length; i++) {
          if (wordList[i].contains(text)) {
            searchIndexListNotifier.state.add(i); // 今回の問題はここ！！！
          }
        }
      },
    );
  }

  Widget _searchListView(WidgetRef ref) {
    final searchIndexListNotifier = ref.watch(searchIndexListProvider.notifier);
    final searchIndexList = ref.watch(searchIndexListProvider);
    return ListView.builder(
        itemCount: searchIndexList.length,
        itemBuilder: (context, int index) {
          index = searchIndexListNotifier.state[index];
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchDetailPage(title: wordList[index])));
              },
              title: Text(wordList[index]),
            ),
          );
        });
  }

  Widget _defaultListView() {
    return ListView.builder(
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchDetailPage(title: wordList[index])));
            },
            title: Text(wordList[index]),
          ),
        );
      },
    );
  }
}

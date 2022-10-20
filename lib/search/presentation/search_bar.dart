import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:repo_viewer/search/shared/providers.dart';

class SearchBar extends ConsumerStatefulWidget {
  final String title;
  final String hint;
  final Widget body;
  final void Function(String searchTerm) onShouldNavigateToResultPage;
  final void Function() onSignOutButtonPressed;

  SearchBar(
      {required this.title,
      required this.onSignOutButtonPressed,
      required this.hint,
      required this.body,
      required this.onShouldNavigateToResultPage});

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  late FloatingSearchBarController _controller;
  @override
  void dispose() {
    // _controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = FloatingSearchBarController();
    Future.microtask(
      () =>
          ref.read(searchHistoryNotifierProvider.notifier).watchedSearchTerm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    void pushPageAndPutFirstInHistory(query) {
      widget.onShouldNavigateToResultPage(query);
      ref.read(searchHistoryNotifierProvider.notifier).putSearchTerm(query);
      _controller.close();
    }

    void pushPageAndAddToHistory(query) {
      widget.onShouldNavigateToResultPage(query);
      ref.read(searchHistoryNotifierProvider.notifier).addSearchTerm(query);
      _controller.close();
    }

    return FloatingSearchBar(
      controller: _controller,
      automaticallyImplyBackButton: false,
      leadingActions: [
        if (context.router.canPop() && (Platform.isIOS || Platform.isMacOS))
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            splashRadius: 18,
            onPressed: () {
              context.router.pop();
            },
          )
        else if (context.router.canPop())
          IconButton(
              onPressed: () {
                context.router.pop();
              },
              splashRadius: 18,
              icon: Icon(
                Icons.arrow_back,
              ))
      ],
      body: FloatingSearchBarScrollNotifier(child: widget.body),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          Text('Tap to search 👆🏽',
              style: Theme.of(context).textTheme.caption),
        ],
      ),
      hint: widget.hint,
      onQueryChanged: (query) {
        ref
            .read(searchHistoryNotifierProvider.notifier)
            .watchedSearchTerm(filter: query);
      },
      onSubmitted: (query) {
        pushPageAndAddToHistory(query);
      },
      actions: [
        FloatingSearchBarAction.searchToClear(showIfClosed: false),
        FloatingSearchBarAction(
          child: IconButton(
            icon: Icon(MdiIcons.logoutVariant),
            splashRadius: 18,
            onPressed: () {
              widget.onSignOutButtonPressed();
            },
          ),
        ),
      ],
      builder: (context, transition) {
        final searchHistoryState = ref.watch(searchHistoryNotifierProvider);

        return searchHistoryState.map(
          data: (history) {
            return Material(
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.hardEdge,
              color: Theme.of(context).cardColor,
              elevation: 4,
              child: _controller.query.isEmpty && history.value.isEmpty
                  ? Container(
                      height: 58,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    )
                  : history.value.isEmpty
                      ? ListTile(
                          title: Text(_controller.query),
                          leading: const Icon(Icons.search),
                          onTap: () {
                            pushPageAndAddToHistory(_controller.query);
                          },
                        )
                      : Column(
                          children: history.value
                              .map((term) => ListTile(
                                    leading: Icon(Icons.history),
                                    trailing: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        ref
                                            .read(searchHistoryNotifierProvider
                                                .notifier)
                                            .deleteSearchTerm(term);
                                      },
                                    ),
                                    title: Text(
                                      term,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      pushPageAndPutFirstInHistory(term);
                                    },
                                  ))
                              .toList(),
                        ),
            );
          },
          error: (history) {
            return ListTile(
              title: Text('Very unexpected error ${history.error}'),
            );
          },
          loading: (history) {
            return const ListTile(
              title: LinearProgressIndicator(),
            );
          },
        );
      },
    );
  }
}

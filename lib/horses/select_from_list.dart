import 'package:flutter/material.dart';
import 'package:horse_app/horses/create.dart';
import 'package:horse_app/horses/list_item.dart';
import 'package:horse_app/state/db.dart';
import 'package:horse_app/utils/app_bar_search.dart';
import 'package:horse_app/utils/empty_list_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SelectFromList extends StatefulWidget {
  final DateTime? before;
  final List<Sex>? sex;
  final bool canCreate;

  const SelectFromList(
      {Key? key, this.before, this.sex, required this.canCreate})
      : super(key: key);

  @override
  State<SelectFromList> createState() => _SelectFromListState();
}

class _SelectFromListState extends State<SelectFromList> {
  static String title = 'Select Horse';

  // handles the search bar at the top
  Widget searchBarOrTitle = Text(title);
  Icon searchIconOrCancel = const Icon(Icons.search);

  // state for infinite loading of the entries
  static const _pageSize = 10;
  String filter = '';

  final PagingController<int, Horse> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  _onTap(BuildContext context, int idx, Horse horse) {
    Navigator.pop(context, horse);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // fetch the horses
      var horses = await db.listHorses(
        filter: filter,
        offset: pageKey,
        limit: _pageSize,
        before: widget.before,
        sex: widget.sex,
      );

      final isLastPage = horses.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(horses);
      } else {
        final nextPageKey = pageKey + horses.length;
        _pagingController.appendPage(horses, nextPageKey);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBarOrTitle,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (searchIconOrCancel.icon == Icons.search) {
                  searchIconOrCancel = const Icon(Icons.cancel);
                  searchBarOrTitle = AppBarSearch(
                    onChanged: (v) {
                      filter = v;
                      _pagingController.refresh();
                    },
                  );
                } else {
                  searchIconOrCancel = const Icon(Icons.search);
                  searchBarOrTitle = Text(title);
                  if (filter != "") {
                    filter = '';
                    _pagingController.refresh();
                  }
                }
              });
            },
            icon: searchIconOrCancel,
          )
        ],
      ),
      body: Center(
        child: PagedListView<int, Horse>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Horse>(
              itemBuilder: (context, item, index) => HorseListItem(
                    horse: item,
                    onTap: (h) {
                      _onTap(context, index, h);
                    },
                  ),
              noItemsFoundIndicatorBuilder: (context) =>
                  const EmptyListTemplate(
                    title: "No Horses Found!",
                    child: Text(
                      'Make sure the horse you wish to select exists and has the correct age and sex',
                      textAlign: TextAlign.center,
                    ),
                  )),
        ),
      ),
      floatingActionButton: widget.canCreate
          ? FloatingActionButton(
              onPressed: () async {
                final horse = await Navigator.push<Horse?>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateHorsePage()));

                if (horse != null) Navigator.pop(context, horse);
              },
              tooltip: 'Add Horse',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:horse_app/horses/create.dart';
import 'package:horse_app/horses/list_item.dart';
import 'package:horse_app/horses/single.dart';
import 'package:horse_app/utils/app_bar_search.dart';
import 'package:horse_app/utils/empty_list_widget.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../utils/utils.dart';
import "../state/db.dart";

class HorsesPage extends StatefulWidget {
  const HorsesPage({Key? key}) : super(key: key);

  @override
  State<HorsesPage> createState() => _HorsesPageState();
}

class _HorsesPageState extends State<HorsesPage> {
  static String title = 'Horses';

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

  Future<void> _onDelete(String id) async {
    setState(() {
      _pagingController.itemList!
          .removeWhere((item) => item.id == id);
      _pagingController.itemList = _pagingController.itemList;
    });
  }

  Future<void> _onTap(BuildContext context, int idx, Horse horse) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HorseProfilePage(horse: horse);
    }));
    try {
      horse = await db.getHorse(horse.id);
      setState(() {
        _pagingController.itemList![idx] = horse;
      });
    } catch (e) {
      if (e is StateError && e.message == 'No element') {
        _onDelete(horse.id);
      } else {
        showError(context, "Something went wrong when reloading horse...");
      }
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // fetch the horses
      var horses = await db.listHorses(
          filter: filter, offset: pageKey, limit: _pageSize);

      final isLastPage = horses.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(horses);
      } else {
        final nextPageKey = pageKey + horses.length;
        _pagingController.appendPage(horses, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  _onAppBarSearchChanged(String value) {
    setState(() {
      filter = value;
      _pagingController.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarAnimator(child: searchBarOrTitle),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (searchIconOrCancel.icon == Icons.search) {
                  searchIconOrCancel = const Icon(Icons.cancel);
                  searchBarOrTitle =
                      AppBarSearch(onChanged: _onAppBarSearchChanged);
                } else {
                  searchIconOrCancel = const Icon(Icons.search);
                  searchBarOrTitle = Text(title);
                  if (filter != '') {
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

      drawer: appDrawer(context, "/horses"),

      body: Center(
        child: PagedListView<int, Horse>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Horse>(
            itemBuilder: (context, horse, index) => HorseListItem(
              horse: horse,
              onTap: (h) => _onTap(context, index, h),
            ),
            noItemsFoundIndicatorBuilder: (context) => const EmptyListTemplate(
                title: "No Horses Found!",
                child: Text("Add new horses with the button below")),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateHorsePage()));
          // refresh the page
          _pagingController.refresh();
        },
        tooltip: 'Add Horse',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

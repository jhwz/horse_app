import 'package:flutter/material.dart';
import 'package:horse_app/horses/single.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../_utils.dart';
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

  Future<void> _onDelete(String registrationName) async {
    setState(() {
      _pagingController.itemList!
          .removeWhere((item) => item.registrationName == registrationName);
      _pagingController.itemList = _pagingController.itemList;
    });
  }

  Future<void> _onTap(BuildContext context, int idx, Horse horse) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HorseProfilePage(horse: horse);
    }));
    try {
      horse = await DB.getHorse(horse.registrationName);
      setState(() {
        _pagingController.itemList![idx] = horse;
      });
    } catch (e) {
      showError(context, "Something went wrong when reloading horse...");
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // fetch the horses
      var horses = await DB.listHorses(
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
                  searchBarOrTitle = ListTile(
                    title: TextField(
                      onChanged: (v) {
                        filter = v;
                        _pagingController.refresh();
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Filter...',
                        border: InputBorder.none,
                        fillColor: Theme.of(context).primaryColorLight,
                        filled: true,
                      ),
                    ),
                  );
                } else {
                  searchIconOrCancel = const Icon(Icons.search);
                  searchBarOrTitle = Text(title);
                  filter = '';
                  _pagingController.refresh();
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
            itemBuilder: (context, item, index) => HorseListItem(
              horse: item,
              onDelete: _onDelete,
              onTap: (h) {
                _onTap(context, index, h);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HorseProfilePage()));
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

class HorseListItem extends StatelessWidget {
  final Horse horse;
  final Function(String) onDelete;
  final Function(Horse) onTap;

  const HorseListItem(
      {Key? key,
      required this.horse,
      required this.onDelete,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.only(left: 8, right: 16, top: 0, bottom: 0),
      minVerticalPadding: 0,
      leading: horse.photo != null ? Image.memory(horse.photo!) : null,
      title: Text(horse.name),
      subtitle: Text(
          '${horse.registrationName} - ${DateTime.now().difference(horse.dateOfBirth).inDays ~/ 365} years old'),
      isThreeLine: true,
      onTap: () {
        onTap(horse);
      },
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (String value) async {
          if (value == 'Delete') {
            try {
              await DB.deleteHorse(horse.registrationName);
              onDelete(horse.registrationName);
              showSuccess(context, 'Deleted');
            } catch (e) {
              showError(context, 'Deleting failed: ${e.toString()}');
            }
          }
        },
        itemBuilder: (BuildContext context) {
          return {'Delete'}.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    );
  }
}

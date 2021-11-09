import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:horse_app/events/create.dart';
import 'package:horse_app/events/single.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../_utils.dart';
import "../state/db.dart";

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static String title = 'Events';

  // handles the search bar at the top
  Widget searchBarOrTitle = Text(title);
  Icon searchIconOrCancel = const Icon(Icons.search);

  // state for infinite loading of the entries
  static const _pageSize = 20;
  String filter = '';

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int _) async {
    try {
      int pageKey = _pagingController.itemList?.fold(
              0,
              (value, e) =>
                  e is List<Event> ? value! + e.length : value! + 1) ??
          0;

      // fetch the horses
      var events = await DB.listPastEvents(
          filter: filter, offset: pageKey, limit: _pageSize);

      if (events.isEmpty) {
        _pagingController.appendLastPage([]);
        return;
      }

      // collapse similar events
      List<dynamic> out = [];
      List<EventHorse> curr = [];
      for (int i = 0; i < events.length; i++) {
        if (curr.isEmpty) {
          curr.add(events[i]);
          continue;
        }

        if (curr.last.type == events[i].type &&
            curr.last.date.difference(events[i].date).abs().inHours < 8) {
          curr.add(events[i]);
        } else {
          if (curr.length > 1) {
            out.add(curr);
          } else {
            out.add(curr.first);
          }
          curr = [events[i]];
        }
      }
      var isLastPage = events.length < _pageSize;

      if (curr.isNotEmpty) {
        // keep looping through the database until we fill up the final list. Normally
        // this will fetch an additional page and discard most of it so it is a little
        // wasteful but hopefully not noticable!
        while_loop:
        while (!isLastPage) {
          pageKey += _pageSize;
          var eventsNext = await DB.listPastEvents(
              filter: filter, offset: pageKey, limit: _pageSize);
          isLastPage = eventsNext.length < _pageSize;
          for (int i = 0; i < eventsNext.length; i++) {
            if (curr.last.type == eventsNext[i].type &&
                curr.last.date.difference(eventsNext[i].date).abs().inHours <
                    8) {
              curr.add(eventsNext[i]);
            } else {
              break while_loop;
            }
          }
        }
        if (curr.length > 1) {
          out.add(curr);
        } else {
          out.add(curr.first);
        }
      }

      if (isLastPage) {
        _pagingController.appendLastPage(out);
      } else {
        final nextPageKey = pageKey + out.length;
        _pagingController.appendPage(out, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _onTap(Event e) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EventSummaryPage(event: e);
    }));
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

      drawer: appDrawer(context, "/logs"),

      body: Center(
        child: PagedListView<int, dynamic>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            itemBuilder: (context, item, index) {
              if (item is List<EventHorse>) {
                return EventListGroup(events: item, onTap: _onTap);
              }
              return EventListItem(event: item, onTap: _onTap);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NewEventPage();
          }));
          _pagingController.refresh();
        },
        tooltip: 'Create Event',
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

class EventListItem extends StatelessWidget {
  final EventHorse event;
  final Function(Event) onTap;

  const EventListItem({Key? key, required this.event, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        formatStr(event.type),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(event.horse.name), Text(event.date.date())]),
      isThreeLine: true,
      onTap: () {
        onTap(event);
      },
    );
  }
}

class EventListGroup extends StatelessWidget {
  final Function(Event) onTap;
  final List<EventHorse> events;

  const EventListGroup({Key? key, required this.events, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: ListTile(
        title: Text(
          formatStr(events[0].type),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${events.length} horses'),
        ]),
        isThreeLine: true,
      ),
      collapsed: const SizedBox.shrink(),
      expanded: Column(
        children:
            events.map((e) => EventListItem(event: e, onTap: onTap)).toList(),
      ),
    );
  }
}

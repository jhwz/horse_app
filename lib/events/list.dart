import 'package:flutter/material.dart';
import 'package:horse_app/events/create.dart';
import 'package:horse_app/events/list_item.dart';
import 'package:horse_app/events/single.dart';
import 'package:horse_app/notifications.dart';
import 'package:horse_app/utils/app_bar_search.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/utils.dart';
import "../state/db.dart";

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static String title = "Events";
  // handles the search bar at the top
  Widget searchBarOrTitle = Text(title);
  Icon searchIconOrCancel = const Icon(Icons.search);

  DateTime _focusedDay = DateTime.now();

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

      final endOfFocusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month,
        _focusedDay.day,
        23,
        59,
        59,
        999,
      );

      // fetch the horses
      var events = await db.listEvents(
        filter: filter,
        offset: pageKey,
        limit: _pageSize,
        now: endOfFocusedDay,
      );

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
          var eventsNext = await db.listEvents(
            filter: filter,
            offset: pageKey,
            limit: _pageSize,
            now: endOfFocusedDay,
          );
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

  Future<void> _onTap(EventHorse e) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EventSummaryPage(event: e);
    }));
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
                  searchBarOrTitle = AppBarSearch(
                    onChanged: (v) {
                      filter = v;
                      _pagingController.refresh();
                    },
                  );
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
      drawer: appDrawer(context, "/logs"),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                ),
                child: TableCalendar(
                  shouldFillViewport: false,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.week,
                  selectedDayPredicate: (day) {
                    return isSameDay(_focusedDay, day);
                  },
                  onDaySelected: (_, focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _pagingController.refresh();
                    });
                  },
                  calendarStyle: CalendarStyle(
                    // isTodayHighlighted: false,
                    todayDecoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    headerTitleBuilder: (context, day) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              day.monthYear(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _focusedDay = DateTime.now();
                                    _pagingController.refresh();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  primary:
                                      Theme.of(context).colorScheme.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text("today",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    )))
                          ]);
                    },
                  ),
                  daysOfWeekVisible: false,
                  availableCalendarFormats: const {
                    CalendarFormat.week: '',
                  },
                ),
              ),
            ]),
          ),
          PagedSliverList<int, dynamic>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              itemBuilder: (context, item, index) {
                if (item is List<EventHorse>) {
                  return EventListGroup(events: item, onTap: _onTap);
                }
                return TopEventListItem(event: item, onTap: _onTap);
              },
            ),
          ),
        ],
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
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       title: Text('Home'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.list),
      //       title: Text('Events'),
      //     ),
      //   ],
      //   currentIndex: 1,
      //   onTap: (index) {
      //     if (index == 0) {
      //       Navigator.pushReplacementNamed(context, "/");
      //     } else if (index == 2) {
      //       Navigator.pushReplacementNamed(context, "/calendar");
      //     }
      //   },
      // ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

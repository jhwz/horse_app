import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:horse_app/utils/empty_list_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:image_picker/image_picker.dart';

class Photo {
  int id;
  Uint8List photo;

  Photo({required this.id, required this.photo});
}

class Gallery extends StatefulWidget {
  final Future<List<Photo>> Function(int offset, int limit) fetch;
  final Future<Photo> Function(Uint8List data) onAdd;
  final Function(int id) onDelete;
  final Function(int id)? onPrimaryChange;
  final int? primary;

  const Gallery(
      {Key? key,
      required this.fetch,
      required this.onAdd,
      required this.onDelete,
      this.primary,
      this.onPrimaryChange})
      : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  // state for infinite loading of the entries
  static const _pageSize = 10;
  int? _currPrimary;
  Offset _lastTapPosition = Offset.zero;

  final PagingController<int, Photo> _pagingController =
      PagingController(firstPageKey: 0);

  final ValueNotifier<bool> _isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    _currPrimary = widget.primary;
    super.initState();
  }

  _fetchPage(int pageKey) async {
    try {
      var photos = await widget.fetch(pageKey, _pageSize);
      final isLastPage = photos.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(photos);
      } else {
        final nextPageKey = pageKey + photos.length;
        _pagingController.appendPage(photos, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  _tryAdd(XFile? image) async {
    if (image != null) {
      final next = await widget.onAdd(await image.readAsBytes());
      setState(() {
        final list = _pagingController.itemList ?? [];
        list.add(next);
        _pagingController.itemList = list;
        if (widget.onPrimaryChange != null && _currPrimary == null) {
          widget.onPrimaryChange!(next.id);
          _currPrimary = next.id;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 20.0),
        child: PagedGridView<int, Photo>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Photo>(
            itemBuilder: (context, data, index) {
              Widget child = Image.memory(
                data.photo,
                fit: BoxFit.fill,
              );
              if (data.id == _currPrimary) {
                child = Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4.0,
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: child,
                    ),
                    Positioned(
                      child: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      right: 5.0,
                      top: 5.0,
                    ),
                  ],
                );
              }

              return GestureDetector(
                child: child,
                onLongPress: () {
                  final overlay = context.findRenderObject();
                  var size = const Size(500, 100);
                  if (overlay is RenderSliver) {
                    size = overlay.getAbsoluteSize();
                  }
                  showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                      _lastTapPosition & const Size(40, 40),
                      Offset.zero & size,
                    ),
                    items: [
                      if (widget.onPrimaryChange != null)
                        PopupMenuItem(
                          enabled: data.id != _currPrimary,
                          child: Row(children: const [
                            Icon(Icons.check),
                            SizedBox(width: 8.0),
                            Text("Set as primary"),
                          ]),
                          onTap: () {
                            widget.onPrimaryChange?.call(data.id);
                            setState(() {
                              _currPrimary = data.id;
                            });
                          },
                        ),
                      PopupMenuItem(
                        enabled: data.id != _currPrimary,
                        child: Row(children: const [
                          Icon(Icons.delete),
                          SizedBox(width: 8.0),
                          Text("Delete"),
                        ]),
                        onTap: () async {
                          await widget.onDelete(data.id);
                          setState(() {
                            _pagingController.itemList!
                                .removeWhere((item) => item.id == data.id);
                            _pagingController.itemList =
                                _pagingController.itemList;
                          });
                        },
                      ),
                    ],
                  );
                },
                onLongPressDown: (details) {
                  _lastTapPosition = details.globalPosition;
                },
              );
            },
            noItemsFoundIndicatorBuilder: (context) => const EmptyListTemplate(
                title: "No Images Found!",
                child: Text("Add new images to your gallery below")),
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        openCloseDial: _isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        // iconTheme: IconThemeData(size: 22),

        // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: [
          SpeedDialChild(
            label: "Camera",
            child: const Icon(Icons.camera_alt),
            onTap: () async {
              final image =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              await _tryAdd(image);
            },
          ),
          SpeedDialChild(
            label: "Gallery",
            child: const Icon(Icons.image),
            onTap: () async {
              final image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              await _tryAdd(image);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

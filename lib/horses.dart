import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import './reactive_image_picker2.dart';

import './_utils.dart';
import "./models/horse.dart";
import "./db.dart";

class HorsesPage extends StatefulWidget {
  const HorsesPage({Key? key}) : super(key: key);

  @override
  State<HorsesPage> createState() => _HorsesPageState();
}

class _HorsesPageState extends State<HorsesPage> {
  static String title = '$appTitle - Horses';

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

  Future<void> _onTap(int idx, Horse horse) async {
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
          filter: filter,
          page: (pageKey ~/ _pageSize) + 1,
          pageSize: _pageSize);

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
                _onTap(index, h);
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
              await DB.deleteHorse(horse);
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

// Widget for adding a new horse
class HorseProfilePage extends StatefulWidget {
  final Horse? horse;

  const HorseProfilePage({Key? key, this.horse}) : super(key: key);

  @override
  State<HorseProfilePage> createState() => _HorseProfilePageState();
}

class _HorseProfilePageState extends State<HorseProfilePage> {
  static const String __validHands = 'validHands';
  static Map<String, dynamic>? _validHands(AbstractControl<dynamic> control) {
    try {
      String hands = control.value is String ? control.value : '';
      if (!hands.contains(".")) {
        return {__validHands: true};
      }
      var parts = hands.split(".");
      if (parts.length != 2) {
        return {__validHands: true};
      }
      var val = int.parse(parts[0]);
      if (val < 0 || val > 30) {
        return {__validHands: true};
      }
      val = int.parse(parts[1]);
      if (val < 0 || val > 3) {
        return {__validHands: true};
      }
    } catch (e) {
      return {__validHands: true};
    }
    return null;
  }

  late final FormGroup form;

  @override
  initState() {
    super.initState();
    var horse = widget.horse;

    form = FormGroup({
      HorsesTable.photo: FormControl<Uint8List>(value: horse?.photo),
      HorsesTable.registrationName: FormControl<String>(
          validators: [Validators.required], value: horse?.registrationName),
      HorsesTable.registrationNumber:
          FormControl<String>(value: horse?.registrationNumber),
      HorsesTable.name: FormControl<String>(
          validators: [Validators.required], value: horse?.name),
      HorsesTable.dateOfBirth: FormControl<DateTime>(
          validators: [Validators.required], value: horse?.dateOfBirth),
      HorsesTable.sex: FormControl<Sex>(value: horse?.sex ?? Sex.female),
      HorsesTable.height: FormControl<String>(
          validators: [_validHands], value: horse?.height.toString()),
    });
  }

  @override
  Widget build(BuildContext context) {
    var horse = widget.horse;
    String title = horse == null ? 'New Horse' : '${horse.name} Profile';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 24.0),
          child: ReactiveForm(
            formGroup: form,
            child: CreateHorseSubmitButton(
              formGroup: form,
              update: horse != null,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ReactiveImagePicker(
                  formControlName: HorsesTable.photo,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Image',
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      helperText: ''),
                  inputBuilder: (onPressed) => TextButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.add),
                    label: const Text('Add an image'),
                  ),
                ),
                ReactiveTextField(
                  readOnly: horse != null,
                  formControlName: HorsesTable.registrationName,
                  decoration: const InputDecoration(
                    labelText: 'Registration Name',
                  ),
                ),
                ReactiveTextField(
                  formControlName: HorsesTable.registrationNumber,
                  decoration: const InputDecoration(
                    labelText: 'Registration Number',
                  ),
                ),
                ReactiveTextField(
                  formControlName: HorsesTable.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    helperText: 'Alias to display the horse as',
                  ),
                ),
                ReactiveDateTimePicker(
                  formControlName: HorsesTable.dateOfBirth,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    helperText: '',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                ReactiveDropdownField(
                  formControlName: HorsesTable.sex,
                  items: const [
                    DropdownMenuItem(value: Sex.female, child: Text('Female')),
                    DropdownMenuItem(value: Sex.male, child: Text('Male')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Sex',
                    helperText: '',
                  ),
                ),
                ReactiveTextField(
                  formControlName: HorsesTable.height,
                  decoration: const InputDecoration(
                      labelText: 'Height',
                      helperText: 'Height in hands (hh)',
                      suffixText: 'hh'),
                  validationMessages: (c) =>
                      {__validHands: "invalid hands format; try '15.3'"},
                )
              ]
                  .map((w) =>
                      Padding(padding: const EdgeInsets.only(top: 8), child: w))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateHorseSubmitButton extends StatelessWidget {
  final FormGroup formGroup;
  final bool update;
  const CreateHorseSubmitButton({
    Key? key,
    required this.formGroup,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context);
    return ElevatedButton(
      onPressed: form != null && form.valid
          ? () async {
              try {
                if (update) {
                  await DB.updateHorse(Horse.fromMap(formGroup.value));
                } else {
                  await DB.createHorse(Horse.fromMap(formGroup.value));
                }
                showSuccess(
                    context, 'Sucessfully ${update ? 'updated' : 'created'}!');
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              } catch (e) {
                showError(context,
                    'Failed to ${update ? 'save changes' : 'create'} horse: ${e.toString()}');
              }
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(update ? 'Save Changes' : 'Create Horse'),
      ),
    );
  }
}

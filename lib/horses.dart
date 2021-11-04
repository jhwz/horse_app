import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:horse_app/logs.dart';
import 'package:path/path.dart';

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

  Horse? horse;

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
    horse = widget.horse;

    form = FormGroup({
      HorsesTable.photo: FormControl<Uint8List>(value: horse?.photo),
      HorsesTable.registrationName: FormControl<String>(
          validators: [Validators.required], value: horse?.registrationName),
      HorsesTable.registrationNumber:
          FormControl<String>(value: horse?.registrationNumber),
      HorsesTable.sireRegistrationName:
          FormControl<String>(value: horse?.sireRegistrationName),
      HorsesTable.damRegistrationName:
          FormControl<String>(value: horse?.damRegistrationName),
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
    String title = horse == null ? 'New Horse' : '${horse!.name} Profile';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      bottomNavigationBar: ReactiveForm(
        formGroup: form,
        child: CreateHorseSubmitButton(
          formGroup: form,
          update: horse != null,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget?>[
                ReactiveImagePicker(
                  formControlName: HorsesTable.photo,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      helperText: ''),
                  inputBuilder: (onPressed) => TextButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.add),
                    label: const Text('Set profile photo'),
                  ),
                ),
                horse == null || horse!.sex != Sex.female
                    ? null
                    : ListTile(
                        trailing:
                            const Icon(Icons.keyboard_arrow_right_outlined),
                        subtitle: const Text('View heat cycle overview'),
                        title: horse!.heat == null
                            ? const Text('No dates set yet!')
                            : horse!.isInHeat()
                                ? const Text('In Heat')
                                : const Text('Not in Heat'),
                        onTap: () async {
                          var next = await Navigator.push<Horse>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HorseHeatPage(horse: horse!)));

                          setState(() {
                            horse!.heat = next?.heat;
                          });
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                Row(
                  children: <Widget>[
                    Text(
                      "Details",
                      style: Theme.of(context).textTheme.overline,
                    ),
                    const Expanded(
                        child: Divider(
                      indent: 10,
                    )),
                  ],
                ),
                ReactiveTextField(
                  readOnly: horse != null,
                  formControlName: HorsesTable.registrationName,
                  decoration: const InputDecoration(
                    labelText: 'Registration Name',
                  ),
                ),
                ReactiveTextField(
                  formControlName: HorsesTable.sireRegistrationName,
                  decoration: const InputDecoration(
                    labelText: 'Registration Number',
                  ),
                ),
                ReactiveTextField(
                  formControlName: HorsesTable.damRegistrationName,
                  decoration: const InputDecoration(
                    labelText: 'Sire Registration Number',
                  ),
                ),
                ReactiveTextField(
                  formControlName: HorsesTable.registrationNumber,
                  decoration: const InputDecoration(
                    labelText: 'Dam Registration Number',
                  ),
                ),
                ReactiveTextField(
                  formControlName: HorsesTable.name,
                  decoration: const InputDecoration(
                    labelText: 'Paddock Name',
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: ReactiveTextField(
                    formControlName: HorsesTable.height,
                    decoration: const InputDecoration(
                        labelText: 'Height',
                        helperText: 'Height in hands (hh)',
                        suffixText: 'hh'),
                    validationMessages: (c) =>
                        {__validHands: "Invalid hands format; try '15.3'"},
                  ),
                ),
              ]
                  .where((e) => e != null)
                  .toList()
                  .map<Widget>((w) => Padding(
                      padding: const EdgeInsets.only(top: 12), child: w))
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
    if (form == null) {
      return const SizedBox();
    }
    if (form.pristine) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 24.0),
      child: ElevatedButton(
        onPressed: form.valid
            ? () async {
                try {
                  if (update) {
                    await DB.updateHorse(Horse.fromMap(formGroup.value));
                  } else {
                    await DB.createHorse(Horse.fromMap(formGroup.value));
                  }
                  showSuccess(context,
                      'Sucessfully ${update ? 'updated' : 'created'}!');
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
      ),
    );
  }
}

// Widget for adding a new horse
class HorseHeatPage extends StatefulWidget {
  final Horse horse;

  const HorseHeatPage({Key? key, required this.horse}) : super(key: key);

  @override
  State<HorseHeatPage> createState() => _HorseHeatPage();
}

class _HorseHeatPage extends State<HorseHeatPage> {
  late final FormGroup form;

  String? updateErr;

  @override
  initState() {
    super.initState();
    var horse = widget.horse;

    form = FormGroup({
      HorsesTable.heat: FormControl<DateTime>(value: horse.nextHeatStart()),
    });

    form.valueChanges.listen((event) async {
      if (event == null) {
        return;
      }
      var raw = event[HorsesTable.heat];
      horse.heat = raw is DateTime ? raw : null;
      try {
        await DB.updateHorse(horse);
      } catch (e) {
        setState(() {
          updateErr = 'Failed to update: ${e.toString()}';
        });
      }
      setState(() {
        horse = horse;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final horse = widget.horse;

    final inHeat = horse.isInHeat();

    List<Widget> children = [];
    if (inHeat) {
      children = [
        (Container(
          margin: const EdgeInsets.only(top: 12, bottom: 16),
          child: Text(
            'In heat',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(const TextStyle(color: Colors.white)),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        )),
        (Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                    child: Text("End of current cycle:",
                        style: Theme.of(context).textTheme.caption)),
                Text(
                    "${DateTime.now().difference(horse.currentHeatEnd()!).abs().inDays} Days from now",
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ))),
      ];
    } else if (horse.heat != null) {
      children = [
        (Container(
          margin: const EdgeInsets.only(top: 12, bottom: 16),
          child: Text(
            'Not in heat',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(const TextStyle(color: Colors.white60)),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        )),
      ];
    }
    if (horse.heat != null) {
      final nextHeat = DateTime.now().difference(horse.nextHeatStart()!).abs();
      children.add((Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                  child: Text("Next Heat Start:",
                      style: Theme.of(context).textTheme.caption)),
              Text("${nextHeat.inDays} days from now",
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ))));
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, horse);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${horse.name} Heat Cycle'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ReactiveForm(
            formGroup: form,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ReactiveDateTimePicker(
                  formControlName: HorsesTable.heat,
                  firstDate: DateTime.now().subtract(const Duration(days: 337)),
                  decoration: InputDecoration(
                    labelText: 'Start of heat period',
                    errorText: updateErr,
                    errorMaxLines: 5,
                    helperMaxLines: 99,
                    helperText: horse.heat == null && updateErr == null
                        ? 'No heat cycle set yet! Set this date to any time your mare has been or will be in heat and we will handle everything else. When a pregnancy event occurs for the mare, their cycle will automatically be updated.'
                        : null,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              ...children,
            ]),
          ),
        ),
      ),
    );
  }
}

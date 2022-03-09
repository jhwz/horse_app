import 'package:flutter/material.dart';
import 'package:horse_app/horses/create.dart';
import 'package:horse_app/horses/list_item.dart';
import 'package:horse_app/horses/single.dart';
import 'package:horse_app/utils/app_bar_search.dart';
import 'package:horse_app/utils/empty_list_widget.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../utils/utils.dart';
import "../state/db.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static String title = 'Profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: appDrawer(context, "/profile"),
      body: Center(
        child: Text(db.uuid),
      ),
    );
  }
}

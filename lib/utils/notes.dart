import 'package:flutter/material.dart';

class EditNotePage extends StatefulWidget {
  final String note;

  const EditNotePage({Key? key, required this.note}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  FocusNode contentFocus = FocusNode();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contentController.text = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Notes"),
        leading: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            Navigator.pop(context, contentController.text);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: contentFocus,
                  controller: contentController,
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Start typing...',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

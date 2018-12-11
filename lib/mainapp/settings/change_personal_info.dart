import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xmux/globals.dart';

class ChangePersonalInfoPage extends StatefulWidget {
  @override
  _ChangePersonalInfoPageState createState() => _ChangePersonalInfoPageState();
}

class _ChangePersonalInfoPageState extends State<ChangePersonalInfoPage> {
  final _displayNameController =
      TextEditingController(text: firebaseUser?.displayName ?? 'User');

  final _formKey = GlobalKey<FormState>();

  void _handleSubmit() async {
    if (!_formKey.currentState.validate()) return;
    firebaseUser.updateProfile(
        UserUpdateInfo()..displayName = _displayNameController.text);
    firebaseUser.reload();
    firebaseUser = await FirebaseAuth.instance.currentUser();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n('Settings/ChangeProfile', context)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _handleSubmit,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Text(
              i18n('Settings/ChangeProfile/Caption', context),
              style: Theme.of(context).textTheme.caption,
            ),
            TextFormField(
              controller: _displayNameController,
              decoration: InputDecoration(
                  labelText:
                      i18n('Settings/ChangeProfile/DisplayName', context)),
              validator: (name) => name.isNotEmpty ? null : 'Format error',
            ),
          ],
        ),
      ),
    );
  }
}

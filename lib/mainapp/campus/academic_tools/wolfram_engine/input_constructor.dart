import 'package:flutter/material.dart';
import 'package:xmux/globals.dart';

import 'result.dart';

class InputConstructor extends StatefulWidget {
  @override
  _InputConstructorState createState() => _InputConstructorState();
}

class _InputConstructorState extends State<InputConstructor> {
  final TextEditingController _inputTextController = TextEditingController();

  Widget _getInputButton(String inputButton) => IconButton(
      icon: Text(
        inputButton,
        style: TextStyle(fontSize: 25),
      ),
      onPressed: () {
        if (_inputTextController.text.isNotEmpty) {
          var baseOffset = _inputTextController.selection.baseOffset;
          _inputTextController.text = _inputTextController.text
                  .substring(0, _inputTextController.selection.baseOffset) +
              inputButton +
              _inputTextController.text.substring(
                  _inputTextController.selection.baseOffset,
                  _inputTextController.text.length);
          _inputTextController.selection =
              TextSelection.collapsed(offset: baseOffset + 1);
        } else {
          _inputTextController.text += inputButton;
          _inputTextController.selection = TextSelection.collapsed(offset: 1);
        }
      });

  String dropdownValue;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(i18n(
              'Campus/AcademicTools/WolframEngine/InputConstructor', context)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                    autofocus: true,
                    controller: _inputTextController,
                    decoration: InputDecoration(
                        hintText: i18n(
                            'Campus/AcademicTools/WolframEngine/InputConstructor/SearchAnything',
                            context)),
                  )),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_inputTextController.text.isNotEmpty)
                        Navigator.of(context).push(
                          MaterialPageRoute<Null>(
                            builder: (BuildContext context) =>
                                WolframResult(_inputTextController.text),
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(i18n(
                  'Campus/AcademicTools/WolframEngine/InputConstructor/CommonlyUsed',
                  context)),
              trailing: DropdownButton<String>(
                value: dropdownValue,
                hint: Text(i18n(
                    'Campus/AcademicTools/WolframEngine/InputConstructor/Choose',
                    context)),
                onChanged: (String command) => setState(() {
                  _inputTextController.text += command;
                  _inputTextController.selection = TextSelection.collapsed(
                      offset: _inputTextController.text.length);
                }),
                items: <String>[
                  'solve',
                  'upper triangular',
                  'row reduce',
                  'integral'
                ]
                    .map((String command) => DropdownMenuItem<String>(
                          value: command,
                          child: Text(command),
                        ))
                    .toList(),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 3,
              children: <Widget>[
                _getInputButton('+'),
                _getInputButton('-'),
                _getInputButton('*'),
                _getInputButton('/'),
                _getInputButton('['),
                _getInputButton(']'),
                _getInputButton('^'),
                _getInputButton('('),
                _getInputButton(')'),
                _getInputButton('{'),
                _getInputButton('}'),
                _getInputButton('='),
                _getInputButton('x'),
                _getInputButton('y'),
                _getInputButton(','),
                _getInputButton('%'),
                FlatButton(
                  child: Text(i18n(
                      'Campus/AcademicTools/WolframEngine/InputConstructor/ClearAll',
                      context)),
                  onPressed: () {
                    _inputTextController.clear();
                  },
                ),
              ],
            )
          ],
        ),
      );
}

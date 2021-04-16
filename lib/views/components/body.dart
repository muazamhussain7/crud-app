import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:crud_app/models/employee.dart';
import 'package:crud_app/controllers/db_helper.dart';
import 'employees_list.dart';

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {
  TextEditingController _controller = TextEditingController();
  int _curUserId;
  final _formKey = GlobalKey<FormState>();
  var _dbHelper = DBHelper();
  var _isUpdating = false;

  void _clearName() {
    _controller.text = '';
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_isUpdating) {
        Employee employee = Employee(_curUserId, _controller.text);
        _dbHelper.update(employee);
        setState(() {
          _isUpdating = false;
        });
      } else {
        Employee employee = Employee(null, _controller.text);
        _dbHelper.save(employee);
      }
      _clearName();
    }
  }

  void _changeState(int id, String name) {
    setState(() {
      _isUpdating = true;
      _curUserId = id;
    });
    _controller.text = name;
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => _controller.text = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _submitForm,
                  child: Text(_isUpdating ? 'UPDATE' : 'ADD'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearName();
                  },
                  child: Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _dbHelper = Provider.of<DBHelper>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildForm(),
        Consumer<DBHelper>(
          builder: (_, dbHelper, __) => EmployeesList(_changeState, _dbHelper),
        ),
      ],
    );
  }
}

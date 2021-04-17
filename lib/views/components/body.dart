import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:crud_app/models/employee.dart';
import 'package:crud_app/controllers/db_helper.dart';
import 'employees_list.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  int _curUserId;
  final _formKey = GlobalKey<FormState>();
  var _dbHelper = DBHelper();

  void _clearName() {
    _controller.text = '';
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_dbHelper.getIsUpdating) {
        Employee employee = Employee(_curUserId, _controller.text);
        _dbHelper.update(employee);
        _dbHelper.setIsUpdating(false);
      } else {
        Employee employee = Employee(null, _controller.text);
        _dbHelper.save(employee);
      }
      _clearName();
    }
  }

  void _changeState(int id, String name) {
    _dbHelper.setIsUpdating(true);
    _curUserId = id;
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
                  child: Consumer<DBHelper>(
                    builder: (_, dbHelper, __) {
                      return Text(dbHelper.getIsUpdating ? 'UPDATE' : 'ADD');
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _dbHelper.setIsUpdating(false);
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
          builder: (_, __, ___) => EmployeesList(_changeState, _dbHelper),
        ),
      ],
    );
  }
}

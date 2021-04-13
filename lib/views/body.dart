import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/employee.dart';
import '../controllers/db_helper.dart';

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {
  TextEditingController controller = TextEditingController();
  int curUserId;

  final formKey = GlobalKey<FormState>();
  var dbHelper;
  var isUpdating = false;

  void clearName() {
    controller.text = '';
  }

  void validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Employee e = Employee(curUserId, controller.text);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Employee e = Employee(null, controller.text);
        dbHelper.save(e);
      }
      clearName();
    }
  }

  Form form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => controller.text = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
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

  SingleChildScrollView dataTable(List<Employee> employees) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: employees
            .map(
              (employee) => DataRow(cells: [
                DataCell(
                  Text(employee.name),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = employee.id;
                    });
                    controller.text = employee.name;
                  },
                ),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    dbHelper.delete(employee.id);
                  },
                )),
              ]),
            )
            .toList(),
      ),
    );
  }

  Expanded list() {
    return Expanded(
      child: FutureBuilder<List<Employee>>(
        future: dbHelper.getEmployees(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length != 0) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Center(child: Text("No Data Found"));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Some Error Occurred'));
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dbHelper = Provider.of<DBHelper>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        form(),
        list(),
      ],
    );
  }
}

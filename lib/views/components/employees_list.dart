import 'package:flutter/material.dart';

import 'package:crud_app/models/employee.dart';

class EmployeesList extends StatelessWidget {
  final Function _updateEmployee;
  final _dbHelper;
  const EmployeesList(this._updateEmployee, this._dbHelper);

  SingleChildScrollView dataTable(List<Employee> employees) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
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
                    _updateEmployee(employee.id, employee.name);
                  },
                ),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _dbHelper.delete(employee.id);
                  },
                )),
              ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Employee>>(
        future: _dbHelper.getEmployees(),
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
}

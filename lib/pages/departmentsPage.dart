import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/department_bloc.dart';
import 'package:assets_manager/bloc/department_bloc_provider.dart';
import 'package:assets_manager/bloc/department_edit_bloc.dart';
import 'package:assets_manager/bloc/department_edit_bloc_provider.dart';
import 'package:assets_manager/models/phongban.dart';
import 'package:assets_manager/pages/departmentEditpage.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_phongban.dart';
import 'package:flutter/material.dart';

class DepartmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationServer _authenticationserver =
        AuthenticationServer(context);
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationserver);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return DepartmentBlocProvider(
                departmentBloc: DepartmentBloc(
                    DbDepartmentService(), _authenticationserver),
                uid: snapshot.data!,
                child: Warehouse());
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Phòng Ban'),
              ),
            );
          }
        },
      ),
    );
  }
}

class Warehouse extends StatefulWidget {
  const Warehouse({Key? key}) : super(key: key);

  @override
  _WarehouseState createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
  DepartmentBloc? _departmentBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _departmentBloc = DepartmentBlocProvider.of(context)?.departmentBloc;
  }

  void _addorEditDepartment(
      {required bool add, required Department department}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => DepartmentEditBlocProvider(
                departmentEditBloc:
                    DepartmentEditBloc(add, DbDepartmentService(), department),
                child: DepartmentEditPage(),
              ),
          fullscreenDialog: true),
    );
  }

  Future<bool> _confirmDeleteDepartment(String namePB) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Xóa Phòng Ban",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
                'Bạn có chắc chắn muốn xóa phòng ban ' + namePB + ' không ?',
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Huỷ')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Phòng Ban'),
      ),
      body: StreamBuilder(
          stream: _departmentBloc?.listDepartment,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot);
            } else {
              return Center(
                child: Container(
                  child: Text('Thêm Phòng Ban.'),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _addorEditDepartment(add: true, department: Department());
        },
        icon: Icon(Icons.add),
        label: Text('Phòng Ban'),
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _title = snapshot.data[index].Ten_Pb;
        String _subTitle = 'Số điện thoại: ' +
            snapshot.data[index].SDT +
            '\nĐịa Chỉ: ' +
            snapshot.data[index].DC;
        return Dismissible(
          key: Key(snapshot.data[index].documentID),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
            leading: Text(
              (index + 1).toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.lightBlue),
            ),
            title: Text(
              _title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.blue),
            ),
            subtitle: Text(_subTitle),
            onTap: () {
              _addorEditDepartment(
                  add: false,
                  department: Department(
                      documentID: snapshot.data[index].documentID,
                      Ten_Pb: snapshot.data[index].Ten_Pb,
                      SDT: snapshot.data[index].SDT,
                      DC: snapshot.data[index].DC));
            },
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteDepartment(_title);
            if (confirmDelete) {
              _departmentBloc?.deleteDepartment.add(snapshot.data[index]);
            }
            return null;
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.green,
        );
      },
    );
  }
}

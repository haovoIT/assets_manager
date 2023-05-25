import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/department_bloc.dart';
import 'package:assets_manager/bloc/department_bloc_provider.dart';
import 'package:assets_manager/models/phongban.dart';
import 'package:assets_manager/pages/assets_list_page.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_phongban.dart';
import 'package:flutter/material.dart';

class DepartmentsList extends StatelessWidget {
  final bool flag;

  DepartmentsList({Key? key, required this.flag}) : super(key: key);
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
                child: DepartmentList(
                  flag: flag,
                ));
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Phòng Ban.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class DepartmentList extends StatefulWidget {
  final bool flag;
  const DepartmentList({Key? key, required this.flag}) : super(key: key);

  @override
  _DepartmentListState createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  DepartmentBloc? _departmentBloc;
  TextEditingController tenController = new TextEditingController();
  String tenPB = "";
  bool flag = true;
  List<Department> listDepartment = [];
  List<Department> list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _departmentBloc = DepartmentBlocProvider.of(context)?.departmentBloc;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tenController.addListener(() {
      setState(() {
        tenPB = tenController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        appBar: AppBar(
            leading: new Icon(Icons.search),
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => {
                  tenController.clear(),
                  setState(() {
                    flag = true;
                  }),
                },
              ),
            ],
            title: TextFormField(
              enabled: true,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: "Nhập tên phòng ban....",
              ),
              controller: tenController,
              onChanged: (name) {
                listDepartment.clear();
                flag = false;
              },
            )),
        body: Container(
          child: StreamBuilder(
              stream: _departmentBloc?.listDepartment,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  list = snapshot.data;
                  return _build(snapshot);
                } else {
                  return Center(
                    child: Container(
                      child: Text('Thêm Phòng Ban.'),
                    ),
                  );
                }
              }),
        ),
      ),
      onWillPop: () async {
        final snackBar = SnackBar(
          content: Text(
            'Vui lòng chọn Phòng Ban thích hợp !!',
            style: TextStyle(
                fontSize: 14, fontStyle: FontStyle.italic, color: Colors.red),
          ),
          backgroundColor: Colors.blue.shade200,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      },
    );
  }

  Widget _build(AsyncSnapshot snapshot) {
    if (flag) {
      return _buildListViewSeparated(list);
    } else {
      for (int i = 0; i < snapshot.data.length; i++) {
        if (snapshot.data[i].Ten_Pb
            .toLowerCase()
            .contains(tenPB.toLowerCase())) {
          listDepartment.add(snapshot.data[i]);
        }
      }
      return _buildListViewSeparated(listDepartment);
    }
  }

  Widget _buildListViewSeparated(List<Department> listDepartments) {
    return ListView.separated(
      itemCount: listDepartments.length,
      itemBuilder: (BuildContext context, int index) {
        String _title = listDepartments[index].Ten_Pb!;
        String _subTitle = 'Số điện thoại: ' +
            listDepartments[index].SDT! +
            '\nĐịa Chỉ: ' +
            listDepartments[index].DC!;
        return ListTile(
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
            widget.flag
                ? Navigator.pop(
                    context, listDepartments[index].documentID! + _title)
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssetsPageList(
                              maPB: listDepartments[index].documentID!,
                            )));
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

  @override
  void dispose() {
    super.dispose();
    tenController.dispose();
  }
}

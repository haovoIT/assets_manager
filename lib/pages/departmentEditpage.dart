import 'package:assets_manager/bloc/department_edit_bloc.dart';
import 'package:assets_manager/bloc/department_edit_bloc_provider.dart';
import 'package:assets_manager/classes/format_money.dart';
import 'package:flutter/material.dart';

class DepartmentEditPage extends StatefulWidget {
  const DepartmentEditPage({Key? key}) : super(key: key);

  @override
  _DepartmentEditPageState createState() => _DepartmentEditPageState();
}

class _DepartmentEditPageState extends State<DepartmentEditPage> {
  DepartmentEditBloc? _departmentEditBloc;
  TextEditingController _tenPbController = new TextEditingController();
  TextEditingController _sdtController = new TextEditingController();
  TextEditingController _dcController = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _departmentEditBloc =
        DepartmentEditBlocProvider.of(context)?.departmentEditBloc;
  }

  void _addOrUpdateDepartment() {
    _departmentEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tenPbController = TextEditingController();
    _sdtController = TextEditingController();
    _dcController = TextEditingController();
    _sdtController = MaskedTextController(mask: '0000 000 000');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PHÒNG BAN',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: Icon(
                Icons.close,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: _departmentEditBloc?.tenPbEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _tenPbController.value =
                      _tenPbController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _tenPbController,
                    maxLength: 30,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Tên Phòng Ban',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (tenPb) =>
                        _departmentEditBloc?.tenPbEditChanged.add(tenPb),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: _departmentEditBloc?.sdtEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _sdtController.value =
                      _sdtController.value.copyWith(text: snapshot.data);
                  return TextField(
                    keyboardType: TextInputType.number,
                    controller: _sdtController,
                    maxLength: 12,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Số Điện Thoại',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (sdt) =>
                        _departmentEditBloc?.sdtEditChanged.add(sdt),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: _departmentEditBloc?.dcEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _dcController.value =
                      _dcController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _dcController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Địa Chỉ',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (diaChi) =>
                        _departmentEditBloc?.dcEditChanged.add(diaChi),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text('Huỷ'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 8.0),
                  TextButton(
                    child: Text('Lưu'),
                    onPressed: () {
                      _addOrUpdateDepartment();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Thông báo",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text('Lưu thông tin thành công.',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic)),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text('Đóng'))
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
              Divider(
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:assets_manager/bloc/contract_edit_bloc.dart';
import 'package:assets_manager/bloc/contract_edit_bloc_provider.dart';
import 'package:assets_manager/pages/nhacungcapList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractEditPage extends StatefulWidget {
  const ContractEditPage({Key? key}) : super(key: key);

  @override
  _ContractEditPageState createState() => _ContractEditPageState();
}

class _ContractEditPageState extends State<ContractEditPage> {
  ContractEditBloc? _contractEditBloc;
  TextEditingController _soHDController = new TextEditingController();
  TextEditingController _tenHDController = new TextEditingController();
  TextEditingController _ngayKyController = new TextEditingController();
  TextEditingController _nccController = new TextEditingController();
  TextEditingController _ndController = new TextEditingController();
  String tenNCC = '';
  bool ncc = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soHDController = TextEditingController();
    _tenHDController = TextEditingController();
    _ngayKyController = TextEditingController();
    _nccController = TextEditingController();
    _ndController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contractEditBloc = ContractEditBlocProvider.of(context)!.contractEditBloc;
  }

  Future<String> _selectDate(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);

    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 21900)),
      lastDate: DateTime.now().add(Duration(days: 21900)),
    );

    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              _initialDate.hour,
              _initialDate.minute,
              _initialDate.second,
              _initialDate.millisecond,
              _initialDate.microsecond)
          .toString();
    }
    return selectedDate;
  }

  void _addOrUpdateContract() {
    _contractEditBloc!.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông Tin Hợp Đồng',
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
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
                stream: _contractEditBloc?.soHDEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _soHDController.value =
                      _soHDController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    controller: _soHDController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        labelText: 'Số Hợp Đồng',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (soHD) =>
                        _contractEditBloc?.soHDEditChanged.add(soHD),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: _contractEditBloc?.tenHDEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _tenHDController.value =
                      _tenHDController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    controller: _tenHDController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Tên Hợp Đồng',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (tenHD) =>
                        _contractEditBloc?.tenHDEditChanged.add(tenHD),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _contractEditBloc?.ngayKyEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _ngayKyController.value =
                          _ngayKyController.value.copyWith(text: snapshot.data);
                      return Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 22.0,
                            color: Colors.black54,
                          ),
                          TextButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Ngày Ký Hợp Đồng:  " +
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(snapshot.data)),
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 15),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              String _pickerDate =
                                  await _selectDate(snapshot.data);
                              _contractEditBloc?.ngayKyEditChanged
                                  .add(_pickerDate);
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _contractEditBloc?.nHHEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      return Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 22.0,
                            color: Colors.black54,
                          ),
                          TextButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Ngày Hết Hạn:  " +
                                      DateFormat.yMd().format(
                                          DateTime.parse(snapshot.data)),
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 15),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              String _pickerDate =
                                  await _selectDate(snapshot.data);
                              _contractEditBloc?.nHHEditChanged
                                  .add(_pickerDate);
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _contractEditBloc?.nCCEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _nccController.value =
                          _nccController.value.copyWith(text: snapshot.data);
                      if (_nccController.text.length > 1) {
                        ncc = false;
                      }
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.assignment_outlined,
                                color: Colors.black54,
                              ),
                              TextButton(
                                onPressed: () async {
                                  final String _name = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NhaCungCapList(),
                                    ),
                                  );
                                  setState(() {
                                    tenNCC = _name;
                                  });
                                  _contractEditBloc?.nCCEditChanged.add(tenNCC);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Chọn Nhà Cung Cấp ",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            ncc ? '$tenNCC' : _nccController.text.toString(),
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 15,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              StreamBuilder(
                stream: _contractEditBloc?.ndEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _ndController.value =
                      _ndController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    maxLines: null,
                    controller: _ndController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Nội dung trọng tâm',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (nd) => _contractEditBloc?.ndEditChanged.add(nd),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 20.0),
                  TextButton(
                    child: Text(
                      'Save',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _addOrUpdateContract();
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
                                    child: Text('Thoát'))
                              ],
                            );
                          });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

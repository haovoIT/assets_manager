import 'dart:convert';

import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/bloc/assets_edit_bloc_provider.dart';
import 'package:assets_manager/classes/format_money.dart';
import 'package:assets_manager/classes/money_format.dart';
import 'package:assets_manager/pages/contractList.dart';
import 'package:assets_manager/pages/departmentList.dart';
import 'package:assets_manager/pages/nhomtaisanList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:select_dialog/select_dialog.dart';

class EditAssets extends StatefulWidget {
  final bool flag;
  const EditAssets({Key? key, required this.flag}) : super(key: key);

  @override
  _EditAssetsState createState() => _EditAssetsState();
}

class _EditAssetsState extends State<EditAssets> {
  late AssetsEditBloc _assetsEditBloc;
  TextEditingController _tenTsController = new TextEditingController();
  TextEditingController _tenPbController = new TextEditingController();
  TextEditingController _nuocSxTsController = new TextEditingController();
  TextEditingController _maNtsController = new TextEditingController();
  TextEditingController _maTinhTrangTsController = new TextEditingController();
  TextEditingController _nguyenGiaController = new TextEditingController();
  TextEditingController _tgSdController = new TextEditingController();
  TextEditingController _soLuongController = new TextEditingController();
  TextEditingController _soHdController = new TextEditingController();
  TextEditingController _mdsdController = new TextEditingController();
  TextEditingController _maQrController = new TextEditingController();
  String dropdownValue = '3';
  String tenPb = '';
  String tenHD = '';
  String tenNTS = '';
  String _tgsd = '';
  String ngaySX = '2013-01-01 00:00:00.000000';
  String ngayBD = '';
  String ngayKT = DateTime.now().toString();
  bool tgsd = true;
  bool tinhtrang = true;
  bool pb =
      true; //Kiểm tra nếu true thì tạo tài sản, nếu false thì cập nhật lại tài sản.
  bool hd = true;
  bool nts = true;
  bool ng = true;
  bool sl = true;
  bool flagNgayBD = false;
  int tgsdi = 0;
  late SnackBar snackBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tenTsController = TextEditingController();
    _tenPbController = TextEditingController();
    _nuocSxTsController = TextEditingController();
    _maNtsController = TextEditingController();
    _maTinhTrangTsController = TextEditingController();
    _nguyenGiaController = TextEditingController();
    _soLuongController = TextEditingController();
    _soHdController = TextEditingController();
    _mdsdController = TextEditingController();
    _maQrController = TextEditingController();
    _tgSdController = TextEditingController();
    _nguyenGiaController = new MoneyMaskedTextControllers(
      thousandSeparator: '.',
      initialValue: 0,
    );
    _soLuongController = new MaskedTextController(mask: '000');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assetsEditBloc = AssetsEditBlocProvider.of(context)!.assetsEditBloc;
    if (!widget.flag) {
      flagNgayBD = true;
    }
  }

  Future<String> _selectDatetime(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime? _pickedDate = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2013, 1, 1),
      maxTime: DateTime.now(),
      theme: DatePickerTheme(
          headerColor: Colors.blue,
          itemStyle: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
          doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
      currentTime: _initialDate,
      locale: LocaleType.vi,
    );

    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              DateTime.now().hour,
              DateTime.now().minute,
              DateTime.now().second,
              DateTime.now().millisecond,
              DateTime.now().microsecond)
          .toString();
    }
    return selectedDate;
  }

  Future<String?> _selectTinhTrang() async {
    String? results;
    await Picker(
        adapter: PickerDataAdapter<String>(
            pickerData: JsonDecoder().convert(TinhTrang)),
        changeToFirst: true,
        hideHeader: false,
        cancelText: "Huỷ",
        confirmText: "Xong",
        cancelTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        confirmTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        title: Text(
          "Chọn Tình Trạng",
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        headerColor: Colors.blue,
        selectedTextStyle:
            TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        onConfirm: (picker, value) {
          results = picker.adapter.text;
        }).showModal(this.context);
    return results;
  }

  void _addOrUpdateAssets() {
    _assetsEditBloc.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông Tin Tài sản',
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: StreamBuilder(
                  stream: _assetsEditBloc.tenTsEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: height / 3,
                        width: width / 2,
                      );
                    }
                    _tenTsController.value =
                        _tenTsController.value.copyWith(text: snapshot.data);
                    return TextFormField(
                      controller: _tenTsController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          labelText: 'Tên Tài sản',
                          errorText: _tenTsController.text.length < 1
                              ? "Bắt buộc nhập"
                              : null,
                          prefixIcon: Icon(Icons.assignment_outlined),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onChanged: (tenTs) =>
                          _assetsEditBloc.tenTsEditChanged.add(tenTs),
                    );
                  },
                ),
              ), //Tên TS
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: pb ? Colors.red : Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _assetsEditBloc.tenPbEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _tenPbController.value =
                          _tenPbController.value.copyWith(text: snapshot.data);
                      if (_tenPbController.text != '') {
                        pb = false;
                      }
                      return Column(
                        children: [
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
                                      builder: (context) =>
                                          DepartmentsList(flag: true),
                                    ),
                                  );
                                  setState(() {
                                    tenPb = _name;
                                    pb = false;
                                  });
                                  _assetsEditBloc.maPbEditChanged
                                      .add(_name.substring(0, 20));
                                  _assetsEditBloc.tenPbEditChanged
                                      .add(_name.substring(20, _name.length));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Chọn Phòng Ban ",
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
                            pb ? '$tenPb' : _tenPbController.text.toString(),
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
              ), //PhongBan
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _assetsEditBloc.namSXEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        ngaySX = snapshot.data;
                      }

                      return Row(
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.calendar_today,
                            size: 22.0,
                            color: Colors.black54,
                          ),
                          TextButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Ngày sản xuất:  " +
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
                              String _pickerDate =
                                  await _selectDatetime(snapshot.data);
                              _assetsEditBloc.namSXEditChanged.add(_pickerDate);
                              setState(() {
                                ngaySX = _pickerDate;
                              });
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ), //NgaySX
              StreamBuilder(
                stream: _assetsEditBloc.nuocSxEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _nuocSxTsController.value =
                      _nuocSxTsController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _nuocSxTsController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Nước sản xuất',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (nuocSx) =>
                        _assetsEditBloc.nuocSxEditChanged.add(nuocSx),
                  );
                },
              ), //NuocSX
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _assetsEditBloc.NtsEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _maNtsController.value =
                          _maNtsController.value.copyWith(text: snapshot.data);
                      if (_maNtsController.text.length > 1) {
                        nts = false;
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
                                      builder: (context) => NhomTaiSansList(),
                                    ),
                                  );
                                  setState(() {
                                    tenNTS = _name;
                                  });
                                  _assetsEditBloc.NtsEditChanged.add(tenNTS);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Chọn Nhóm Tài Sản ",
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
                            nts ? '$tenNTS' : _maNtsController.text.toString(),
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
              ), //NhomTs
              StreamBuilder(
                stream: _assetsEditBloc.nguyenGiaEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _nguyenGiaController.value =
                      _nguyenGiaController.value.copyWith(text: snapshot.data);
                  if (_nguyenGiaController.text.length > 0) {
                    ng = false;
                  }
                  return new TextField(
                      readOnly: widget.flag ? false : true,
                      keyboardType: TextInputType.number,
                      controller: _nguyenGiaController,
                      decoration: InputDecoration(
                          errorText: _nguyenGiaController.text.length < 1
                              ? "Bắt buộc nhập"
                              : null,
                          labelText: 'Nguyên Giá',
                          prefixIcon: Icon(Icons.assignment_outlined),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onChanged: (nguyenGia) => {
                            _assetsEditBloc.nguyenGiaEditChanged
                                .add(_getOnlyNumbers(nguyenGia).toVND()),
                            ng = false
                          });
                },
              ), //Nguyên Giá
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: tgsd ? Colors.red : Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _assetsEditBloc.tgSdEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _tgSdController.value =
                          _tgSdController.value.copyWith(text: snapshot.data);
                      if (_tgSdController.text.length > 0) {
                        tgsd = false;
                        _tgsd = _tgSdController.text;
                        tgsdi = int.parse(_tgSdController.text);
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 22.0,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "Thời gian sử dụng:    ",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 15),
                              ),
                              ElevatedButton(
                                child: tgsd
                                    ? Icon(
                                        Icons.arrow_circle_down_outlined,
                                      )
                                    : Text(_tgsd),
                                onPressed: widget.flag
                                    ? () async {
                                        SelectDialog.showModal<String>(
                                          context,
                                          label: "Số tháng sử dụng",
                                          titleStyle:
                                              TextStyle(color: Colors.brown),
                                          showSearchBox: false,
                                          selectedValue: _tgsd,
                                          items: <String>[
                                            '12',
                                            '24',
                                            '36',
                                            '48',
                                            '60',
                                            '72',
                                            '84',
                                            '96',
                                            '108',
                                            '120',
                                            '132',
                                            '144',
                                            '156',
                                            '168',
                                            '180',
                                            '192',
                                            '204',
                                            '216',
                                            '228',
                                            '240',
                                          ],
                                          onChange: (String selected) {
                                            setState(() {
                                              tgsd = false;
                                              _tgsd = selected;
                                              _assetsEditBloc.tgSdEditChanged
                                                  .add(selected);
                                              tgsdi = int.parse(_tgsd);
                                            });
                                          },
                                        );
                                      }
                                    : () async {
                                        final snackBar = SnackBar(
                                          content: Text(
                                            'Không được thay đổi nguyên giá và thời gian sử dụng.',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.red),
                                          ),
                                          backgroundColor: Colors.blue.shade200,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      },
                              ),
                              Text(
                                "  Tháng",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ), //TGSD
              widget.flag
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: flagNgayBD
                                      ? Color(0xffCED0D2)
                                      : Colors.red),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 22.0,
                                color: Colors.black54,
                              ),
                              TextButton(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      flagNgayBD
                                          ? "Ngày bắt đầu:  " +
                                              DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(ngayBD))
                                          : "Ngày bắt đầu:  " +
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now()),
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
                                onPressed: () async {
                                  String _pickerDateBD =
                                      await _selectDatetimeBD(DateTime.now(),
                                          DateTime.parse(ngaySX));
                                  setState(() {
                                    ngayBD = _pickerDateBD;
                                    ngayKT = addMonth(tgsdi, _pickerDateBD);
                                    _assetsEditBloc.ngayKTEditChanged
                                        .add(ngayKT);
                                    flagNgayBD = true;
                                  });
                                  _assetsEditBloc.ngayBDEditChanged
                                      .add(_pickerDateBD);
                                },
                              )
                            ],
                          )),
                    )
                  : SizedBox(), //NgayBD
              widget.flag
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Color(0xffCED0D2)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 10.0,
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 22.0,
                              color: Colors.black54,
                            ),
                            TextButton(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Ngày kết thúc:  " +
                                        DateFormat('dd/MM/yyyy')
                                            .format(DateTime.parse(ngayKT)),
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
                                String _pickerDateKT =
                                    await _selectDatetimeKT(ngayKT);
                                _assetsEditBloc.ngayKTEditChanged
                                    .add(_pickerDateKT);
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(), //NgayKT
              StreamBuilder(
                stream: _assetsEditBloc.soLuongEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _soLuongController.value =
                      _soLuongController.value.copyWith(text: snapshot.data);
                  if (_soLuongController.text.length > 0) {
                    sl = false;
                  }
                  return TextField(
                      keyboardType: TextInputType.number,
                      controller: _soLuongController,
                      decoration: InputDecoration(
                          errorText: _soLuongController.text.length < 1
                              ? "Bắt buộc nhập"
                              : null,
                          labelText: 'Số lượng',
                          prefixIcon: Icon(Icons.assignment_outlined),
                          hintText: 'Số lượng phải nhỏ hơn 1000',
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onChanged: (soLuong) => {
                            _assetsEditBloc.soLuongEditChanged.add(soLuong),
                            sl = false
                          });
                },
              ), //SoLuong
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _assetsEditBloc.tenHdEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _soHdController.value =
                          _soHdController.value.copyWith(text: snapshot.data);
                      if (_soHdController.text.length > 1) {
                        hd = false;
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
                                      builder: (context) => ContractList(),
                                    ),
                                  );
                                  setState(() {
                                    tenHD = _name;
                                  });
                                  _assetsEditBloc.tenHdEditChanged.add(tenHD);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Chọn Hợp Đồng ",
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
                            hd ? '$tenHD' : _soHdController.text.toString(),
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
              ), //HopDong
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _assetsEditBloc.TinhTrangEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _maTinhTrangTsController.value = _maTinhTrangTsController
                          .value
                          .copyWith(text: snapshot.data);
                      return Row(
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.calendar_today,
                            size: 22.0,
                            color: Colors.black54,
                          ),
                          TextButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Tình Trạng:  " + snapshot.data.toString(),
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
                              String? tinhtrang = await _selectTinhTrang();
                              _assetsEditBloc.TinhTrangEditChanged.add(
                                  _getOnlyCharacters(tinhtrang ?? ""));
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ), //TinhTrang
              StreamBuilder(
                stream: _assetsEditBloc.mdsdEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _mdsdController.value =
                      _mdsdController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _mdsdController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Mục đích sử dụng',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (maMdsd) =>
                        _assetsEditBloc.mdsdEditChanged.add(maMdsd),
                  );
                },
              ), //Mdsd
              StreamBuilder(
                stream: _assetsEditBloc.maQrEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _maQrController.value =
                      _maQrController.value.copyWith(text: snapshot.data);
                  _assetsEditBloc.maQrEditChanged
                      .add(_maQrController.text.toString());
                  return Container();
                },
              ), //NCC
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(
                      'Huỷ',
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
                      'Lưu',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_tenTsController.text.length > 0 &&
                          !pb &&
                          !ng &&
                          !sl &&
                          flagNgayBD) {
                        _assetsEditBloc.khauHaoEditChanged
                            .add(khauHao(_nguyenGiaController.text, _tgsd));
                        _addOrUpdateAssets();
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
                                content: Text("Lưu thông tin thành công.",
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
                      } else {
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
                                content: Text("* Bắt buộc nhập hoặc chọn.",
                                    style: TextStyle(
                                        color: Colors.red,
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
                      }
                    },
                  ),
                ],
              ), //Save
            ],
          ),
        ),
      ),
    );
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text;
    var onlyNumbersRegex = new RegExp(r'[^\d]');
    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');
    return cleanedText;
  }

  String _getOnlyCharacters(String text) {
    String cleanedText = text;
    cleanedText = cleanedText.replaceAll('[', '');
    cleanedText = cleanedText.replaceAll(']', '');
    return cleanedText;
  }

  Future<String> _selectDatetimeBD(
      DateTime selectedDate, DateTime minTime) async {
    DateTime _initialDate = selectedDate;
    final DateTime? _pickedDate = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: minTime, //DateTime(2013, 1, 1),
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            headerColor: Colors.blue,
            itemStyle: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        currentTime: _initialDate,
        locale: LocaleType.vi);

    if (_pickedDate != null) {
      selectedDate = DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second,
          DateTime.now().millisecond,
          DateTime.now().microsecond);
    }
    return selectedDate.toString();
  }

  Future<String> _selectDatetimeKT(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime? _pickedDate = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2013, 1, 1),
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            headerColor: Colors.blue,
            itemStyle: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        currentTime: _initialDate,
        locale: LocaleType.vi);

    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              DateTime.now().hour,
              DateTime.now().minute,
              DateTime.now().second,
              DateTime.now().millisecond,
              DateTime.now().microsecond)
          .toString();
    }
    return selectedDate;
  }

  String addMonth(int soThang, String ngayBDi) {
    DateTime ngayBD = DateTime.parse(ngayBDi);
    String selectedDate;
    double index = soThang / 12;
    selectedDate = DateTime(
            ngayBD.year + index.toInt(),
            ngayBD.month,
            ngayBD.day,
            ngayBD.hour,
            ngayBD.minute,
            ngayBD.second,
            ngayBD.millisecond,
            ngayBD.microsecond)
        .toString();
    return selectedDate;
  }

  String khauHao(String nguyenGia, String tgsd) {
    int khauHao;
    khauHao = int.parse(_getOnlyNumbers(nguyenGia)) ~/ int.parse(tgsd);
    return khauHao.toVND();
  }
}

const TinhTrang = '''[
"Đang Sử Dụng",
"Ngừng Sử Dụng",
"Mất Mát",
"Hư Hỏng"
]''';

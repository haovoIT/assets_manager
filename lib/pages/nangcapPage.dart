import 'dart:convert';

import 'package:assets_manager/bloc/diary_edit_bloc.dart';
import 'package:assets_manager/bloc/diary_edit_bloc_provider.dart';
import 'package:assets_manager/classes/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';

class NangCapPage extends StatefulWidget {
  final double luyke;
  final int soThang;
  final bool flag;
  final String maPB;
  const NangCapPage(
      {Key? key,
      required this.luyke,
      required this.soThang,
      required this.flag,
      required this.maPB})
      : super(key: key);

  @override
  _NangCapPageState createState() => _NangCapPageState();
}

class _NangCapPageState extends State<NangCapPage> {
  DiaryEditBloc? diaryEditBloc;
  TextEditingController _tenTsController = new TextEditingController();
  TextEditingController _nguyenGiaController = new TextEditingController();
  TextEditingController _tgSdController = new TextEditingController();
  TextEditingController _ngayKTController = new TextEditingController();
  TextEditingController _khauHaoController = new TextEditingController();
  String _tgsd = '';
  bool tgsd = true;
  bool ngayKTi = true;
  bool flagLyDo = false;
  String ngayBD = '';
  String ngayKT = DateTime.now().toString();
  int tgsdi = 0;

  double khauHao = 0;
  double luyKe = 0;
  double conLai = 0;
  double nguyenGiacl = 0;
  int tgcl = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tenTsController = TextEditingController();
    _nguyenGiaController = TextEditingController();
    _tgSdController = TextEditingController();
    _nguyenGiaController = new MoneyMaskedTextControllers(
      thousandSeparator: '.',
      initialValue: 0,
    );
    _ngayKTController = TextEditingController();
    _khauHaoController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    diaryEditBloc =
        DiaryEditBlocProvider.of(context)?.diaryEditBloc;
  }

  void _addOrUpdate() {
    diaryEditBloc?.idDepartmentEditChanged.add(widget.maPB);
    diaryEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.flag ? 'Nâng Cấp Tài sản' : "Xác nhận chuyển đổi",
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
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: StreamBuilder(
                  stream: diaryEditBloc?.nameAssetEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    _tenTsController.value =
                        _tenTsController.value.copyWith(text: snapshot.data);
                    return TextFormField(
                      controller: _tenTsController,
                      readOnly: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          labelText: 'Tên Tài sản',
                          prefixIcon: Icon(Icons.assignment_outlined),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    );
                  },
                ),
              ), //Tên TS
              StreamBuilder(
                stream: diaryEditBloc?.originalPriceEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _nguyenGiaController.value =
                      _nguyenGiaController.value.copyWith(text: snapshot.data);
                  return new TextField(
                      keyboardType: TextInputType.number,
                      controller: _nguyenGiaController,
                      decoration: InputDecoration(
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
                            diaryEditBloc?.originalPriceEditChanged
                                .add(_getOnlyNumbers(nguyenGia).toVND()),
                          });
                },
              ), //Nguyên Giá
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: diaryEditBloc?.usedTimeEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _tgSdController.value =
                          _tgSdController.value.copyWith(text: snapshot.data);
                      if (_tgSdController.text.length > 0) {
                        tgsd = false;
                        _tgsd = _tgSdController.text;
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
                                onPressed: () async {
                                  /*SelectDialog.showModal<String>(
                                    context,
                                    label: "Số tháng sử dụng",
                                    titleStyle: TextStyle(color: Colors.brown),
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
                                        ngayKTi = false;
                                        tgsdi = int.parse(selected);
                                        _tgsd = selected;
                                        diaryEditBloc?.tgSdEditChanged
                                            .add(selected);
                                      });
                                    },
                                  );*/
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
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: StreamBuilder(
                  stream: diaryEditBloc?.starDateEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    ngayBD = snapshot.data;
                    ngayKT = addMonth(tgsdi, ngayBD);
                    return TextFormField(
                      initialValue: DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(snapshot.data)),
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Ngày Bắt Đầu",
                          prefixIcon: Icon(Icons.assignment_outlined),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    );
                  },
                ),
              ), //NgayBD
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: StreamBuilder(
                  stream: diaryEditBloc?.endDateEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    if (ngayKTi) {
                      _ngayKTController.value = _ngayKTController.value
                          .copyWith(
                              text: DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(snapshot.data)));
                    } else {
                      _ngayKTController.value = _ngayKTController.value
                          .copyWith(
                              text: DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(ngayKT)));
                      diaryEditBloc?.endDateEditChanged.add(ngayKT);
                    }
                    return TextFormField(
                      controller: _ngayKTController,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Ngày Kết Thúc",
                          prefixIcon: Icon(Icons.assignment_outlined),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    );
                  },
                ),
              ), //NgayKT
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: flagLyDo ? Color(0xffCED0D2) : Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: diaryEditBloc?.detailEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
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
                                  "Lý Do:  " + snapshot.data.toString(),
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
                              String? lydo = await _selectLyDo();
                              diaryEditBloc?.detailEditChanged
                                  .add(_getOnlyCharacters(lydo ?? ""));
                              setState(() {
                                flagLyDo = true;
                              });
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ), //Lydo
              StreamBuilder(
                stream: diaryEditBloc?.depreciationEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _khauHaoController.value =
                      _khauHaoController.value.copyWith(text: snapshot.data);
                  if (!ngayKTi) {
                    nguyenGiacl = double.parse(
                            _getOnlyNumbers(_nguyenGiaController.text)) -
                        widget.luyke;
                    tgcl = tgsdi - widget.soThang;
                    khauHao = nguyenGiacl / tgcl;
                    _khauHaoController.value = _khauHaoController.value
                        .copyWith(text: khauHao.toInt().toVND());
                    diaryEditBloc?.depreciationEditChanged
                        .add(khauHao.toInt().toVND());
                  }
                  return TextField(
                      readOnly: true,
                      controller: _khauHaoController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          labelText: 'Khấu Hao',
                          prefixIcon: Icon(Icons.assignment_outlined),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onChanged: (khauHao) =>
                          diaryEditBloc?.depreciationEditChanged.add(khauHao));
                },
              ), //khauhao
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
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
                      if (flagLyDo) {
                        _addOrUpdate();
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

  Future<String?> _selectLyDo() async {
    String? results;
    await Picker(
        adapter:
            PickerDataAdapter<String>(pickerData: JsonDecoder().convert(LyDo)),
        changeToFirst: true,
        hideHeader: false,
        cancelText: "Huỷ",
        confirmText: "Xong",
        cancelTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        confirmTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        title: Text(
          "Chọn Lý Do",
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

  String _getOnlyCharacters(String text) {
    String cleanedText = text;

    cleanedText = cleanedText.replaceAll('[', '');
    cleanedText = cleanedText.replaceAll(']', '');

    return cleanedText;
  }
}

const LyDo = '''[
"Nâng Cấp Tài Sản",
"Định Lại Tài Sản",
"Chuyển Đổi Phòng Ban"
]''';

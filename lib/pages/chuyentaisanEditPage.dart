import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/bloc/assets_edit_bloc_provider.dart';
import 'package:assets_manager/classes/format_money.dart';
import 'package:assets_manager/pages/departmentList.dart';
import 'package:assets_manager/pages/khauhaoPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChuyenDoiEditPage extends StatefulWidget {
  final bool flag;
  final String? maQr;
  const ChuyenDoiEditPage({Key? key, required this.flag, this.maQr})
      : super(key: key);

  @override
  _ChuyenDoiEditPageState createState() => _ChuyenDoiEditPageState();
}

class _ChuyenDoiEditPageState extends State<ChuyenDoiEditPage> {
  late AssetsEditBloc _assetsEditBloc;
  TextEditingController _tenTsController = new TextEditingController();
  TextEditingController _tenPbController = new TextEditingController();
  TextEditingController _soLuongController = new TextEditingController();
  TextEditingController _soLuongChuyenController = new TextEditingController();
  String dropdownValue = '3';
  String tenPb = '';
  String maPb = '';
  bool pb = true;
  SnackBar? snackBar;
  int slHienCo = 0;
  int slChuyen = 0;
  int slConLai = 0;
  bool slChuyenDoi = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tenTsController = TextEditingController();
    _tenPbController = TextEditingController();
    _soLuongController = TextEditingController();
    _soLuongChuyenController = TextEditingController();
    _soLuongController = new MaskedTextController(mask: '000');
    _soLuongChuyenController = new MaskedTextController(mask: '000');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assetsEditBloc = AssetsEditBlocProvider.of(context)!.assetsEditBloc;
  }

  void _AddAssets() {
    _assetsEditBloc.saveEditChanged.add('Add');
    Navigator.pop(context);
  }

  void _UpdateAsset() {
    _assetsEditBloc.saveEditChanged.add('Save');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chuyển Đổi Tài sản',
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
      body: widget.flag ? _build() : _buildFull(),
    );
  }

  Widget _build() {
    return SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _assetsEditBloc.tenPbEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _tenPbController.value =
                          _tenPbController.value.copyWith(text: snapshot.data);
                      if (_tenPbController.text.length > 1) {
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
                                      builder: (context) => DepartmentsList(
                                        flag: true,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    tenPb = _name;
                                    maPb = _name.substring(0, 20);
                                    print("$maPb");
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
                      'Tiếp tục',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _assetsEditBloc.maQrEditChanged.add(widget.maQr ?? "");
                      _assetsEditBloc.saveEditChanged.add('Add');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KhauHaoPage(
                                    ma: widget.maQr ?? "",
                                    flag: 3,
                                    maPB: maPb,
                                  )));

                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildFull() {
    return SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 10.0)),
              StreamBuilder(
                stream: _assetsEditBloc.tenTsEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _tenTsController.value =
                      _tenTsController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    controller: _tenTsController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Tên Tài sản',
                        errorText: _tenTsController.text.length < 1
                            ? "Tên tài sản có ít nhất 1 kí tự"
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
              SizedBox(
                height: 10.0,
              ), //Tên TS
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: _assetsEditBloc.tenPbEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      _tenPbController.value =
                          _tenPbController.value.copyWith(text: snapshot.data);
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
                                onPressed: () async {},
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Từ Phòng Ban ",
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
                            _tenPbController.text.toString(),
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
                stream: _assetsEditBloc.soLuongEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _soLuongController.value =
                      _soLuongController.value.copyWith(text: snapshot.data);
                  slHienCo = int.parse(_soLuongController.text);
                  return TextField(
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    controller: _soLuongController,
                    decoration: InputDecoration(
                        labelText: 'Số lượng hiện có',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        hintText: 'Số lượng phải nhỏ hơn 1000',
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    /*onChanged: (soLuong) => {
                            _assetsEditBloc.soLuongEditChanged.add(soLuong),
                          }*/
                  );
                },
              ),
              Container(
                child: Text("Bạn muốn chuyển bao nhiêu? "),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              ),
              TextField(
                  readOnly: slChuyenDoi ? true : false,
                  keyboardType: TextInputType.number,
                  controller: _soLuongChuyenController,
                  decoration: InputDecoration(
                      labelText: 'Số lượng muốn chuyển',
                      prefixIcon: Icon(Icons.assignment_outlined),
                      hintText: 'Phải nhỏ hơn số lượng có',
                      //errorText: int.tryParse(_soLuongController.text.toString()) > slHienCo? "Số Lượng chuyển phải nhỏ hơn số lượng hiện có": null,
                      labelStyle:
                          TextStyle(color: Colors.blueAccent, fontSize: 15),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onChanged: (soLuong) => {
                        if (soLuong != '')
                          {
                            setState(() {
                              slChuyen = int.parse(soLuong);
                              slConLai = slHienCo - slChuyen;
                            }),
                          }
                        else
                          {
                            setState(() {
                              slConLai = 0;
                            }),
                          }
                      }),
              slConLai > 0
                  ? Container(
                      child: Text("Nhấn OK để xác nhận số lượng chuyển."),
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    )
                  : Container(),
              slConLai > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            'OK',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (!slChuyenDoi) {
                              _assetsEditBloc.soLuongEditChanged
                                  .add(slConLai.toString());
                              setState(() {
                                slChuyenDoi = true;
                              });
                              _UpdateAsset();
                              /*if (_tenTsController.text.length >= 2) {
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
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text('Đóng'))
                            ],
                          );
                        });
                  }*/
                            }
                          },
                        ),
                      ],
                    )
                  : Container(),

              slChuyenDoi
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Color(0xffCED0D2)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
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
                                        builder: (context) => DepartmentsList(
                                          flag: true,
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      tenPb = _name;
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Đến Phòng Ban ",
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
                            tenPb.length > 0
                                ? Text(
                                    '${tenPb.substring(20, tenPb.length)}',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    )
                  : Container(),
              slChuyenDoi
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            'Lưu',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _assetsEditBloc.maPbEditChanged
                                .add(tenPb.substring(0, 20));
                            _assetsEditBloc.tenPbEditChanged
                                .add(tenPb.substring(20, tenPb.length));
                            _assetsEditBloc.mdsdEditChanged.add(
                                "Được chuyển đến từ Phòng ${_tenPbController.text}");

                            _assetsEditBloc.soLuongEditChanged
                                .add(slChuyen.toString());

                            //_AddAssets();

                            _assetsEditBloc.maQrEditChanged
                                .add(widget.maQr ?? "");
                            _assetsEditBloc.saveEditChanged.add('Add');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KhauHaoPage(
                                          ma: widget.maQr ?? "",
                                          flag: 3,
                                          maPB: tenPb.substring(0, 20),
                                        )));
                          },
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ));
  }
}

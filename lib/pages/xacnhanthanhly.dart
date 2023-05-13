import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/bloc/assets_edit_bloc_provider.dart';
import 'package:assets_manager/pages/khauhaoPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class XacNhanThanhLy extends StatefulWidget {
  const XacNhanThanhLy({Key? key}) : super(key: key);

  @override
  _XacNhanThanhLyState createState() => _XacNhanThanhLyState();
}

class _XacNhanThanhLyState extends State<XacNhanThanhLy> {
  AssetsEditBloc? _assetsEditBloc;
  String maQR = "";
  String tenTS = "";
  String maPb = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assetsEditBloc = AssetsEditBlocProvider.of(context)?.assetsEditBloc;
  }

  void _addOrUpdateAssets() {
    _assetsEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông Tin Tài sản',
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: StreamBuilder(
                    stream: _assetsEditBloc?.tenTsEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      tenTS = snapshot.data;
                      return _textField('Tên Tài Sản', snapshot.data);
                    },
                  )),
              _padding(_assetsEditBloc!.tenPbEdit, 'Tên Phòng Ban', 0),
              _padding(_assetsEditBloc!.namSXEdit, 'Ngày Sản Xuất', 1),
              _padding(_assetsEditBloc!.nuocSxEdit, 'Nước Sản Xuất', 0),
              _padding(_assetsEditBloc!.NtsEdit, 'Nhóm Tài Sản', 0),
              _padding(_assetsEditBloc!.nguyenGiaEdit, 'Nguyên Giá', 0),
              _padding(
                  _assetsEditBloc!.tgSdEdit, 'Thời Gian Sử Dụng(Tháng)', 0),
              _padding(_assetsEditBloc!.ngayBDEdit, 'Ngày Bắt Đầu:', 1),
              _padding(_assetsEditBloc!.ngayKTEdit, 'Ngày Kết Thúc', 1),
              _padding(_assetsEditBloc!.soLuongEdit, 'Số Lượng', 0),
              _padding(_assetsEditBloc!.tenHdEdit, 'Hợp Đồng', 0),
              _padding(_assetsEditBloc!.TinhTrangEdit, 'Tình Trạng', 0),
              _padding(_assetsEditBloc!.mdsdEdit, 'Mục Đích Sử Dụng', 0),
              Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: StreamBuilder(
                    stream: _assetsEditBloc!.maPbEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      maPb = snapshot.data;
                      return SizedBox();
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: StreamBuilder(
                    stream: _assetsEditBloc?.maQrEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      maQR = snapshot.data;
                      return SizedBox();
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Xác Nhận Thanh Lý',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _assetsEditBloc?.TinhTrangEditChanged.add("Đã Thanh Lý");
                      _addOrUpdateAssets();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KhauHaoPage(
                                    ma: maQR,
                                    flag: 1,
                                  )));

                      /*_addorEditThanhLy(
                            add: true,
                            thanhLy: ThanhLy(
                                documentID: maQR,
                                Ten_ts: tenTS,
                                Ma_pb: maPb,
                                Don_vi_TL: '',
                                Nguyen_gia_TL: '',
                                Ngay_TL: ''));*/
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

  Padding _padding(Stream stream, String name, int index) {
    late Widget textFiled;
    return Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: StreamBuilder(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            switch (index) {
              case 0:
                textFiled = _textField(name, snapshot.data);
                break;
              case 1:
                textFiled = _textField(
                    name,
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(snapshot.data)));
                break;
            }
            return textFiled;
          },
        ));
  }

  Widget _textField(String name, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
          labelText: name,
          prefixIcon: Icon(Icons.assignment_outlined),
          labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 15),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}

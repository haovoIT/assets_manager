import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/diary_bloc.dart';
import 'package:assets_manager/bloc/diary_bloc_provider.dart';
import 'package:assets_manager/bloc/diary_edit_bloc.dart';
import 'package:assets_manager/bloc/diary_edit_bloc_provider.dart';
import 'package:assets_manager/bloc/thanhly_edit_bloc.dart';
import 'package:assets_manager/bloc/thanhly_edit_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_ThongTinKhauHao.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/models/diary_model.dart';
import 'package:assets_manager/models/thanhly.dart';
import 'package:assets_manager/pages/nangcapPage.dart';
import 'package:assets_manager/pages/thanhlyEditPage.dart';
import 'package:assets_manager/pages/xacnhanthongtin.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_diary.dart';
import 'package:assets_manager/services/db_thanhly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:intl/intl.dart';

class Depreciation extends StatelessWidget {
  final String idAsset;
  final int flag;
  final String? maPB;

  const Depreciation(
      {Key? key, required this.idAsset, required this.flag, this.maPB})
      : super(key: key);
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
            return DiaryBlocProvider(
              diaryBloc: DiaryBloc(DbDiaryService(), _authenticationserver),
              uid: snapshot.data!,
              child: DepreciationPage(
                idAsset: idAsset,
                flag: flag,
                maPB: maPB ?? "",
              ),
            );
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Tài Sản.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class DepreciationPage extends StatefulWidget {
  final String idAsset;
  final int flag;
  final String maPB;
  const DepreciationPage(
      {Key? key, required this.idAsset, required this.flag, required this.maPB})
      : super(key: key);

  @override
  _DepreciationPageState createState() => _DepreciationPageState();
}

class _DepreciationPageState extends State<DepreciationPage> {
  DiaryBloc? diaryBloc;
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  List<DiaryModel> list = [];
  DiaryModel diaryModel = new DiaryModel();

  double khauHao = 0;
  double luyKe = 0;
  double conLai = 0;
  int _nguyenGia = 0;
  int _tgsd = 0;
  int soThang = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    diaryBloc = DiaryBlocProvider.of(context)?.diaryBloc;

    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    diaryBloc?.idAssetEditChanged.add(widget.idAsset);
    //DiaryBloc.maPbEditChanged.add(maPb);
  }

  void _addorEdit({
    required bool add,
    required DiaryModel diaryModel,
    required double luyke,
    required int soThang,
    required bool flag,
    required String maPB,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => DiaryEditBlocProvider(
                diaryEditBloc: DiaryEditBloc(DbDiaryService(), add, diaryModel),
                uid: '',
                child: NangCapPage(
                  luyke: luyKe,
                  soThang: soThang,
                  flag: flag,
                  maPB: maPB,
                ),
              ),
          fullscreenDialog: true),
    );
  }

  void _addorEditThanhLy({required bool add, required ThanhLy thanhLy}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => ThanhLyEditBlocProvider(
                thanhLyEditBloc:
                    ThanhLyEditBloc(DbThanhLyService(), add, thanhLy),
                child: ThanhLyEditPage(),
              ),
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Khấu Hao Tài Sản"),
        actions: [
          IconButton(
              onPressed: () async {
                final AssetsModel assets = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => XacNhanThongTin(
                      ma: diaryModel.qrCode ?? "",
                    ),
                  ),
                );
                if (assets != null) {
                  final pdfFile = await PdfThongTinKHApi.generate(
                      assets,
                      list,
                      khauHao.toInt().toVND(),
                      luyKe.toInt().toVND(),
                      conLai.toInt().toVND(),
                      email,
                      name);
                  PdfApi.openFile(pdfFile);
                }
              },
              icon: Icon(
                Icons.print,
                color: Colors.green,
              )),
          Container(
            width: 15.0,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: diaryBloc?.listDiaryModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot);
            } else {
              return Center(
                child: Container(
                  child: Text('Thêm Tài Sản.'),
                ),
              );
            }
          }),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    list = snapshot.data;
    int length = list.length;
    diaryModel = list[length - 1];
    int index = 0;
    DateTime now = DateTime.now();
    DateTime start = DateTime.parse(list[0].starDate!);
    DateTime end;

    if (length == 1) {
      soThang = month(start, now);
      khauHao = double.parse(_getOnlyNumbers(diaryModel.depreciation ?? ""));
      luyKe = khauHao * soThang;
      conLai =
          double.parse(_getOnlyNumbers(diaryModel.originalPrice ?? "")) - luyKe;
    } else if (length > 1) {
      start = DateTime.parse(list[0].starDate ?? "");
      end = DateTime.parse(list[length - 1].dateUpdate ?? "");
      for (index = 0; index < length; index++) {
        if (index == 0) {
          luyKe +=
              double.parse(_getOnlyNumbers(list[index].depreciation ?? "")) *
                  month(DateTime.parse(list[index].starDate ?? ""),
                      DateTime.parse(list[index + 1].dateUpdate ?? ""));
        } else if (index > 0 && index != length - 1) {
          luyKe +=
              double.parse(_getOnlyNumbers(list[index].depreciation ?? "")) *
                  month(DateTime.parse(list[index].dateUpdate ?? ""),
                      DateTime.parse(list[index + 1].dateUpdate ?? ""));
        } else if (index > 0 && index == length - 1) {
          luyKe +=
              double.parse(_getOnlyNumbers(list[index].depreciation ?? "")) *
                  month(DateTime.parse(list[index].dateUpdate ?? ""), now);
        }
      }
      _nguyenGia =
          int.parse(_getOnlyNumbers(list[length - 1].originalPrice ?? ""));
      _tgsd = int.parse(list[length - 1].usedTime ?? "") - month(now, start);
      soThang = month(now, start);
      khauHao =
          double.parse(_getOnlyNumbers(list[length - 1].depreciation ?? ""));
      conLai = _nguyenGia - luyKe;
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Phần Thông Tin Tài Sản",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _padding("Tên Tài Sản", diaryModel.nameAsset ?? ""),
            _padding("Nguyên Giá", diaryModel.originalPrice ?? ""),
            _padding("Thời Gian Sử Dụng(Tháng)", diaryModel.usedTime ?? ""),
            _padding(
                "Ngày Bắt Đầu",
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(diaryModel.starDate ?? ""))),
            _padding(
                "Ngày Kết Thúc",
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(diaryModel.endDate ?? ""))),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Phần Thông Tin Khấu hao",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            _padding("Mức Khấu Hao Hàng Tháng", khauHao.toInt().toVND()),
            _padding("Khấu Hao Lũy Kế", luyKe.toInt().toVND()),
            _padding("Giá Trị Còn Lại", conLai.toInt().toVND()),
            SizedBox(
              height: 10.0,
            ),
            widget.flag == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'Xác Nhận Thanh Lý',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _addorEditThanhLy(
                              add: true,
                              thanhLy: ThanhLy(
                                  documentID: diaryModel.qrCode,
                                  Ten_ts: diaryModel.nameAsset,
                                  Ma_pb: diaryModel.idDepartment,
                                  Don_vi_TL: '',
                                  Nguyen_gia_TL: conLai.toInt().toVND(),
                                  Ngay_TL: ''));
                        },
                      ),
                    ],
                  )
                : Container(),
            widget.flag == 2
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'Nâng Cấp Tài Sản',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _addorEdit(
                              add: true,
                              diaryModel: diaryModel,
                              luyke: luyKe,
                              soThang: soThang,
                              flag: true,
                              maPB: maPb);
                        },
                      ),
                    ],
                  )
                : Container(),
            widget.flag == 3
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'Tiếp tục',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _addorEdit(
                              add: true,
                              diaryModel: diaryModel,
                              luyke: luyKe,
                              soThang: soThang,
                              flag: false,
                              maPB: widget.maPB);
                        },
                      ),
                    ],
                  )
                : Container(),
          ],
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

  int month(DateTime start, DateTime now) {
    int sum = now.month - start.month + (now.year - start.year) * 12;
    if (now.day < start.day) {
      sum -= 1;
    }
    return sum;
  }

  Widget _padding(String name, String value) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
              labelText: name,
              prefixIcon: Icon(Icons.assignment_outlined),
              labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 15),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ));
  }
}

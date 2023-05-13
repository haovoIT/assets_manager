import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/lichsusudung_bloc.dart';
import 'package:assets_manager/bloc/lichsusudung_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_LichSuSuDung.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/lichsusudungtaisan.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_lichsusudung.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

class LichSuSuDungPage extends StatelessWidget {
  final String ma;
  const LichSuSuDungPage({Key? key, required this.ma}) : super(key: key);
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
            return LichSuSuSungBlocProvider(
              lichSuSuDungBloc:
                  LichSuSuDungBloc(DbLSSDService(), _authenticationserver),
              uid: snapshot.data!,
              child: LichSuSuDungs(
                ma: ma,
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

class LichSuSuDungs extends StatefulWidget {
  final String ma;
  const LichSuSuDungs({Key? key, required this.ma}) : super(key: key);

  @override
  _LichSuSuDungsState createState() => _LichSuSuDungsState();
}

class _LichSuSuDungsState extends State<LichSuSuDungs> {
  LichSuSuDungBloc? lichSuSuDungBloc;
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  List<LichSuSuDung> listLSSD = [];

  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    lichSuSuDungBloc = LichSuSuSungBlocProvider.of(context)?.lichSuSuDungBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    lichSuSuDungBloc?.maEditChanged.add(widget.ma);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch Sử Sử Dụng"),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile =
                    await PdfLSSDApi.generate(listLSSD, email, name);
                PdfApi.openFile(pdfFile);
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
          stream: lichSuSuDungBloc?.listIDLichSuSuDung,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildTable(snapshot);
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

  Widget _buildTable(AsyncSnapshot snapshot) {
    listLSSD = snapshot.data;
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 150,
        rightHandSideColumnWidth: 1950,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: snapshot.data.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
        verticalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.yellow,
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        horizontalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.red,
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        enablePullToRefresh: true,
        refreshIndicator: const WaterDropHeader(),
        refreshIndicatorHeight: 60,
        onRefresh: () async {
          //Do sth
          await Future.delayed(const Duration(milliseconds: 500));
          _hdtRefreshController.refreshCompleted();
        },
        htdRefreshController: _hdtRefreshController,
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Tên Tài Sản (${listLSSD.length.toString()})', 150,
          Alignment.centerLeft),
      _getTitleItemWidget('Phòng Ban', 150, Alignment.centerLeft),
      _getTitleItemWidget('Năm SX', 100, Alignment.center),
      _getTitleItemWidget('Nước SX', 100, Alignment.center),
      _getTitleItemWidget('Nhóm Tài Sản', 200, Alignment.center),
      _getTitleItemWidget('Tình Trạng', 150, Alignment.center),
      _getTitleItemWidget('Nguyên Giá', 150, Alignment.center),
      _getTitleItemWidget('Thời Gian SD (Tháng)', 100, Alignment.center),
      _getTitleItemWidget('Số Lượng', 100, Alignment.center),
      _getTitleItemWidget('Hợp Đồng', 200, Alignment.centerLeft),
      _getTitleItemWidget('Mục Đích SD', 200, Alignment.centerLeft),
      _getTitleItemWidget('Tên TK Cập Nhật', 200, Alignment.centerLeft),
      _getTitleItemWidget('Email TK Cập Nhật', 200, Alignment.centerLeft),
      _getTitleItemWidget('Thời Gian Cập Nhật', 100, Alignment.centerRight),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, Alignment alignment) {
    return Container(
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16.0)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: alignment,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text('(${(index + 1).toString()}) ' + listLSSD[index].Ten_ts!,
          style: TextStyle(fontSize: 14.0)),
      width: 150,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        _container(listLSSD[index].Ten_pb ?? "", 150, Alignment.centerLeft),
        _container(
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(listLSSD[index].Nam_sx ?? "")),
            100,
            Alignment.centerRight),
        _container(listLSSD[index].Nuoc_sx ?? "", 100, Alignment.center),
        _container(listLSSD[index].Ma_nts ?? "", 200, Alignment.center),
        _container(listLSSD[index].Ma_tinh_trang ?? "", 150, Alignment.center),
        _container(
            listLSSD[index].Nguyen_gia ?? "", 150, Alignment.centerRight),
        _container(listLSSD[index].Tg_sd ?? "", 100, Alignment.center),
        _container(listLSSD[index].So_luong ?? "", 100, Alignment.center),
        _container(listLSSD[index].So_hd ?? "", 200, Alignment.centerLeft),
        _container(listLSSD[index].Mdsd ?? "", 200, Alignment.centerLeft),
        _container(listLSSD[index].Name ?? "", 200, Alignment.centerLeft),
        _container(listLSSD[index].Email ?? "", 200, Alignment.centerLeft),
        _container(
            DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(listLSSD[index].Thgian ?? "")) +
                "\n" +
                DateFormat.Hms()
                    .format(DateTime.parse(listLSSD[index].Thgian ?? "")),
            100,
            Alignment.centerRight),
        //_container(listLSSD[index], ,  Alignment),
      ],
    );
  }

  Widget _container(String text, double width, Alignment alignment) {
    return Container(
      child: Text(
        text != null ? text : '',
        style: TextStyle(fontSize: 14.0),
      ),
      width: width,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: alignment,
    );
  }
}

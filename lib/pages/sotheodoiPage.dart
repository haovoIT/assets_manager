import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/diary_bloc.dart';
import 'package:assets_manager/bloc/diary_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_SoTheoDoiKhauHao.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/diary_model.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_diary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

class SoTheoDoiPage extends StatelessWidget {
  final String ma;
  const SoTheoDoiPage({Key? key, required this.ma}) : super(key: key);

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
              diaryBloc:
                 DiaryBloc(DbDiaryService(), _authenticationserver),
              uid: snapshot.data!,
              child: SoTheoDoiPages(
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

class SoTheoDoiPages extends StatefulWidget {
  final String ma;
  const SoTheoDoiPages({Key? key, required this.ma}) : super(key: key);

  @override
  _SoTheoDoiPagesState createState() => _SoTheoDoiPagesState();
}

class _SoTheoDoiPagesState extends State<SoTheoDoiPages> {
  DiaryBloc? diaryBloc;
  HDTRefreshController _hdtRefreshController = HDTRefreshController();
  List<DiaryModel> list = [];

  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    diaryBloc = DiaryBlocProvider.of(context)?.diaryBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    diaryBloc?.idAssetEditChanged.add(widget.ma + "|" + maPb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sổ Theo Dõi Khấu Hao"),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile = await PdfSTDKHApi.generate(list, email, name);
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
          stream: diaryBloc?.listDiaryModel,
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
    list = snapshot.data;
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 150,
        rightHandSideColumnWidth: 1300,
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
      _getTitleItemWidget(
          'Tên Tài Sản (${list.length.toString()})', 150, Alignment.centerLeft),
      _getTitleItemWidget('Nguyên Giá', 150, Alignment.center),
      _getTitleItemWidget('Thời Gian SD (Tháng)', 100, Alignment.center),
      _getTitleItemWidget('Ngày Bắt Đầu', 100, Alignment.centerLeft),
      _getTitleItemWidget('Ngày Kết Thúc', 100, Alignment.centerLeft),
      _getTitleItemWidget('Lý Do', 200, Alignment.centerLeft),
      _getTitleItemWidget('Mức Khấu Hao', 150, Alignment.centerLeft),
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
      child: Text('(${(index + 1).toString()}) ' + list[index].nameAsset!,
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
        _container(list[index].originalPrice ?? "", 150, Alignment.centerRight),
        _container(list[index].usedTime ?? "", 100, Alignment.center),
        _container(
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(list[index].starDate ?? "")),
            100,
            Alignment.centerLeft),
        _container(
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(list[index].endDate ?? "")),
            100,
            Alignment.centerLeft),
        _container(list[index].detail ?? "", 200, Alignment.centerLeft),
        _container(list[index].depreciation ?? "", 150, Alignment.centerRight),
        _container(list[index].userName ?? "", 200, Alignment.centerLeft),
        _container(list[index].userEmail ?? "", 200, Alignment.centerLeft),
        _container(
            DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(list[index].dateUpdate ?? "")) +
                "\n" +
                DateFormat.Hms()
                    .format(DateTime.parse(list[index].dateUpdate ?? "")),
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

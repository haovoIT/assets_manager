import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/services/db_asset.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_history_asset.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetsPageList extends StatelessWidget {
  final String maPB;

  const AssetsPageList({Key? key, required this.maPB}) : super(key: key);
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
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), DbHistoryAssetService(),
                  _authenticationserver),
              uid: snapshot.data!,
              child: AssetsPageLists(
                maPB: maPB,
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

class AssetsPageLists extends StatefulWidget {
  final String maPB;
  const AssetsPageLists({Key? key, required this.maPB}) : super(key: key);

  @override
  _AssetsPageListsState createState() => _AssetsPageListsState();
}

class _AssetsPageListsState extends State<AssetsPageLists> {
  HomeBloc? _homeBloc;
  String? _uid;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)!.homeBloc;
    _uid = HomeBlocProvider.of(context)!.uid;
    _homeBloc!.maPBEditChanged.add(widget.maPB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Tài Sản"),
      ),
      body: StreamBuilder(
          stream: _homeBloc!.listAssetsPB,
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
    return ListView.separated(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          String _title = snapshot.data[index].Ten_ts;
          String _subtilte = "NSX: " +
              DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(snapshot.data[index].Nam_sx)) +
              "\nTình Trạng: " +
              snapshot.data[index].Tinh_trang;
          return Card(
            child: ListTile(
              tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
              leading: Image.asset(
                "assets/images/img.png",
              )
              /*Column(
                children: <Widget>[
                  Text(
                    snapshot.data[index].Ma_nts,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.lightBlue),
                  ),
                  Text(snapshot.data[index].Ma_pb)
                ],
              )*/
              ,
              title: Text(
                _title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.blue),
              ),
              subtitle: Text(_subtilte),
              onTap: () {
                final TextStyle textStyle =
                    TextStyle(fontSize: 16.0, color: Colors.blue.shade500);
                String _title = snapshot.data[index].Ten_ts;
                String _subtilte = snapshot.data[index].Ten_pb;
                String _namsx = DateFormat.yMd()
                    .format(DateTime.parse(snapshot.data[index].Nam_sx));
                String _nuocsx = snapshot.data[index].Nuoc_sx;
                String _nts = snapshot.data[index].Ten_nts;
                String _tt = snapshot.data[index].Tinh_trang;
                String _ng = snapshot.data[index].Nguyen_gia;
                String _tg = snapshot.data[index].Tg_sd;
                String _sl = snapshot.data[index].So_luong;
                String _hd = snapshot.data[index].Ten_hd;
                String _md = snapshot.data[index].Mdsd;
                String _qr = snapshot.data[index].Ma_qr;
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Thẻ Tài Sản Chi Tiết',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        content: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                BarcodeWidget(
                                  data: _qr,
                                  barcode: Barcode.qrCode(),
                                  width: 200,
                                  height: 200,
                                  color: Colors.black,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.only(left: 40.0),
                                ),
                                Divider(
                                  color: Colors.green,
                                ),
                                Text("Tên tài sản: " + _title,
                                    style: textStyle),
                                Text("Phòng Ban: " + _subtilte,
                                    style: textStyle),
                                Text("Năm Sản Xuất: " + _namsx,
                                    style: textStyle),
                                Text("Nước Sản Xuất: " + _nuocsx,
                                    style: textStyle),
                                Text("Nhóm Tài Sản: " + _nts, style: textStyle),
                                Text("Tình Trạng: " + _tt, style: textStyle),
                                Text("Nguyên Giá: " + _ng, style: textStyle),
                                Text("Thời Gian SD: " + _tg, style: textStyle),
                                Text("Số Lượng: " + _sl, style: textStyle),
                                Text("Hợp Đồng: " + _hd, style: textStyle),
                                Text("Mục Đích SD: " + _md,
                                    textAlign: TextAlign.start,
                                    style: textStyle),
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Huỷ'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.white,
          );
        });
  }
}

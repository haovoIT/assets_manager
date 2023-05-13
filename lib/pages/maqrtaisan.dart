import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_DanhSachTaiSan.dart';
import 'package:assets_manager/inPDF/inPDF_ThongTinTaiSan.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/taisan.dart';
import 'package:assets_manager/pages/khauhaoPage.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_lichsusudung.dart';
import 'package:assets_manager/services/db_taisan.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TTTaiSans extends StatelessWidget {
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
              homeBloc: HomeBloc(
                  DbFirestoreService(), DbLSSDService(), _authenticationserver),
              uid: snapshot.data!,
              child: TTTaiSan(),
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

class TTTaiSan extends StatefulWidget {
  const TTTaiSan({Key? key}) : super(key: key);

  @override
  _TTTaiSanState createState() => _TTTaiSanState();
}

class _TTTaiSanState extends State<TTTaiSan> {
  HomeBloc? _homeBloc;
  int tongso = 0;
  List<Assets> listAsset = [];
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)?.homeBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    _homeBloc?.maPBEditChanged.add(maPb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông Tin Tài Sản"),
      ),
      body: StreamBuilder(
          stream: _homeBloc?.listAssets,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final pdfFile =
              await PdfDSTaiSanApi.generate(listAsset, email, name, "");
          PdfApi.openFile(pdfFile);
        },
        icon: Icon(Icons.outbox),
        label: Text("Xuất PDF"),
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    final TextStyle textStyle =
        TextStyle(fontSize: 16.0, color: Colors.blue.shade500);
    final TextStyle textStyleQR = TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.blue);

    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 500, crossAxisSpacing: 1, mainAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
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
        listAsset.add(snapshot.data[index]);
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          borderOnForeground: true,
          color: Colors.green.shade50,
          margin: EdgeInsets.all(8.0),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BarcodeWidget(
                  data: _qr,
                  barcode: Barcode.qrCode(),
                  width: 200,
                  height: 200,
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(10.0),
                ),
                Divider(),
                Text("Tên Tài Sản: " + _title,
                    textAlign: TextAlign.center, style: textStyleQR),
                Text("Phòng ban: " + _subtilte,
                    textAlign: TextAlign.center, style: textStyleQR),
                Text("Tình Trạng: " + _tt,
                    textAlign: TextAlign.center, style: textStyleQR),
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Thông Tin Tài Sản Chi Tiết',
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
                              Text("Tên tài sản: " + _title, style: textStyle),
                              Text("Phòng Ban: " + _subtilte, style: textStyle),
                              Text("Năm Sản Xuất: " + _namsx, style: textStyle),
                              Text("Nước Sản Xuất: " + _nuocsx,
                                  style: textStyle),
                              Text("Nhóm Tài Sản: " + _nts, style: textStyle),
                              Text("Tình Trạng: " + _tt, style: textStyle),
                              Text("Nguyên Giá: " + _ng, style: textStyle),
                              Text("Thời Gian SD: " + _tg, style: textStyle),
                              Text("Số Lượng: " + _sl, style: textStyle),
                              Text("Hợp Đồng: " + _hd, style: textStyle),
                              Text("Mục Đích SD: " + _md,
                                  textAlign: TextAlign.start, style: textStyle),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        Container(
                          height: 30,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.green,
                          ),
                          child: Center(
                              child: TextButton(
                            onPressed: () async {
                              final assets = Assets(
                                  documentID: snapshot.data[index].documentID,
                                  Ten_ts: snapshot.data[index].Ten_ts,
                                  Ten_pb: snapshot.data[index].Ten_pb,
                                  Ma_pb: snapshot.data[index].Ma_pb,
                                  Nam_sx: snapshot.data[index].Nam_sx,
                                  Nuoc_sx: snapshot.data[index].Nuoc_sx,
                                  Ten_nts: snapshot.data[index].Ten_nts,
                                  Tinh_trang: snapshot.data[index].Tinh_trang,
                                  Ma_qr: snapshot.data[index].Ma_qr,
                                  Tg_sd: snapshot.data[index].Tg_sd,
                                  So_luong: snapshot.data[index].So_luong,
                                  Ten_hd: snapshot.data[index].Ten_hd,
                                  Mdsd: snapshot.data[index].Mdsd,
                                  Nguyen_gia: snapshot.data[index].Nguyen_gia,
                                  Uid: snapshot.data[index].Uid);
                              final pdfFile = await PdfThongTinTSApi.generate(
                                  assets, email, name);
                              PdfApi.openFile(pdfFile);
                            },
                            child: Text(
                              'IN PDF',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )),
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.green,
                          ),
                          child: Center(
                              child: TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KhauHaoPage(
                                            ma: _qr,
                                            flag: 2,
                                          )));
                            },
                            child: Text(
                              'Khấu Hao',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )),
                        ),
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
    );
  }
}

import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/bloc/assets_edit_bloc_provider.dart';
import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_DanhSachTaiSan.dart';
import 'package:assets_manager/inPDF/inPDF_ThongTinTaiSan.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/taisan.dart';
import 'package:assets_manager/pages/assetsEditPage.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_lichsusudung.dart';
import 'package:assets_manager/services/db_sotheodoi.dart';
import 'package:assets_manager/services/db_taisan.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BienCoTaiSan extends StatelessWidget {
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
              child: BienCoTaiSans(),
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

class BienCoTaiSans extends StatefulWidget {
  const BienCoTaiSans({Key? key}) : super(key: key);

  @override
  _BienCoTaiSansState createState() => _BienCoTaiSansState();
}

class _BienCoTaiSansState extends State<BienCoTaiSans>
    with SingleTickerProviderStateMixin {
  HomeBloc? _homeBloc;
  late TabController _tabController;
  int tongso = 0;
  Assets assets = new Assets();
  List<Assets> listAsset = [];
  List<Assets> listAssetNSD = [];
  List<Assets> listAssetMM = [];
  List<Assets> listAssetHH = [];
  String? email = FirebaseAuth.instance.currentUser?.email;
  String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  String maPb = '';
  String name = '';
  int ngungSD = 0;
  int huhong = 0;
  int matmat = 0;
  int trangthai = 0;
  bool NSD = false;
  bool MM = false;
  bool HH = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)!.homeBloc;
    _homeBloc!.tinhtrangEditChanged.add("Ngừng Sử Dụng");
    maPb = displayName!.length > 20 ? displayName!.substring(0, 20) : '';
    name = displayName!.length > 20
        ? displayName!.substring(21, displayName!.length)
        : displayName!;
    _homeBloc?.maPBEditChanged.add(maPb);
  }

  void _addorEditAsset({required bool add, required Assets assets}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => AssetsEditBlocProvider(
                assetsEditBloc: AssetsEditBloc(
                  add: add,
                  dbApi: DbFirestoreService(),
                  dbLSSDApi: DbLSSDService(),
                  dbSTDApi: DbSoTheoDoiService(),
                  selectAsset: assets,
                ),
                child: EditAssets(flag: add),
              ),
          fullscreenDialog: true),
    );
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Danh Sách Tài Sản"),
        ),
        body: StreamBuilder(
            stream: _homeBloc!.listTTAssets,
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
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Thông Tin Tài Sản Chi Tiết',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    content: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  final pdfFile = await PdfDSTaiSanApi.generate(
                                      listAssetNSD,
                                      email ?? "",
                                      name,
                                      "Ngừng Sử Dụng");
                                  PdfApi.openFile(pdfFile);
                                },
                                child: Text(
                                  "Ngừng Sử dụng",
                                  style: TextStyle(color: Colors.black),
                                )),
                            TextButton(
                                onPressed: () async {
                                  final pdfFile = await PdfDSTaiSanApi.generate(
                                      listAssetMM,
                                      email ?? "",
                                      name,
                                      "Mất Mát");
                                  PdfApi.openFile(pdfFile);
                                },
                                child: Text("Mất Mát",
                                    style: TextStyle(color: Colors.black))),
                            TextButton(
                                onPressed: () async {
                                  final pdfFile = await PdfDSTaiSanApi.generate(
                                      listAssetHH,
                                      email ?? "",
                                      name,
                                      "Hư Hỏng");
                                  PdfApi.openFile(pdfFile);
                                },
                                child: Text("Hư Hỏng",
                                    style: TextStyle(color: Colors.black))),
                            TextButton(
                                onPressed: () async {
                                  final pdfFile = await PdfDSTaiSanApi.generate(
                                      listAsset, email ?? "", name, "Biến Cố");
                                  PdfApi.openFile(pdfFile);
                                },
                                child: Text("Tất cả",
                                    style: TextStyle(color: Colors.black))),
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
          icon: Icon(Icons.outbox),
          label: Text("Xuất PDF"),
        ),
        bottomNavigationBar: StreamBuilder(
          stream: _homeBloc?.tinhtrangEdit,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black38,
              tabs: [
                Tab(
                  icon: Icon(Icons.home_filled),
                  text: 'Ngừng Sử Dụng',
                ),
                Tab(
                  icon: Icon(Icons.assessment_outlined),
                  text: 'Mất Mát',
                ),
                Tab(
                  icon: Icon(Icons.apps_sharp),
                  text: 'Hư Hỏng',
                ),
              ],
              indicator: ShapeDecoration(
                  shape: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                          style: BorderStyle.solid)),
                  gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.green.shade100])),
              labelStyle: TextStyle(fontSize: 14, color: Colors.white),
              unselectedLabelStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  color: Colors.white),
              onTap: (_tab) {
                setState(() {
                  switch (_tab) {
                    case 0:
                      _homeBloc!.tinhtrangEditChanged.add("Ngừng Sử Dụng");
                      setState(() {
                        ngungSD += 1;
                        NSD = true;
                        MM = false;
                        HH = false;
                      });
                      break;
                    case 1:
                      _homeBloc!.tinhtrangEditChanged.add("Mất Mát");
                      setState(() {
                        NSD = false;
                        MM = true;
                        HH = false;
                        matmat += 1;
                      });
                      break;
                    case 2:
                      _homeBloc!.tinhtrangEditChanged.add("Hư Hỏng");
                      setState(() {
                        NSD = false;
                        MM = false;
                        HH = true;
                        huhong += 1;
                      });
                      break;
                  }
                });
              },
            );
          },
        ));
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    final TextStyle textStyle =
        TextStyle(fontSize: 16.0, color: Colors.blue.shade500);
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    return ListView.separated(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          String _title = snapshot.data[index].Ten_ts;
          String _subtilte = "NSX: " +
              DateFormat.yMd()
                  .format(DateTime.parse(snapshot.data[index].Nam_sx)) +
              "\t\t\tTình Trạng: " +
              snapshot.data[index].Tinh_trang;
          String _sub = snapshot.data[index].Ten_pb;
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
          if (ngungSD == 1 && _tt == "Ngừng Sử Dụng" && NSD == true) {
            listAssetNSD.add(snapshot.data[index]);
            listAsset.add(snapshot.data[index]);
          } else if (matmat == 1 && _tt == "Mất Mát" && MM == true) {
            listAssetMM.add(snapshot.data[index]);
            listAsset.add(snapshot.data[index]);
          } else if (huhong == 1 && _tt == "Hư Hỏng" && HH == true) {
            listAssetHH.add(snapshot.data[index]);
            listAsset.add(snapshot.data[index]);
          }
          return Card(
            child: ListTile(
              tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
              leading: Text(
                (index + 1).toString(),
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              title: Text(
                _title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.blue),
              ),
              subtitle: Text(_subtilte),
              onLongPress: () {
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
                                Text("Tên tài sản: " + _title,
                                    style: textStyle),
                                Text("Phòng Ban: " + _sub, style: textStyle),
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
              onTap: () {
                _addorEditAsset(
                  add: false,
                  assets: Assets(
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
                      Uid: snapshot.data[index].Uid),
                );
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

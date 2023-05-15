import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/bloc/assets_edit_bloc_provider.dart';
import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/models/taisan.dart';
import 'package:assets_manager/pages/chuyentaisanEditPage.dart';
import 'package:assets_manager/pages/khauhaoPage.dart';
import 'package:assets_manager/pages/lichsusudungPage.dart';
import 'package:assets_manager/pages/sotheodoiPage.dart';
import 'package:assets_manager/pages/xacnhanthanhly.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_lichsusudung.dart';
import 'package:assets_manager/services/db_sotheodoi.dart';
import 'package:assets_manager/services/db_taisan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'assetsEditPage.dart';

class AssetsPages extends StatelessWidget {
  final bool flag;

  const AssetsPages({Key? key, required this.flag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthenticationServer _authenticationServer =
        AuthenticationServer(context);
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationServer);
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
                  DbFirestoreService(), DbLSSDService(), _authenticationServer),
              uid: snapshot.data!,
              child: AssetsPage(
                flag: flag,
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

class AssetsPage extends StatefulWidget {
  final bool flag;
  const AssetsPage({Key? key, required this.flag}) : super(key: key);

  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  late HomeBloc _homeBloc;
  late String _uid;
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)!.homeBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    _homeBloc.maPBEditChanged.add(maPb);
    _uid = HomeBlocProvider.of(context)!.uid;
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

  void UpdateAsset({required bool add, required Assets assets}) {
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
                child: XacNhanThanhLy(),
              ),
          fullscreenDialog: true),
    );
  }

  Future<bool> _confirmDeleteAssets(String name) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Xóa Tài Sản",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Bạn có chắc chắn muốn xóa ' + name + ' không?',
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Huỷ')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  Future<bool> _confirmLSSD(String name) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Lịch Sử Sử Dụng",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            content: Text('Bạn có muốn xem lịch sử sử dụng của $name không?',
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Huỷ')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _homeBloc.listAssets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return widget.flag
                  ? _buildListViewSeparated(snapshot)
                  : _buildListView(snapshot);
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
          _addorEditAsset(
              add: true,
              assets: Assets(
                  documentID: '',
                  Ten_ts: '',
                  Ma_pb: '',
                  Ten_pb: '',
                  Nam_sx: '',
                  Nuoc_sx: '',
                  Ten_nts: '',
                  Tinh_trang: 'Đang Sử Dụng',
                  Tg_sd: '',
                  So_luong: '',
                  Ten_hd: '',
                  Mdsd: '',
                  Nguyen_gia: '',
                  Ma_qr: '',
                  Uid: _uid));
        },
        icon: Icon(Icons.add),
        label: Text('Tài sản'),
      ),
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
          return Dismissible(
            key: Key(snapshot.data[index].documentID),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.blue,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.history_edu_rounded,
                color: Colors.white,
              ),
            ),
            child: Card(
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
                onLongPress: () {
                  Assets assets = Assets(
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
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Chuyển Tài Sản",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Bạn muốn chuyển toàn bộ hay một phần số lượng tài sản.',
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.italic),
                          ),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      chuyenDoi(true, assets);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      child: Text("Toàn bộ"),
                                      color: Colors.blue.shade100,
                                      padding: EdgeInsets.all(10.0),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      chuyenDoi(false, assets);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        child: Text("Một Phần"),
                                        color: Colors.blue.shade100,
                                        padding: EdgeInsets.all(10.0))),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      child: Text(
                                        "Đóng",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                    )),
                              ],
                            )
                          ],
                        );
                      });
                },
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction.toString() == "DismissDirection.endToStart") {
                bool confirmLSSD = await _confirmLSSD(_title);
                if (confirmLSSD) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LichSuSuDungPage(
                                ma: snapshot.data[index].Ma_qr,
                              )));
                }
              } else if (direction.toString() ==
                  "DismissDirection.startToEnd") {
                bool confirmDelete = await _confirmDeleteAssets(_title);
                if (confirmDelete) {
                  _homeBloc.deleteAssets.add(snapshot.data[index]);
                }
              }
              return null;
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.white,
          );
        });
  }

  Widget _buildListView(AsyncSnapshot snapshot) {
    return ListView.separated(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          String _title = snapshot.data[index].Ten_ts;
          String _subtilte = "Nguyên Giá: " +
              snapshot.data[index].Nguyen_gia +
              "\nThời gian sử dụng: " +
              snapshot.data[index].Tg_sd;
          return Dismissible(
            key: Key(snapshot.data[index].documentID),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
                color: Colors.blue,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Xác Nhận Thanh Lý  "),
                    Icon(
                      Icons.outbond_rounded,
                      color: Colors.white,
                    ),
                  ],
                )),
            child: Card(
              child: ListTile(
                tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
                leading: Image.asset(
                  "assets/images/img.png",
                ),
                title: Text(
                  _title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.blue),
                ),
                subtitle: Text(_subtilte),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KhauHaoPage(
                                ma: snapshot.data[index].Ma_qr,
                                flag: 2,
                              )));
                },
                onLongPress: () {
                  /*Assets  assets= Assets(
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
                      Uid: snapshot.data[index].Uid);*/
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SoTheoDoiPage(
                                ma: snapshot.data[index].Ma_qr,
                              )));
                },
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction.toString() == "DismissDirection.endToStart") {
                UpdateAsset(
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
              } else if (direction.toString() ==
                  "DismissDirection.startToEnd") {
                bool confirmDelete = await _confirmDeleteAssets(_title);
                if (confirmDelete) {
                  _homeBloc.deleteAssets.add(snapshot.data[index]);
                }
              }

              return null;
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.white,
          );
        });
  }

  Future chuyenDoi(bool isFull, Assets assets) async {
    if (isFull) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AssetsEditBlocProvider(
                  assetsEditBloc: AssetsEditBloc(
                    add: true,
                    dbApi: DbFirestoreService(),
                    dbLSSDApi: DbLSSDService(),
                    dbSTDApi: DbSoTheoDoiService(),
                    selectAsset: assets,
                  ),
                  child: ChuyenDoiEditPage(
                    flag: true,
                    maQr: assets.Ma_qr ?? "",
                  ),
                ),
            fullscreenDialog: true),
      );
      _homeBloc.deleteAssets.add(assets);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AssetsEditBlocProvider(
                  assetsEditBloc: AssetsEditBloc(
                    add: false,
                    dbApi: DbFirestoreService(),
                    dbLSSDApi: DbLSSDService(),
                    dbSTDApi: DbSoTheoDoiService(),
                    selectAsset: assets,
                  ),
                  child: ChuyenDoiEditPage(
                    flag: false,
                    maQr: assets.Ma_qr ?? "",
                  ),
                ),
            fullscreenDialog: true),
      );
    }
  }
}

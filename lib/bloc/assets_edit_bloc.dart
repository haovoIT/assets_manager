import 'dart:async';

import 'package:assets_manager/models/lichsusudungtaisan.dart';
import 'package:assets_manager/models/sotheodoi.dart';
import 'package:assets_manager/models/taisan.dart';
import 'package:assets_manager/services/db_lichsusudung_api.dart';
import 'package:assets_manager/services/db_sotheodoi_api.dart';
import 'package:assets_manager/services/db_taisan_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssetsEditBloc {
  final DbApi dbApi;
  final DbLSSDApi dbLSSDApi;
  final DbSTDApi dbSTDApi;
  final bool add;
  Assets selectAsset;

  AssetsEditBloc(
      {required this.add,
      required this.dbApi,
      required this.dbLSSDApi,
      required this.dbSTDApi,
      required this.selectAsset}) {
    _startEditListeners().then((finished) => _getAssets(add, selectAsset));
  }

  String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  String maPb = '';
  String name = '';
  String? email = FirebaseAuth.instance.currentUser?.email;
  String? ngay_BD;
  String? ngay_KT;
  String? khauHao;

  final StreamController<String> _tenTsController =
      StreamController<String>.broadcast();
  Sink<String> get tenTsEditChanged => _tenTsController.sink;
  Stream<String> get tenTsEdit => _tenTsController.stream;

  final StreamController<String> _maPbController =
      StreamController<String>.broadcast();
  Sink<String> get maPbEditChanged => _maPbController.sink;
  Stream<String> get maPbEdit => _maPbController.stream;

  final StreamController<String> _tenPbController =
      StreamController<String>.broadcast();
  Sink<String> get tenPbEditChanged => _tenPbController.sink;
  Stream<String> get tenPbEdit => _tenPbController.stream;

  final StreamController<String> _namSXController =
      StreamController<String>.broadcast();
  Sink<String> get namSXEditChanged => _namSXController.sink;
  Stream<String> get namSXEdit => _namSXController.stream;

  final StreamController<String> _nuocSxController =
      StreamController<String>.broadcast();
  Sink<String> get nuocSxEditChanged => _nuocSxController.sink;
  Stream<String> get nuocSxEdit => _nuocSxController.stream;

  final StreamController<String> _ntsController =
      StreamController<String>.broadcast();
  Sink<String> get NtsEditChanged => _ntsController.sink;
  Stream<String> get NtsEdit => _ntsController.stream;

  final StreamController<String> _ngayBDController =
      StreamController<String>.broadcast();
  Sink<String> get ngayBDEditChanged => _ngayBDController.sink;
  Stream<String> get ngayBDEdit => _ngayBDController.stream;

  final StreamController<String> _ngayKTController =
      StreamController<String>.broadcast();
  Sink<String> get ngayKTEditChanged => _ngayKTController.sink;
  Stream<String> get ngayKTEdit => _ngayKTController.stream;

  final StreamController<String> _TinhTrangController =
      StreamController<String>.broadcast();
  Sink<String> get TinhTrangEditChanged => _TinhTrangController.sink;
  Stream<String> get TinhTrangEdit => _TinhTrangController.stream;

  final StreamController<String> _nguyenGiaController =
      StreamController<String>.broadcast();
  Sink<String> get nguyenGiaEditChanged => _nguyenGiaController.sink;
  Stream<String> get nguyenGiaEdit => _nguyenGiaController.stream;

  final StreamController<String> _tgSdController =
      StreamController<String>.broadcast();
  Sink<String> get tgSdEditChanged => _tgSdController.sink;
  Stream<String> get tgSdEdit => _tgSdController.stream;

  final StreamController<String> _soLuongController =
      StreamController<String>.broadcast();
  Sink<String> get soLuongEditChanged => _soLuongController.sink;
  Stream<String> get soLuongEdit => _soLuongController.stream;

  final StreamController<String> _tenHdController =
      StreamController<String>.broadcast();
  Sink<String> get tenHdEditChanged => _tenHdController.sink;
  Stream<String> get tenHdEdit => _tenHdController.stream;

  final StreamController<String> _mdsdController =
      StreamController<String>.broadcast();
  Sink<String> get mdsdEditChanged => _mdsdController.sink;
  Stream<String> get mdsdEdit => _mdsdController.stream;

  final StreamController<String> _maQrController =
      StreamController<String>.broadcast();
  Sink<String> get maQrEditChanged => _maQrController.sink;
  Stream<String> get maQrEdit => _maQrController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  final StreamController<String> _khauHaoController =
      StreamController<String>.broadcast();
  Sink<String> get khauHaoEditChanged => _khauHaoController.sink;
  Stream<String> get khauHaoEdit => _khauHaoController.stream;

  _startEditListeners() async {
    _tenTsController.stream.listen((tenTs) {
      selectAsset.Ten_ts = tenTs;
    });
    _maPbController.stream.listen((maPb) {
      selectAsset.Ma_pb = maPb;
    });
    _tenPbController.stream.listen((tenPb) {
      selectAsset.Ten_pb = tenPb;
    });
    _namSXController.stream.listen((namSx) {
      selectAsset.Nam_sx = namSx;
    });
    _nuocSxController.stream.listen((nuocSx) {
      selectAsset.Nuoc_sx = nuocSx;
    });
    _ntsController.stream.listen((nts) {
      selectAsset.Ten_nts = nts;
    });
    _ngayBDController.stream.listen((ngayBD) {
      ngay_BD = ngayBD;
    });
    _ngayKTController.stream.listen((ngayKT) {
      ngay_KT = ngayKT;
    });
    _TinhTrangController.stream.listen((TinhTrang) {
      selectAsset.Tinh_trang = TinhTrang;
    });
    _nguyenGiaController.stream.listen((nguyenGia) {
      selectAsset.Nguyen_gia = nguyenGia;
    });
    _tgSdController.stream.listen((tgSd) {
      selectAsset.Tg_sd = tgSd;
    });
    _soLuongController.stream.listen((soLuong) {
      selectAsset.So_luong = soLuong;
    });
    _tenHdController.stream.listen((Hd) {
      selectAsset.Ten_hd = Hd;
    });
    _mdsdController.stream.listen((mdsd) {
      selectAsset.Mdsd = mdsd;
    });
    _maQrController.stream.listen((maQr) {
      selectAsset.Ma_qr = maQr;
    });
    _khauHaoController.stream.listen((KH) {
      khauHao = KH;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveAssets();
      } else if (action == "Add") {
        _addAssets();
      }
    });
  }

  void _getAssets(bool add, Assets asset) {
    if (add) {
      selectAsset = Assets();
      selectAsset.Ten_ts = asset.Ten_ts;
      selectAsset.Ma_pb = asset.Ma_pb;
      selectAsset.Ten_pb = asset.Ten_pb;
      selectAsset.Nam_sx = DateTime.now().toString();
      selectAsset.Nuoc_sx = asset.Nuoc_sx;
      selectAsset.Ten_nts = asset.Ten_nts;
      selectAsset.Tinh_trang = asset.Tinh_trang;
      selectAsset.Nguyen_gia = asset.Nguyen_gia;
      selectAsset.Tg_sd = asset.Tg_sd;
      selectAsset.So_luong = asset.So_luong;
      selectAsset.Ten_hd = asset.Ten_hd;
      selectAsset.Mdsd = asset.Mdsd;
      selectAsset.Ma_qr = DateTime.now().toString();
      selectAsset.Uid = asset.Uid;
    } else {
      selectAsset.Ten_ts = asset.Ten_ts;
      selectAsset.Ma_pb = asset.Ma_pb;
      selectAsset.Ten_pb = asset.Ten_pb;
      selectAsset.Nam_sx = asset.Nam_sx;
      selectAsset.Nuoc_sx = asset.Nuoc_sx;
      selectAsset.Ten_nts = asset.Ten_nts;
      selectAsset.Tinh_trang = asset.Tinh_trang;
      selectAsset.Nguyen_gia = asset.Nguyen_gia;
      selectAsset.Tg_sd = asset.Tg_sd;
      selectAsset.So_luong = asset.So_luong;
      selectAsset.Ten_hd = asset.Ten_hd;
      selectAsset.Mdsd = asset.Mdsd;
      selectAsset.Ma_qr = asset.Ma_qr;
      selectAsset.Uid = asset.Uid;
    }
    tenTsEditChanged.add(selectAsset.Ten_ts ?? "");
    maPbEditChanged.add(selectAsset.Ma_pb ?? "");
    tenPbEditChanged.add(selectAsset.Ten_pb ?? "");
    namSXEditChanged.add(selectAsset.Nam_sx ?? "");
    nuocSxEditChanged.add(selectAsset.Nuoc_sx ?? "");
    NtsEditChanged.add(selectAsset.Ten_nts ?? "");
    TinhTrangEditChanged.add(selectAsset.Tinh_trang ?? "");
    nguyenGiaEditChanged.add(selectAsset.Nguyen_gia ?? "");
    tgSdEditChanged.add(selectAsset.Tg_sd ?? "");
    soLuongEditChanged.add(selectAsset.So_luong ?? "");
    tenHdEditChanged.add(selectAsset.Ten_hd ?? "");
    mdsdEditChanged.add(selectAsset.Mdsd ?? "");
    maQrEditChanged.add(selectAsset.Ma_qr ?? "");
  }

  void _saveAssets() {
    maPb = displayName!.length > 20 ? displayName!.substring(0, 20) : '';
    name = displayName!.length > 20
        ? displayName!.substring(21, displayName!.length)
        : displayName!;
    Assets assets = Assets(
      documentID: selectAsset.documentID,
      Ten_ts: selectAsset.Ten_ts,
      Ma_pb: selectAsset.Ma_pb,
      Ten_pb: selectAsset.Ten_pb,
      Nam_sx: selectAsset.Nam_sx,
      Nuoc_sx: selectAsset.Nuoc_sx,
      Ten_nts: selectAsset.Ten_nts,
      Tinh_trang: selectAsset.Tinh_trang,
      Nguyen_gia: selectAsset.Nguyen_gia,
      Tg_sd: selectAsset.Tg_sd,
      So_luong: selectAsset.So_luong,
      Ten_hd: selectAsset.Ten_hd,
      Mdsd: selectAsset.Mdsd,
      Ma_qr: selectAsset.Ma_qr,
      Uid: selectAsset.Uid,
    );
    LichSuSuDung lichSuSuDung = LichSuSuDung(
        documentID: selectAsset.Ma_qr,
        Ten_ts: selectAsset.Ten_ts,
        Ten_pb: selectAsset.Ten_pb,
        Nam_sx: selectAsset.Nam_sx,
        Nuoc_sx: selectAsset.Nuoc_sx,
        Ma_nts: selectAsset.Ten_nts,
        Ma_tinh_trang: selectAsset.Tinh_trang,
        Nguyen_gia: selectAsset.Nguyen_gia,
        Tg_sd: selectAsset.Tg_sd,
        So_luong: selectAsset.So_luong,
        So_hd: selectAsset.Ten_hd,
        Mdsd: selectAsset.Mdsd,
        Ma_qr: selectAsset.Ma_qr,
        Name: name,
        Email: email ?? "",
        Thgian: DateTime.now().toString());

    SoTheoDoi soTheoDoi = SoTheoDoi(
        Ma_qr: selectAsset.Ma_qr,
        Ten_ts: selectAsset.Ten_ts,
        Ma_pb: selectAsset.Ma_pb,
        Tg_sd: selectAsset.Tg_sd,
        Nguyen_gia: selectAsset.Nguyen_gia,
        Ngay_BD: ngay_BD ?? "",
        Ngay_KT: ngay_KT ?? "",
        Ly_do: "Thêm Mới",
        Khau_hao: khauHao ?? "",
        Name: name,
        Email: email ?? "",
        Thgian: DateTime.now().toString());

    if (add) {
      dbApi.addAssets(assets);
      dbSTDApi.addSoTheoDoi(soTheoDoi);
    } else {
      dbApi.updateAssetWithTransaction(assets);
    }
    dbLSSDApi.addLichSuSuDung(lichSuSuDung);
  }

  void _addAssets() {
    Assets assets = Assets(
      documentID: selectAsset.documentID,
      Ten_ts: selectAsset.Ten_ts,
      Ma_pb: selectAsset.Ma_pb,
      Ten_pb: selectAsset.Ten_pb,
      Nam_sx: selectAsset.Nam_sx,
      Nuoc_sx: selectAsset.Nuoc_sx,
      Ten_nts: selectAsset.Ten_nts,
      Tinh_trang: selectAsset.Tinh_trang,
      Nguyen_gia: selectAsset.Nguyen_gia,
      Tg_sd: selectAsset.Tg_sd,
      So_luong: selectAsset.So_luong,
      Ten_hd: selectAsset.Ten_hd,
      Mdsd: selectAsset.Mdsd,
      Ma_qr: selectAsset.Ma_qr,
      Uid: selectAsset.Uid,
    );
    dbApi.addAssets(assets);
  }

  void dispose() {
    _tenTsController.close();
    _maPbController.close();
    _namSXController.close();
    _nuocSxController.close();
    _ntsController.close();
    _TinhTrangController.close();
    _nguyenGiaController.close();
    _ngayBDController.close();
    _ngayKTController.close();
    _tgSdController.close();
    _soLuongController.close();
    _tenHdController.close();
    _mdsdController.close();
    _maQrController.close();
    _saveController.close();
    _khauHaoController.close();
    _tenPbController.close();
  }
}

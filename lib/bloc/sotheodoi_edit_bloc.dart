import 'dart:async';

import 'package:assets_manager/models/sotheodoi.dart';
import 'package:assets_manager/services/db_sotheodoi_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SoTheoDoiEditBloc {
  final DbSTDApi dbSTDApi;
  final bool add;
  SoTheoDoi selectSoTheoDoi;

  SoTheoDoiEditBloc(this.dbSTDApi, this.add, this.selectSoTheoDoi) {
    _startEditListeners()
        .then((finished) => _getSoTheoDoi(add, selectSoTheoDoi));
  }
  String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  String maPb = '';
  String name = '';
  String? email = FirebaseAuth.instance.currentUser?.email;

  final StreamController<String> _tenTsController =
      StreamController<String>.broadcast();
  Sink<String> get tenTsEditChanged => _tenTsController.sink;
  Stream<String> get tenTsEdit => _tenTsController.stream;

  final StreamController<String> _maPbController =
      StreamController<String>.broadcast();
  Sink<String> get maPbEditChanged => _maPbController.sink;
  Stream<String> get maPbEdit => _maPbController.stream;

  final StreamController<String> _nguyenGiaController =
      StreamController<String>.broadcast();
  Sink<String> get nguyenGiaEditChanged => _nguyenGiaController.sink;
  Stream<String> get nguyenGiaEdit => _nguyenGiaController.stream;

  final StreamController<String> _tgSdController =
      StreamController<String>.broadcast();
  Sink<String> get tgSdEditChanged => _tgSdController.sink;
  Stream<String> get tgSdEdit => _tgSdController.stream;

  final StreamController<String> _ngayBDController =
      StreamController<String>.broadcast();
  Sink<String> get ngayBDEditChanged => _ngayBDController.sink;
  Stream<String> get ngayBDEdit => _ngayBDController.stream;

  final StreamController<String> _ngayKTController =
      StreamController<String>.broadcast();
  Sink<String> get ngayKTEditChanged => _ngayKTController.sink;
  Stream<String> get ngayKTEdit => _ngayKTController.stream;

  final StreamController<String> _maQrController =
      StreamController<String>.broadcast();
  Sink<String> get maQrEditChanged => _maQrController.sink;
  Stream<String> get maQrEdit => _maQrController.stream;

  final StreamController<String> _lyDoController =
      StreamController<String>.broadcast();
  Sink<String> get lyDoEditChanged => _lyDoController.sink;
  Stream<String> get lyDoEdit => _lyDoController.stream;

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
      selectSoTheoDoi.Ten_ts = tenTs;
    });
    _maPbController.stream.listen((maPb) {
      selectSoTheoDoi.Ma_pb = maPb;
    });

    _nguyenGiaController.stream.listen((nguyenGia) {
      selectSoTheoDoi.Nguyen_gia = nguyenGia;
    });
    _tgSdController.stream.listen((tgSd) {
      selectSoTheoDoi.Tg_sd = tgSd;
    });

    _ngayBDController.stream.listen((ngayBD) {
      selectSoTheoDoi.Ngay_BD = ngayBD;
    });
    _ngayKTController.stream.listen((ngayKT) {
      selectSoTheoDoi.Ngay_KT = ngayKT;
    });

    _khauHaoController.stream.listen((khauHao) {
      selectSoTheoDoi.Khau_hao = khauHao;
    });

    _maQrController.stream.listen((maQr) {
      selectSoTheoDoi.Ma_qr = maQr;
    });

    _lyDoController.stream.listen((lyDo) {
      selectSoTheoDoi.Ly_do = lyDo;
    });

    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveSoTheoDoi();
      }
    });
  }

  void _getSoTheoDoi(bool add, SoTheoDoi soTheoDoi) {
    if (add) {
      selectSoTheoDoi = SoTheoDoi();
      selectSoTheoDoi.Ma_qr = soTheoDoi.Ma_qr;
      selectSoTheoDoi.Ten_ts = soTheoDoi.Ten_ts;
      selectSoTheoDoi.Ma_pb = soTheoDoi.Ma_pb;
      selectSoTheoDoi.Tg_sd = soTheoDoi.Tg_sd;
      selectSoTheoDoi.Nguyen_gia = soTheoDoi.Nguyen_gia;
      selectSoTheoDoi.Ngay_BD = soTheoDoi.Ngay_BD;
      selectSoTheoDoi.Ngay_KT = soTheoDoi.Ngay_KT;
      selectSoTheoDoi.Khau_hao = soTheoDoi.Khau_hao;
      selectSoTheoDoi.Ly_do = soTheoDoi.Ly_do;
      selectSoTheoDoi.Name = selectSoTheoDoi.Name;
      selectSoTheoDoi.Email = selectSoTheoDoi.Email;
      selectSoTheoDoi.Thgian = soTheoDoi.Thgian;
    }
    tenTsEditChanged.add(selectSoTheoDoi.Ten_ts ?? "");
    maPbEditChanged.add(selectSoTheoDoi.Ma_pb ?? "");
    nguyenGiaEditChanged.add(selectSoTheoDoi.Nguyen_gia ?? "");
    tgSdEditChanged.add(selectSoTheoDoi.Tg_sd ?? "");
    ngayBDEditChanged.add(selectSoTheoDoi.Ngay_BD ?? "");
    ngayKTEditChanged.add(selectSoTheoDoi.Ngay_KT ?? "");
    khauHaoEditChanged.add(selectSoTheoDoi.Khau_hao ?? "");
    maQrEditChanged.add(selectSoTheoDoi.Ma_qr ?? "");
    lyDoEditChanged.add(selectSoTheoDoi.Ly_do ?? "");
  }

  void _saveSoTheoDoi() {
    maPb = displayName!.length > 20 ? displayName!.substring(0, 20) : '';
    name = displayName!.length > 20
        ? displayName!.substring(21, displayName!.length)
        : displayName!;
    SoTheoDoi soTheoDoi = SoTheoDoi(
        Ma_qr: selectSoTheoDoi.Ma_qr,
        Ten_ts: selectSoTheoDoi.Ten_ts,
        Ma_pb: selectSoTheoDoi.Ma_pb,
        Tg_sd: selectSoTheoDoi.Tg_sd,
        Nguyen_gia: selectSoTheoDoi.Nguyen_gia,
        Ngay_BD: selectSoTheoDoi.Ngay_BD,
        Ngay_KT: selectSoTheoDoi.Ngay_KT,
        Khau_hao: selectSoTheoDoi.Khau_hao,
        Ly_do: selectSoTheoDoi.Ly_do,
        Name: name,
        Email: email ?? "",
        Thgian: DateTime.now().toString());
    dbSTDApi.addSoTheoDoi(soTheoDoi);
  }

  void dispose() {
    _tenTsController.close();
    _maPbController.close();
    _nguyenGiaController.close();
    _tgSdController.close();
    _khauHaoController.close();
    _ngayBDController.close();
    _ngayKTController.close();
    _maQrController.close();
    _saveController.close();
    _lyDoController.close();
  }
}

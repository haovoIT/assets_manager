import 'dart:async';

import 'package:assets_manager/models/hopdong.dart';
import 'package:assets_manager/services/db_hopdong_api.dart';

class ContractEditBloc {
  final DbCtApi dbCtApi;
  final bool add;
  Contract selectContract;

  ContractEditBloc({
    required this.add,
    required this.dbCtApi,
    required this.selectContract,
  }) {
    _startEditListeners().then((finished) => _getContract(add, selectContract));
  }

  final StreamController<String> _soHDController =
      StreamController<String>.broadcast();
  Sink<String> get soHDEditChanged => _soHDController.sink;
  Stream<String> get soHDEdit => _soHDController.stream;

  final StreamController<String> _tenHDController =
      StreamController<String>.broadcast();
  Sink<String> get tenHDEditChanged => _tenHDController.sink;
  Stream<String> get tenHDEdit => _tenHDController.stream;

  final StreamController<String> _ngayKyController =
      StreamController<String>.broadcast();
  Sink<String> get ngayKyEditChanged => _ngayKyController.sink;
  Stream<String> get ngayKyEdit => _ngayKyController.stream;

  final StreamController<String> _nHHController =
      StreamController<String>.broadcast();
  Sink<String> get nHHEditChanged => _nHHController.sink;
  Stream<String> get nHHEdit => _nHHController.stream;

  final StreamController<String> _nCCController =
      StreamController<String>.broadcast();
  Sink<String> get nCCEditChanged => _nCCController.sink;
  Stream<String> get nCCEdit => _nCCController.stream;

  final StreamController<String> _ndController =
      StreamController<String>.broadcast();
  Sink<String> get ndEditChanged => _ndController.sink;
  Stream<String> get ndEdit => _ndController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  _startEditListeners() async {
    _soHDController.stream.listen((soHD) {
      selectContract.SoHD = soHD;
    });
    _tenHDController.stream.listen((tenHD) {
      selectContract.TenHD = tenHD;
    });
    _ngayKyController.stream.listen((ngayKy) {
      selectContract.NgayKy = ngayKy;
    });

    _nHHController.stream.listen((nHH) {
      selectContract.NHH = nHH;
    });

    _nCCController.stream.listen((nCC) {
      selectContract.NCC = nCC;
    });

    _ndController.stream.listen((nd) {
      selectContract.ND = nd;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveContract();
      }
    });
  }

  void _getContract(bool add, Contract contract) {
    if (add) {
      selectContract = Contract();
      selectContract.SoHD = '';
      selectContract.TenHD = '';
      selectContract.NgayKy = DateTime.now().toString();
      selectContract.NHH = DateTime.now().toString();
      selectContract.NCC = '';
      selectContract.ND = '';
    } else {
      selectContract.SoHD = contract.SoHD;
      selectContract.TenHD = contract.TenHD;
      selectContract.NgayKy = contract.NgayKy;
      selectContract.NHH = contract.NHH;
      selectContract.NCC = contract.NCC;
      selectContract.ND = contract.ND;
    }
    soHDEditChanged.add(selectContract.SoHD ?? "");
    tenHDEditChanged.add(selectContract.TenHD ?? "");
    ngayKyEditChanged.add(selectContract.NgayKy ?? "");
    nHHEditChanged.add(selectContract.NHH ?? "");
    nCCEditChanged.add(selectContract.NCC ?? "");
    ndEditChanged.add(selectContract.ND ?? "");
  }

  void _saveContract() {
    Contract contract = Contract(
      documentID: selectContract.documentID,
      SoHD: selectContract.SoHD,
      TenHD: selectContract.TenHD,
      NgayKy: selectContract.NgayKy,
      NHH: selectContract.NHH,
      NCC: selectContract.NCC,
      ND: selectContract.ND,
    );
    add ? dbCtApi.addContract(contract) : dbCtApi.updateContract(contract);
  }

  void dispose() {
    _soHDController.close();
    _tenHDController.close();
    _ngayKyController.close();
    _nHHController.close();
    _nCCController.close();
    _ndController.close();
    _saveController.close();
  }
}

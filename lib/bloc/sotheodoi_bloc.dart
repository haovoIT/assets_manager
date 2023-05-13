import 'dart:async';

import 'package:assets_manager/models/sotheodoi.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_sotheodoi_api.dart';

class SoTheoDoiBloc {
  final DbSTDApi dbSTDApi;
  final AuthenticationApi authenticationApi;

  SoTheoDoiBloc(this.dbSTDApi, this.authenticationApi) {
    _starListeners();
  }

  final StreamController<String> _maQRController =
      StreamController<String>.broadcast();
  Sink<String> get maQREditChanged => _maQRController.sink;
  Stream<String> get maQREdit => _maQRController.stream;

  final StreamController<String> _maPbController =
      StreamController<String>.broadcast();
  Sink<String> get maPbEditChanged => _maPbController.sink;
  Stream<String> get maPbEdit => _maPbController.stream;

  final StreamController<List<SoTheoDoi>> _soTheoDoiTSController =
      StreamController<List<SoTheoDoi>>.broadcast();
  Sink<List<SoTheoDoi>> get _addListSTD => _soTheoDoiTSController.sink;
  Stream<List<SoTheoDoi>> get listSTD => _soTheoDoiTSController.stream;

  void _starListeners() {
    _maQRController.stream.listen((maTs) {
      dbSTDApi
          .getSoTheoDoiList(
              maTs.substring(0, 26), maTs.substring(27, maTs.length))
          .listen((std) {
        _addListSTD.add(std);
      });
    });
  }

  void dispose() {
    _maQRController.close();
    _maPbController.close();
    _soTheoDoiTSController.close();
  }
}

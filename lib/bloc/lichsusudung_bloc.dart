import 'dart:async';

import 'package:assets_manager/models/lichsusudungtaisan.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_lichsusudung_api.dart';

class LichSuSuDungBloc {
  final DbLSSDApi dbLSSDApi;
  final AuthenticationApi authenticationApi;

  LichSuSuDungBloc(this.dbLSSDApi, this.authenticationApi) {
    _starListeners();
  }

  final StreamController<String> _maController =
      StreamController<String>.broadcast();
  Sink<String> get maEditChanged => _maController.sink;
  Stream<String> get maEdit => _maController.stream;

  final StreamController<List<LichSuSuDung>> _lichSuSuDungIDController =
      StreamController<List<LichSuSuDung>>.broadcast();
  Sink<List<LichSuSuDung>> get addListIDLichSuSuDung =>
      _lichSuSuDungIDController.sink;
  Stream<List<LichSuSuDung>> get listIDLichSuSuDung =>
      _lichSuSuDungIDController.stream;

  void _starListeners() {
    _maController.stream.listen((ma) {
      dbLSSDApi.getLichSuSuDung(ma).listen((lichSuSuDung) {
        addListIDLichSuSuDung.add(lichSuSuDung);
      });
    });
  }

  void dispose() {
    _maController.close();
    _lichSuSuDungIDController.close();
  }
}

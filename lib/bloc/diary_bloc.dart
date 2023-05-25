import 'dart:async';

import 'package:assets_manager/models/diary_model.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_diary_api.dart';

class DiaryBloc {
  final DbDiaryApi dbDiaryApi;
  final AuthenticationApi authenticationApi;

  DiaryBloc(this.dbDiaryApi, this.authenticationApi) {
    _starListeners();
  }

  final StreamController<String> _idAssetController =
      StreamController<String>.broadcast();
  Sink<String> get idAssetEditChanged => _idAssetController.sink;
  Stream<String> get idAssetEdit => _idAssetController.stream;

  final StreamController<String> _idDepartmentController =
      StreamController<String>.broadcast();
  Sink<String> get maPbEditChanged => _idDepartmentController.sink;
  Stream<String> get maPbEdit => _idDepartmentController.stream;

  final StreamController<List<DiaryModel>> _listDiaryController =
      StreamController<List<DiaryModel>>.broadcast();
  Sink<List<DiaryModel>> get addListDiary => _listDiaryController.sink;
  Stream<List<DiaryModel>> get listDiaryModel => _listDiaryController.stream;

  void _starListeners() {
    _idAssetController.stream.listen((idAsset) {
      dbDiaryApi.getDiaryList(idAsset).listen((diary) {
        addListDiary.add(diary);
      });
    });
  }

  void dispose() {
    _idAssetController.close();
    _idDepartmentController.close();
    _listDiaryController.close();
  }
}

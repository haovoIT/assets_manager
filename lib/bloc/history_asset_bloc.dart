import 'dart:async';

import 'package:assets_manager/models/history_asset_model.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_history_asset_api.dart';

class HistoryAssetBloc {
  final DbHistoryAssetApi dbHistoryAssetApi;
  final AuthenticationApi authenticationApi;

  HistoryAssetBloc(this.dbHistoryAssetApi, this.authenticationApi) {
    _starListeners();
  }

  final StreamController<String> _qrCodeController =
      StreamController<String>.broadcast();
  Sink<String> get qrCodeEditChanged => _qrCodeController.sink;
  Stream<String> get qrCodeEdit => _qrCodeController.stream;

  final StreamController<List<HistoryAssetModel>> _historyAssetIDController =
      StreamController<List<HistoryAssetModel>>.broadcast();
  Sink<List<HistoryAssetModel>> get addListIDHistoryAsset =>
      _historyAssetIDController.sink;
  Stream<List<HistoryAssetModel>> get listIDHistoryAsset =>
      _historyAssetIDController.stream;

  void _starListeners() {
    _qrCodeController.stream.listen((qrCode) {
      dbHistoryAssetApi.getHistoryAsset(qrCode).listen((lichSuSuDung) {
        addListIDHistoryAsset.add(lichSuSuDung);
      });
    });
  }

  void dispose() {
    _qrCodeController.close();
    _historyAssetIDController.close();
  }
}

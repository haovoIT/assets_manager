import 'package:assets_manager/models/history_asset_model.dart';

abstract class DbHistoryAssetApi {
  Stream<List<HistoryAssetModel>> getHistoryAsset(String idAsset);
  Future<String> addHistoryAsset(HistoryAssetModel historyAssetModel);
}

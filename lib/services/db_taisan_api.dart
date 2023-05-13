import 'package:assets_manager/models/taisan.dart';

abstract class DbApi{
  Stream<List<Assets>> getAssetsList(String maPb);
  Stream<List<Assets>> getAssetsListKhauHao();
  Stream<List<Assets>> getAssetsPB(String maPB);
  Stream<List<Assets>> getAssetsID(String maPb, String id);
  Stream<List<Assets>> getAssetsTinhTrang(String maPb,String tinhtrang);
  Future<Assets> getAssets(String mats);
  Future<bool> addAssets( Assets assets);
  void updateAsset(Assets assets);
  void updateAssetWithTransaction(Assets assets);
  void deleteAsset(Assets assets);
}
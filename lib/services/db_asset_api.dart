import 'package:assets_manager/models/asset_model.dart';

abstract class DbApi {
  Stream<List<AssetsModel>> getAssetsList({required idDepartment});
  Stream<List<AssetsModel>> getAssetsListKhauHao();
  Stream<List<AssetsModel>> getAssetsOfDepartment(
      {required String idDepartment});
  Stream<List<AssetsModel>> getAssetsID(
      {required String idDepartment, required String id});
  Stream<List<AssetsModel>> getAssetsStatus(
      {required String idDepartment, required String status});
  Future<AssetsModel> getAssets({required String documentID});
  Future<String> addAssets({required AssetsModel assets});
  Future<String> updateAsset({required AssetsModel assets});
  Future<String> updateAssetWithTransaction({required AssetsModel assets});
  void deleteAsset({required AssetsModel assets});
}

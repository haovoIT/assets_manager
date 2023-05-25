import 'package:assets_manager/models/history_asset_model.dart';
import 'package:assets_manager/services/db_history_asset_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbHistoryAssetService implements DbHistoryAssetApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionAssets = 'db_history_asset_manager';

  DbHistoryAssetService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<List<HistoryAssetModel>> getHistoryAsset(String qrCode) {
    return _firestore
        .collection(_collectionAssets)
        .where("qrCode", isEqualTo: qrCode)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<HistoryAssetModel> _lichSuSuDungDocs =
          snapshot.docs.map((doc) => HistoryAssetModel.fromDoc(doc)).toList();
      _lichSuSuDungDocs.sort(
          (comp1, comp2) => comp1.dateUpdate!.compareTo(comp2.dateUpdate!));
      return _lichSuSuDungDocs;
    });
  }

  Future<String> addHistoryAsset(HistoryAssetModel historyAssetModel) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionAssets).add({
      'nameAsset': historyAssetModel.nameAsset,
      'idAsset': historyAssetModel.idAsset,
      'idDepartment': historyAssetModel.idDepartment,
      'departmentName': historyAssetModel.departmentName,
      'yearOfManufacture': historyAssetModel.yearOfManufacture,
      'producingCountry': historyAssetModel.producingCountry,
      'assetGroupName': historyAssetModel.assetGroupName,
      'status': historyAssetModel.status,
      'originalPrice': historyAssetModel.originalPrice,
      'usedTime': historyAssetModel.usedTime,
      'amount': historyAssetModel.amount,
      'contractName': historyAssetModel.contractName,
      'purposeOfUsing': historyAssetModel.purposeOfUsing,
      'qrCode': historyAssetModel.qrCode,
      'userId': historyAssetModel.userId,
      'starDate': historyAssetModel.starDate,
      'endDate': historyAssetModel.endDate,
      'depreciation': historyAssetModel.depreciation,
      'dateCreate': historyAssetModel.dateCreate,
      'userName': historyAssetModel.userName,
      'userEmail': historyAssetModel.userEmail,
      'dateUpdate': historyAssetModel.dateUpdate
    });
    return _documentReference.id;
  }
}

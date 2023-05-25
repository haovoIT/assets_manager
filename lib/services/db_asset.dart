import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/services/db_asset_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../component/index.dart';

class DbFirestoreService implements DbApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionAssets = 'db_asset_manager';

  DbFirestoreService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<List<AssetsModel>> getAssetsList({required idDepartment}) {
    return _firestore
        .collection(_collectionAssets)
        .where("idDepartment", isEqualTo: idDepartment)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.nameAsset!.compareTo(comp2.nameAsset!));
      return _assetsDocs;
    });
  }

  Stream<List<AssetsModel>> getAssetsListKhauHao() {
    return _firestore
        .collection(_collectionAssets)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp2.qrCode!.compareTo(comp1.qrCode!));
      return _assetsDocs;
    });
  }

  Stream<List<AssetsModel>> getAssetsID(
      {required String idDepartment, required String id}) {
    return _firestore
        .collection(_collectionAssets)
        .where("idDepartment", isEqualTo: idDepartment)
        .where("qrCode", isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.nameAsset!.compareTo(comp2.nameAsset!));
      return _assetsDocs;
    });
  }

  Stream<List<AssetsModel>> getAssetsStatus(
      {required String idDepartment, required String status}) {
    return _firestore
        .collection(_collectionAssets)
        .where("idDepartment", isEqualTo: idDepartment)
        .where("status", isEqualTo: status)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.nameAsset!.compareTo(comp2.nameAsset!));
      return _assetsDocs;
    });
  }

  Stream<List<AssetsModel>> getAssetsOfDepartment(
      {required String idDepartment}) {
    return _firestore
        .collection(_collectionAssets)
        .where("idDepartment", isEqualTo: idDepartment)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.nameAsset!.compareTo(comp2.nameAsset!));
      return _assetsDocs;
    });
  }

  @override
  Future<AssetsModel> getAssets({required String documentID}) {
    // TODO: implement getJournal
    throw UnimplementedError();
  }

  Future<String> addAssets({required AssetsModel assets}) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionAssets).add({
      'nameAsset': assets.nameAsset,
      'idDepartment': assets.idDepartment,
      'departmentName': assets.departmentName,
      'yearOfManufacture': assets.yearOfManufacture,
      'producingCountry': assets.producingCountry,
      'assetGroupName': assets.assetGroupName,
      'status': assets.status,
      'originalPrice': assets.originalPrice,
      'usedTime': assets.usedTime,
      'amount': assets.amount,
      'contractName': assets.contractName,
      'purposeOfUsing': assets.purposeOfUsing,
      'qrCode': assets.qrCode,
      'userId': assets.userId,
      'starDate': assets.starDate,
      'endDate': assets.endDate,
      'depreciation': assets.depreciation,
      'dateCreate': assets.dateCreate,
    });
    return _documentReference.id;
  }

  Future<String> updateAsset({required AssetsModel assets}) async {
    String response = DomainProvider.SUCCESS;
    await _firestore
        .collection(_collectionAssets)
        .doc(assets.documentID)
        .update({
      'nameAsset': assets.nameAsset,
      'idDepartment': assets.idDepartment,
      'departmentName': assets.departmentName,
      'yearOfManufacture': assets.yearOfManufacture,
      'producingCountry': assets.producingCountry,
      'assetGroupName': assets.assetGroupName,
      'status': assets.status,
      'originalPrice': assets.originalPrice,
      'usedTime': assets.usedTime,
      'amount': assets.amount,
      'contractName': assets.contractName,
      'purposeOfUsing': assets.purposeOfUsing,
      'qrCode': assets.qrCode,
      'userId': assets.userId,
      'starDate': assets.starDate,
      'endDate': assets.endDate,
      'depreciation': assets.depreciation,
      'dateCreate': assets.dateCreate,
    }).catchError((error) {
      print('Error updating $error');
      response = DomainProvider.ERROR;
    });
    return response;
  }

  @override
  Future<String> updateAssetWithTransaction(
      {required AssetsModel assets}) async {
    String response = DomainProvider.SUCCESS;
    await _firestore.collection(_collectionAssets).doc(assets.documentID).set({
      'nameAsset': assets.nameAsset,
      'idDepartment': assets.idDepartment,
      'departmentName': assets.departmentName,
      'yearOfManufacture': assets.yearOfManufacture,
      'producingCountry': assets.producingCountry,
      'assetGroupName': assets.assetGroupName,
      'status': assets.status,
      'originalPrice': assets.originalPrice,
      'usedTime': assets.usedTime,
      'amount': assets.amount,
      'contractName': assets.contractName,
      'purposeOfUsing': assets.purposeOfUsing,
      'qrCode': assets.qrCode,
      'userId': assets.userId,
      'starDate': assets.starDate,
      'endDate': assets.endDate,
      'depreciation': assets.depreciation,
      'dateCreate': assets.dateCreate,
    }).catchError((error) {
      print('Error updating $error');
      response = DomainProvider.ERROR;
    });
    return response;
  }

  void deleteAsset({required AssetsModel assets}) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(assets.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}

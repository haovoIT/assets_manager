import 'package:assets_manager/models/taisan.dart';
import 'package:assets_manager/services/db_taisan_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbFirestoreService implements DbApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionAssets = 'TaiSan';

  DbFirestoreService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<List<Assets>> getAssetsList(String maPb) {
    return _firestore
        .collection(_collectionAssets)
        .where("Ma_pb", isEqualTo: maPb)
        .where("Tinh_trang", isNotEqualTo: 'Đã Thanh Lý')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Assets> _assetsDocs =
          snapshot.docs.map((doc) => Assets.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.Ten_ts!.compareTo(comp2.Ten_ts!));
      return _assetsDocs;
    });
  }

  Stream<List<Assets>> getAssetsListKhauHao() {
    return _firestore
        .collection(_collectionAssets)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Assets> _assetsDocs =
          snapshot.docs.map((doc) => Assets.fromDoc(doc)).toList();
      _assetsDocs.sort((comp1, comp2) => comp2.Ma_qr!.compareTo(comp1.Ma_qr!));
      return _assetsDocs;
    });
  }

  Stream<List<Assets>> getAssetsID(String maPb, String id) {
    return _firestore
        .collection(_collectionAssets)
        .where("Ma_pb", isEqualTo: maPb)
        .where("Ma_qr", isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Assets> _assetsDocs =
          snapshot.docs.map((doc) => Assets.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.Ten_ts!.compareTo(comp2.Ten_ts!));
      return _assetsDocs;
    });
  }

  Stream<List<Assets>> getAssetsTinhTrang(String maPb, String tinhtrang) {
    print("1    $maPb,$tinhtrang");
    return _firestore
        .collection(_collectionAssets)
        .where("Ma_pb", isEqualTo: maPb)
        .where("Tinh_trang", isEqualTo: tinhtrang)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Assets> _assetsDocs =
          snapshot.docs.map((doc) => Assets.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.Ten_ts!.compareTo(comp2.Ten_ts!));
      return _assetsDocs;
    });
  }

  Stream<List<Assets>> getAssetsPB(String maPB) {
    return _firestore
        .collection(_collectionAssets)
        .where("Ma_pb", isEqualTo: maPB)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Assets> _assetsDocs =
          snapshot.docs.map((doc) => Assets.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.Ten_ts!.compareTo(comp2.Ten_ts!));
      return _assetsDocs;
    });
  }

  @override
  Future<Assets> getAssets(String mats) {
    // TODO: implement getJournal
    throw UnimplementedError();
  }

  Future<bool> addAssets(Assets assets) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionAssets).add({
      'Ten_ts': assets.Ten_ts,
      'Ma_pb': assets.Ma_pb,
      'Ten_pb': assets.Ten_pb,
      'Nam_sx': assets.Nam_sx,
      'Nuoc_sx': assets.Nuoc_sx,
      'Ten_nts': assets.Ten_nts,
      'Tinh_trang': assets.Tinh_trang,
      'Nguyen_gia': assets.Nguyen_gia,
      'Tg_sd': assets.Tg_sd,
      'So_luong': assets.So_luong,
      'Ten_hd': assets.Ten_hd,
      'Mdsd': assets.Mdsd,
      'Ma_qr': assets.Ma_qr,
      'Uid': assets.Uid
    });
    return _documentReference.id != null;
  }

  void updateAsset(Assets assets) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(assets.documentID)
        .update({
      'Ten_ts': assets.Ten_ts,
      'Ma_pb': assets.Ma_pb,
      'Ten_pb': assets.Ten_pb,
      'Nam_sx': assets.Nam_sx,
      'Nuoc_sx': assets.Nuoc_sx,
      'Ten_nts': assets.Ten_nts,
      'Tinh_trang': assets.Tinh_trang,
      'Nguyen_gia': assets.Nguyen_gia,
      'Tg_sd': assets.Tg_sd,
      'So_luong': assets.So_luong,
      'Ten_hd': assets.Ten_hd,
      'Mdsd': assets.Mdsd,
      'Ma_qr': assets.Ma_qr,
      'Uid': assets.Uid
    }).catchError((error) => print('Error updating $error'));
  }

  @override
  void updateAssetWithTransaction(Assets assets) async {
    await _firestore.collection(_collectionAssets).doc(assets.documentID).set({
      'Ten_ts': assets.Ten_ts,
      'Ma_pb': assets.Ma_pb,
      'Ten_pb': assets.Ten_pb,
      'Nam_sx': assets.Nam_sx,
      'Nuoc_sx': assets.Nuoc_sx,
      'Ten_nts': assets.Ten_nts,
      'Tinh_trang': assets.Tinh_trang,
      'Nguyen_gia': assets.Nguyen_gia,
      'Tg_sd': assets.Tg_sd,
      'So_luong': assets.So_luong,
      'Ten_hd': assets.Ten_hd,
      'Mdsd': assets.Mdsd,
      'Ma_qr': assets.Ma_qr,
      'Uid': assets.Uid
    }).catchError((error) => print('Error updating $error'));
  }

  void deleteAsset(Assets assets) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(assets.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}

import 'package:assets_manager/models/lichsusudungtaisan.dart';
import 'package:assets_manager/services/db_lichsusudung_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbLSSDService implements DbLSSDApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionAssets = 'LichSuSD';

  DbLSSDService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<List<LichSuSuDung>> getLichSuSuDung(String Ma_ts) {
    return _firestore
        .collection(_collectionAssets)
        .where("DocumentID", isEqualTo: Ma_ts)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<LichSuSuDung> _lichSuSuDungDocs =
          snapshot.docs.map((doc) => LichSuSuDung.fromDoc(doc)).toList();
      _lichSuSuDungDocs
          .sort((comp1, comp2) => comp1.Thgian!.compareTo(comp2.Thgian!));
      return _lichSuSuDungDocs;
    });
  }

  Future<bool> addLichSuSuDung(LichSuSuDung lichSuSuDung) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionAssets).add({
      'DocumentID': lichSuSuDung.documentID,
      'Ten_ts': lichSuSuDung.Ten_ts,
      'Ten_pb': lichSuSuDung.Ten_pb,
      'Nam_sx': lichSuSuDung.Nam_sx,
      'Nuoc_sx': lichSuSuDung.Nuoc_sx,
      'Ma_nts': lichSuSuDung.Ma_nts,
      'Ma_tinh_trang': lichSuSuDung.Ma_tinh_trang,
      'Nguyen_gia': lichSuSuDung.Nguyen_gia,
      'Tg_sd': lichSuSuDung.Tg_sd,
      'So_luong': lichSuSuDung.So_luong,
      'So_hd': lichSuSuDung.So_hd,
      'Mdsd': lichSuSuDung.Mdsd,
      'Ma_qr': lichSuSuDung.Ma_qr,
      'Name': lichSuSuDung.Name,
      'Email': lichSuSuDung.Email,
      'Thgian': lichSuSuDung.Thgian
    });
    return _documentReference.id != null;
  }

  void updateLichSuSuDung(LichSuSuDung lichSuSuDung) {}

  void deleteLichSuSuDung(LichSuSuDung lichSuSuDung) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(lichSuSuDung.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }

  void deleteLichSuSuDungID(String documentID) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}

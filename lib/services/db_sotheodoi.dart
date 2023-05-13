import 'package:assets_manager/models/sotheodoi.dart';
import 'package:assets_manager/services/db_sotheodoi_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbSoTheoDoiService implements DbSTDApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collection = 'SoTheoDoi';
  DbSoTheoDoiService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<List<SoTheoDoi>> getSoTheoDoiList(String Ma_ts, String Ma_pb) {
    print("$Ma_ts $Ma_pb");
    return _firestore
        .collection(_collection)
        .where("Ma_pb", isEqualTo: Ma_pb)
        .where("Ma_qr", isEqualTo: Ma_ts)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<SoTheoDoi> _soTheoDoiDocs =
          snapshot.docs.map((doc) => SoTheoDoi.fromDoc(doc)).toList();
      _soTheoDoiDocs
          .sort((comp1, comp2) => comp1.Thgian!.compareTo(comp2.Thgian!));
      return _soTheoDoiDocs;
    });
  }

  Future<bool> addSoTheoDoi(SoTheoDoi soTheoDoi) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collection).add({
      'Ten_ts': soTheoDoi.Ten_ts,
      'Ma_pb': soTheoDoi.Ma_pb,
      'Nguyen_gia': soTheoDoi.Nguyen_gia,
      'Tg_sd': soTheoDoi.Tg_sd,
      'Ngay_BD': soTheoDoi.Ngay_BD,
      'Ngay_KT': soTheoDoi.Ngay_KT,
      'Khau_hao': soTheoDoi.Khau_hao,
      'Ma_qr': soTheoDoi.Ma_qr,
      'Ly_do': soTheoDoi.Ly_do,
      'Name': soTheoDoi.Name,
      'Email': soTheoDoi.Email,
      'Thgian': soTheoDoi.Thgian
    });
    return _documentReference.id != null;
  }

  void updateSoTheoDoi(SoTheoDoi soTheoDoi) async {
    await _firestore.collection(_collection).doc(soTheoDoi.Ma_qr).update({
      'Ten_ts': soTheoDoi.Ten_ts,
      'Ma_pb': soTheoDoi.Ma_pb,
      'Nguyen_gia': soTheoDoi.Nguyen_gia,
      'Tg_sd': soTheoDoi.Tg_sd,
      'Ngay_BD': soTheoDoi.Ngay_BD,
      'Ngay_KT': soTheoDoi.Ngay_KT,
      'Khau_hao': soTheoDoi.Khau_hao,
      'Ma_qr': soTheoDoi.Ma_qr,
      'Ly_do': soTheoDoi.Ly_do,
      'Name': soTheoDoi.Name,
      'Email': soTheoDoi.Email,
      'Thgian': soTheoDoi.Thgian
    }).catchError((error) => print('Error updating $error'));
  }

  void deleteSoTheoDoi(SoTheoDoi soTheoDoi) async {
    await _firestore
        .collection(_collection)
        .doc(soTheoDoi.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}

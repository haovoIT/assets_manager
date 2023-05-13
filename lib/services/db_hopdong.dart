import 'package:assets_manager/models/hopdong.dart';
import 'package:assets_manager/services/db_hopdong_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbContractService implements DbCtApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collection = 'HopDong';

  DbContractService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }
  Stream<List<Contract>> getContractList() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Contract> _contractDocs =
          snapshot.docs.map((doc) => Contract.fromdoc(doc)).toList();
      _contractDocs
        ..sort((comp1, comp2) => comp1.TenHD!.compareTo(comp2.TenHD!));
      return _contractDocs;
    });
  }

  Future<bool> addContract(Contract contract) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collection).add({
      'SoHD': contract.SoHD,
      'TenHD': contract.TenHD,
      'NgayKy': contract.NgayKy,
      'NHH': contract.NHH,
      'NCC': contract.NCC,
      'ND': contract.ND
    });
    return _documentReference.id != null;
  }

  void updateContract(Contract contract) async {
    await _firestore.collection(_collection).doc(contract.documentID).update({
      'SoHD': contract.SoHD,
      'TenHD': contract.TenHD,
      'NgayKy': contract.NgayKy,
      'NHH': contract.NHH,
      'NCC': contract.NCC,
      'ND': contract.ND
    }).catchError((error) => print('Error updating $error'));
  }

  void deleteContract(Contract contract) async {
    await _firestore
        .collection(_collection)
        .doc(contract.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}

import 'package:assets_manager/models/phongban.dart';
import 'package:assets_manager/services/db_phongban_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbDepartmentService implements DbDpmApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionDepartments = 'PhongBan';

  DbDepartmentService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }
  Stream<List<Department>> getDepartmentList() {
    return _firestore
        .collection(_collectionDepartments)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Department> _departmentDocs =
          snapshot.docs.map((doc) => Department.fromDoc(doc)).toList();
      _departmentDocs
          .sort((comp1, comp2) => comp1.Ten_Pb!.compareTo(comp2.Ten_Pb!));
      return _departmentDocs;
    });
  }

  Stream<List<Department>> getTenDepartmentList(String name) {
    return _firestore
        .collection(_collectionDepartments)
        .where("Ten_Pb", isEqualTo: name)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Department> _departmentDocs =
          snapshot.docs.map((doc) => Department.fromDoc(doc)).toList();
      _departmentDocs
          .sort((comp1, comp2) => comp1.Ten_Pb!.compareTo(comp2.Ten_Pb!));
      return _departmentDocs;
    });
  }

  Stream<List<Department>> getDepartmentListTen() {
    return _firestore
        .collection(_collectionDepartments)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Department> _departmentDocs =
          snapshot.docs.map((doc) => Department.fromDocTenPB(doc)).toList();
      _departmentDocs
          .sort((comp1, comp2) => comp1.Ten_Pb!.compareTo(comp2.Ten_Pb!));
      return _departmentDocs;
    });
  }

  Future<bool> addDepartment(Department department) async {
    DocumentReference _documentReference = await _firestore
        .collection(_collectionDepartments)
        .add({
      'Ten_Pb': department.Ten_Pb,
      'SDT': department.SDT,
      'DC': department.DC
    });
    return _documentReference.id != null;
  }

  void updateDepartment(Department department) async {
    await _firestore
        .collection(_collectionDepartments)
        .doc(department.documentID)
        .update({
      'Ten_Pb': department.Ten_Pb,
      'SDT': department.SDT,
      'DC': department.DC
    }).catchError((error) => print('Error updating $error'));
  }

  void deleteDepartment(Department department) async {
    await _firestore
        .collection(_collectionDepartments)
        .doc(department.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}

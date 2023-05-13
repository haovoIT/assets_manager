import 'package:assets_manager/models/phongban.dart';

abstract class DbDpmApi{
  Stream<List<Department>> getDepartmentList();
  Stream<List<Department>> getTenDepartmentList(String name);
  Stream<List<Department>> getDepartmentListTen();
  Future<bool> addDepartment( Department department);
  void updateDepartment(Department department);
  void deleteDepartment(Department department);
}

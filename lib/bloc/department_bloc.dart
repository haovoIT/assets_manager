import 'dart:async';

import 'package:assets_manager/models/phongban.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_phongban_api.dart';

class DepartmentBloc {
  final DbDpmApi dbDpmApi;
  final AuthenticationApi authenticationApi;

  DepartmentBloc(this.dbDpmApi, this.authenticationApi) {
    _startListeners();
  }

  final StreamController<List<Department>> _departmentController =
      StreamController<List<Department>>.broadcast();
  Sink<List<Department>> get _addListDepartment => _departmentController.sink;
  Stream<List<Department>> get listDepartment => _departmentController.stream;

  final StreamController<Department> _departmentDeleteController =
      StreamController<Department>.broadcast();
  Sink<Department> get deleteDepartment => _departmentDeleteController.sink;

  final StreamController<String> _tenPbController =
      StreamController<String>.broadcast();
  Sink<String> get tenPbEditChanged => _tenPbController.sink;
  Stream<String> get tenPbEdit => _tenPbController.stream;

  final StreamController<List<Department>> _departmentNameController =
      StreamController<List<Department>>.broadcast();
  Sink<List<Department>> get _addListNameDepartment =>
      _departmentNameController.sink;
  Stream<List<Department>> get listNameDepartment =>
      _departmentNameController.stream;

  void _startListeners() {
    /*authenticationApi.getFirebaseAuth().currentUser.then((user) {
      dbApi.getAssetsList(user.uid).listen((assetsDocs) {
        _addListAssets.add(assetsDocs);
      });
      _assetsDeleteController.stream.listen((assets) {
        dbApi.deleteAsset(assets);
      });
    });*/
    dbDpmApi.getDepartmentList().listen((departmentDocs) {
      _addListDepartment.add(departmentDocs);
    });
    _departmentDeleteController.stream.listen((department) {
      dbDpmApi.deleteDepartment(department);
    });

    _tenPbController.stream.listen((tenPb) {
      dbDpmApi.getTenDepartmentList(tenPb).listen((departmentDocs) {
        _addListNameDepartment.add(departmentDocs);
      });
    });
  }

  void dispose() {
    _departmentDeleteController.close();
    _departmentController.close();
    _departmentNameController.close();
    _tenPbController.close();
  }
}

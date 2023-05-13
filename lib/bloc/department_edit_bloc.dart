import 'dart:async';

import 'package:assets_manager/models/phongban.dart';
import 'package:assets_manager/services/db_phongban_api.dart';

class DepartmentEditBloc {
  final DbDpmApi dbDpmApi;
  final bool add;
  Department selectDepartment;

  DepartmentEditBloc(this.add, this.dbDpmApi, this.selectDepartment) {
    _startEditListeners()
        .then((finished) => _getDepartment(add, selectDepartment));
  }

  final StreamController<String> _tenPbController =
      StreamController<String>.broadcast();
  Sink<String> get tenPbEditChanged => _tenPbController.sink;
  Stream<String> get tenPbEdit => _tenPbController.stream;

  final StreamController<String> _sdtController =
      StreamController<String>.broadcast();
  Sink<String> get sdtEditChanged => _sdtController.sink;
  Stream<String> get sdtEdit => _sdtController.stream;

  final StreamController<String> _dcController =
      StreamController<String>.broadcast();
  Sink<String> get dcEditChanged => _dcController.sink;
  Stream<String> get dcEdit => _dcController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  _startEditListeners() async {
    _tenPbController.stream.listen((tenPb) {
      selectDepartment.Ten_Pb = tenPb;
    });
    _sdtController.stream.listen((sdt) {
      selectDepartment.SDT = sdt;
    });
    _dcController.stream.listen((dc) {
      selectDepartment.DC = dc;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveDepartment();
      }
    });
  }

  void _getDepartment(bool add, Department department) {
    if (add) {
      selectDepartment = Department();
      selectDepartment.Ten_Pb = '';
      selectDepartment.SDT = '';
      selectDepartment.DC = '';
    } else {
      selectDepartment.Ten_Pb = department.Ten_Pb;
      selectDepartment.SDT = department.SDT;
      selectDepartment.DC = department.DC;
    }
    tenPbEditChanged.add(selectDepartment.Ten_Pb ?? "");
    sdtEditChanged.add(selectDepartment.SDT ?? "");
    dcEditChanged.add(selectDepartment.DC ?? "");
  }

  void _saveDepartment() {
    Department department = Department(
        documentID: selectDepartment.documentID,
        Ten_Pb: selectDepartment.Ten_Pb,
        SDT: selectDepartment.SDT,
        DC: selectDepartment.DC);
    add
        ? dbDpmApi.addDepartment(department)
        : dbDpmApi.updateDepartment(department);
  }

  void dispose() {
    _tenPbController.close();
    _sdtController.close();
    _dcController.close();
    _saveController.close();
  }
}

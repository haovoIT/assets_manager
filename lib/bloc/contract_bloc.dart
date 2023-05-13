import 'dart:async';

import 'package:assets_manager/models/hopdong.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_hopdong_api.dart';

class ContractBloc {
  final DbCtApi dbCtApi;
  final AuthenticationApi authenticationApi;

  ContractBloc(this.dbCtApi, this.authenticationApi) {
    _startListeners();
  }

  final StreamController<List<Contract>> _contractController =
      StreamController<List<Contract>>.broadcast();
  Sink<List<Contract>> get _addListContract => _contractController.sink;
  Stream<List<Contract>> get listContract => _contractController.stream;

  final StreamController<Contract> _contractDeleteController =
      StreamController<Contract>.broadcast();
  Sink<Contract> get deleteContract => _contractDeleteController.sink;

  void _startListeners() {
    dbCtApi.getContractList().listen((contractDocs) {
      _addListContract.add(contractDocs);
    });
    _contractDeleteController.stream.listen((contract) {
      dbCtApi.deleteContract(contract);
    });
  }

  void dispose() {
    _contractDeleteController.close();
    _contractController.close();
  }
}

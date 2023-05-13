import 'package:assets_manager/models/hopdong.dart';

abstract class DbCtApi{
  Stream<List<Contract>> getContractList();
  Future<bool> addContract(Contract contract);
  void updateContract(Contract contract);
  void deleteContract(Contract contract);
}
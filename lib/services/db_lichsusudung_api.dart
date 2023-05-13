import 'package:assets_manager/models/lichsusudungtaisan.dart';

abstract class DbLSSDApi{
  Stream<List<LichSuSuDung>> getLichSuSuDung(String Ma_ts);
  Future<bool> addLichSuSuDung( LichSuSuDung lichSuSuDung);
  void updateLichSuSuDung(LichSuSuDung lichSuSuDung);
  void deleteLichSuSuDung(LichSuSuDung lichSuSuDung);
  void deleteLichSuSuDungID(String documentID);
}
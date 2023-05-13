import 'package:assets_manager/models/sotheodoi.dart';

abstract class DbSTDApi{
  Stream<List<SoTheoDoi>> getSoTheoDoiList(String Ma_ts,String Ma_pb);
  Future<bool> addSoTheoDoi(SoTheoDoi soTheoDoi);
  void deleteSoTheoDoi(SoTheoDoi soTheoDoi);
}
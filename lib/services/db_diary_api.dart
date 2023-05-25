import 'package:assets_manager/models/diary_model.dart';

abstract class DbDiaryApi {
  Stream<List<DiaryModel>> getDiaryList(String idAsset);
  Future<String> addDiaryModel(DiaryModel diaryModel);
  void deleteDiaryModel(DiaryModel diaryModel);
}

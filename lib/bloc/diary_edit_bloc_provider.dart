import 'package:assets_manager/bloc/diary_edit_bloc.dart';
import 'package:flutter/material.dart';

class DiaryEditBlocProvider extends InheritedWidget {
  final DiaryEditBloc diaryEditBloc;
  final String? uid;

  const DiaryEditBlocProvider(
      {Key? key,
      required Widget child,
      required this.diaryEditBloc,
      this.uid})
      : super(key: key, child: child);

  static DiaryEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DiaryEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(DiaryEditBlocProvider old) =>
      diaryEditBloc != old.diaryEditBloc;
}

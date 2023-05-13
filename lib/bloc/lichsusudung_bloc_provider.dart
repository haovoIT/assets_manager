import 'package:assets_manager/bloc/lichsusudung_bloc.dart';
import 'package:flutter/material.dart';

class LichSuSuSungBlocProvider extends InheritedWidget {
  final LichSuSuDungBloc lichSuSuDungBloc;
  final String uid;

  const LichSuSuSungBlocProvider(
      {Key? key,
      required Widget child,
      required this.lichSuSuDungBloc,
      required this.uid})
      : super(key: key, child: child);

  static LichSuSuSungBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LichSuSuSungBlocProvider>();
  }

  @override
  bool updateShouldNotify(LichSuSuSungBlocProvider old) =>
      lichSuSuDungBloc != old.lichSuSuDungBloc;
}

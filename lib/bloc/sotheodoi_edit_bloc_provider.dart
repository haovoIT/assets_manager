import 'package:assets_manager/bloc/sotheodoi_edit_bloc.dart';
import 'package:flutter/material.dart';

class SoTheoDoiEditBlocProvider extends InheritedWidget {
  final SoTheoDoiEditBloc soTheoDoiEditBloc;
  final String? uid;

  const SoTheoDoiEditBlocProvider(
      {Key? key,
      required Widget child,
      required this.soTheoDoiEditBloc,
      this.uid})
      : super(key: key, child: child);

  static SoTheoDoiEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SoTheoDoiEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(SoTheoDoiEditBlocProvider old) =>
      soTheoDoiEditBloc != old.soTheoDoiEditBloc;
}

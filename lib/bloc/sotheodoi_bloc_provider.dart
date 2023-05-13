import 'package:assets_manager/bloc/sotheodoi_bloc.dart';
import 'package:flutter/cupertino.dart';

class SoTheoDoiBlocProvider extends InheritedWidget {
  final SoTheoDoiBloc soTheoDoiBloc;
  final String uid;

  const SoTheoDoiBlocProvider(
      {Key? key,
      required Widget child,
      required this.soTheoDoiBloc,
      required this.uid})
      : super(key: key, child: child);

  static SoTheoDoiBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SoTheoDoiBlocProvider>();
  }

  @override
  bool updateShouldNotify(SoTheoDoiBlocProvider old) =>
      soTheoDoiBloc != old.soTheoDoiBloc;
}

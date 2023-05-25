import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

class OriginalPrice extends StatefulWidget {
  OriginalPrice(
      {Key? key,
      this.assetsEditBloc,
      required this.originalPriceController,
      required this.flag})
      : super(key: key);
  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController originalPriceController;
  final bool flag;

  @override
  State<OriginalPrice> createState() =>
      _OriginalPriceState(assetsEditBloc, originalPriceController, flag);
}

class _OriginalPriceState extends State<OriginalPrice> {
  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController originalPriceController;
  bool flag;

  _OriginalPriceState(
      this.assetsEditBloc, this.originalPriceController, this.flag);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: assetsEditBloc?.originalPriceEdit,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        originalPriceController.value =
            originalPriceController.value.copyWith(text: snapshot.data);
        return CustomTextFromField(
          readOnly: flag ? false : true,
          fillColor: flag ? AppColors.white : AppColors.gray,
          inputType: TextInputType.number,
          inputAction: TextInputAction.done,
          controller: originalPriceController,
          labelText: AssetString.ORIGINAL_PRICE,
          prefixIcon: Icons.price_change_outlined,
          onChangeFunction: (originalPrice) => assetsEditBloc
              ?.originalPriceEditChanged
              .add(Alert.getOnlyNumbers(originalPrice).toVND()),
        );
      },
    );
  }
}

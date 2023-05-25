import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class NameAssets extends StatelessWidget {
  const NameAssets({
    super.key,
    required AssetsEditBloc? assetsEditBloc,
    required TextEditingController nameAssetController,
  })  : _assetsEditBloc = assetsEditBloc,
        _nameAssetController = nameAssetController;

  final AssetsEditBloc? _assetsEditBloc;
  final TextEditingController _nameAssetController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: StreamBuilder(
        stream: _assetsEditBloc?.nameAssetEdit,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          _nameAssetController.value =
              _nameAssetController.value.copyWith(text: snapshot.data);

          return CustomTextFromField(
            controller: _nameAssetController,
            onChangeFunction: (nameAsset) =>
                _assetsEditBloc?.nameAssetEditChanged.add(nameAsset),
            labelText: AssetString.LABEL_TEXT_NAME_ASSETS,
            prefixIcon: Icons.assignment_outlined,
            textCapitalization: TextCapitalization.words,
          );
        },
      ),
    );
  }
}

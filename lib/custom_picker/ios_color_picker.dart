import 'package:flutter/material.dart';
import 'package:ios_color_picker/custom_picker/shared.dart';
import 'localization.dart';
import 'custom_color_picker.dart';

///Returns iOS Style color Picker
/// Wrapper that displays [CustomColorPicker] inside a modal style layout.
class IosColorPicker extends StatelessWidget {
  const IosColorPicker({
    super.key,
    required this.onColorSelected,
    this.localization = const IosColorPickerLocalizations(),
  });

  ///returns the selected color
  final ValueChanged<Color> onColorSelected;
  final IosColorPickerLocalizations localization;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: maxWidth(context),
            ),
          ),
        ),
        CustomColorPicker(
          localization: localization,
          onColorSelected: onColorSelected,
          onClose: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

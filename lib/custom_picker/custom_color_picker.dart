import 'package:flutter/material.dart';
import 'package:ios_color_picker/custom_picker/pickers/slider_picker/slider_helper.dart';
import 'package:ios_color_picker/custom_picker/pickers_selector_row.dart';
import 'package:ios_color_picker/custom_picker/shared.dart';
import 'package:ios_color_picker/custom_picker/localization.dart';
import 'color_observer.dart';
import 'helpers/cache_helper.dart';
import 'history_colors.dart';

/// The color picker content without any surrounding bottom sheet.
class CustomColorPicker extends StatefulWidget {
  final ValueChanged<Color> onColorSelected;
  final IosColorPickerLocalizations localization;
  final VoidCallback? onClose;

  const CustomColorPicker({
    super.key,
    required this.onColorSelected,
    this.localization = const IosColorPickerLocalizations(),
    this.onClose,
  });

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  @override
  void initState() {
    CacheHelper.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      height: 340 + componentsHeight(context),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.98),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  widget.localization.colorsTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (widget.onClose != null)
                  IconButton(
                    highlightColor: Colors.transparent,
                    onPressed: widget.onClose,
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xff3A3A3B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xffA4A4AA),
                        size: 20,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 40),
              ],
            ),
          ),
          PickersSelectorRow(
            onColorChanged: widget.onColorSelected,
            localization: widget.localization,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: Text(
              widget.localization.opacityLabel,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.6),
                  ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 2),
                  child: SizedBox(
                    height: 36.0,
                    child: ValueListenableBuilder<Color>(
                      valueListenable: colorController,
                      builder: (context, color, child) {
                        return ColorPickerSlider(
                            TrackType.alpha, HSVColor.fromColor(color),
                            small: false, (v) {
                          colorController.updateOpacity(v.alpha);
                          widget.onColorSelected(colorController.value);
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 36,
                width: 77,
                margin: const EdgeInsets.only(right: 16, left: 16),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: valueColor,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: ValueListenableBuilder<Color>(
                  valueListenable: colorController,
                  builder: (context, color, child) {
                    final int alpha = (color.a * 100).toInt();
                    return Text(
                      "$alpha%",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 16,
                            letterSpacing: 0.6,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    );
                  },
                ),
              )
            ],
          ),
          Divider(
            height: 44,
            thickness: 0.2,
            indent: 17,
            endIndent: 17,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 78,
                    width: 78,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.only(left: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Transform.scale(
                      scale: 1.5,
                      child: Transform.rotate(
                        angle: 0.76,
                        child: Row(
                          children: const [
                            Expanded(child: ColoredBox(color: Colors.white)),
                            Expanded(child: ColoredBox(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<Color>(
                    valueListenable: colorController,
                    builder: (context, color, child) {
                      return Container(
                        height: 78,
                        width: 78,
                        margin: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: color,
                        ),
                      );
                    },
                  ),
                ],
              ),
              HistoryColors(
                onColorChanged: widget.onColorSelected,
                localization: widget.localization,
              )
            ],
          ),
        ],
      ),
    );
  }
}

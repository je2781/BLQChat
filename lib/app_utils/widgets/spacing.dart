import 'package:blq_chat/app_utils/styles/app_dimensions.dart';
import 'package:flutter/material.dart';

class Spacing extends StatelessWidget {
  final double height;
  final double width;

  //const Spacing({Key? key, required this.height, required this.width}) : super(key: key);

  const Spacing.height(
    this.height,
  ) : width = AppDimension.zero;

  const Spacing.tinyHeight() : this.height(AppDimension.tiny);

  const Spacing.extraSmallHeight() : this.width(AppDimension.extraSmall);

  const Spacing.smallHeight() : this.height(AppDimension.small);

  const Spacing.meduimHeight() : this.height(AppDimension.medium);

  const Spacing.bigHeight() : this.height(AppDimension.big);

  const Spacing.largeHeight() : this.height(AppDimension.large);

  const Spacing.width(
    this.width,
  ) : height = AppDimension.zero;

  const Spacing.tinyWidth() : this.width(AppDimension.tiny);

  const Spacing.extraSmallWidth() : this.width(AppDimension.extraSmall);

  const Spacing.smallWidth() : this.width(AppDimension.small);

  const Spacing.meduimWidth() : this.width(AppDimension.medium);

  const Spacing.bigWidth() : this.width(AppDimension.big);

  const Spacing.largeWidth() : this.width(AppDimension.large);

  const Spacing.empty()
      : height = AppDimension.zero,
        width = AppDimension.zero;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}

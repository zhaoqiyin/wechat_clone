import 'package:flutter/material.dart';

import '../constants.dart' show Constants, AppColors;

class FullWidthButton extends StatelessWidget {
  static const HORIZONTAL_PADDING = 20.0;
  static const VERTICAL_PADDING = 13.0;

  const FullWidthButton({
    @required this.iconPath,
    @required this.title,
    this.showDivider : false,
    @required this.onPressed
  }) : assert(iconPath != null),
       assert(title != null),
       assert(onPressed != null);

  final String iconPath;
  final String title;
  final bool showDivider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final pureButton = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          iconPath,
          width: Constants.FullWidthIconButtonIconSize,
          height: Constants.FullWidthIconButtonIconSize,
        ),
        SizedBox(width: HORIZONTAL_PADDING),
        Text(title)
      ],
    );
    final borderedButton = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(AppColors.DividerColor), width: Constants.DividerWidth)
        )
      ),
      padding: const EdgeInsets.only(bottom: VERTICAL_PADDING),
      child: pureButton,
    );
    return FlatButton(
      onPressed: onPressed,
      color: Colors.white,
      padding: EdgeInsets.only(
        left: HORIZONTAL_PADDING, right: HORIZONTAL_PADDING,
        top: VERTICAL_PADDING, bottom: this.showDivider ? 0.0 :VERTICAL_PADDING
      ),
      child: this.showDivider ? borderedButton : pureButton,
    );
  }
}
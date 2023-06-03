import 'package:flutter/material.dart';

class HoldableButton extends StatelessWidget {
  final Function() onTap;
  final Function() onLongPress;
  final Function(LongPressEndDetails)? onLongPressEnd;
  final Widget icon;
  const HoldableButton({
    required this.onTap,
    required this.onLongPress,
    required this.onLongPressEnd,
    required this.icon,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onLongPressEnd: onLongPressEnd,
      child: icon,
    );
  }
}

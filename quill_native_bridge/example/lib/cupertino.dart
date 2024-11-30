import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final usesCupertino =
    {TargetPlatform.macOS, TargetPlatform.iOS}.contains(defaultTargetPlatform);

class AdaptiveDialogAction extends StatelessWidget {
  const AdaptiveDialogAction({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (usesCupertino) {
      return CupertinoDialogAction(
        onPressed: onPressed,
        child: child,
      );
    }
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  // ignore: use_key_in_widget_constructors
  const LoadingWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.stretchedDots(
        color: color,
        size: 45,
      ),
    );
  }
}

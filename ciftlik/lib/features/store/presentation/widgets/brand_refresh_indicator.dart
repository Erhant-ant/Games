import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class BrandRefreshIndicator extends StatelessWidget {
  const BrandRefreshIndicator({
    super.key,
    required this.child,
    this.onRefresh,
  });

  final Widget child;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh ?? () async {
        // Default dummy delay to simulate refresh
        await Future.delayed(const Duration(milliseconds: 1500));
      },
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            if (!controller.isIdle)
              Positioned(
                top: 35.0 * controller.value,
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget? _) {
                      return Transform.rotate(
                        angle: controller.value * 2 * 3.141592653589793,
                        child: Image.asset('assets/images/refresh_logo.png'),
                      );
                    },
                  ),
                ),
              ),
            // Transform to push the content down when pulling
            Transform.translate(
              offset: Offset(0.0, 60.0 * controller.value),
              child: child,
            ),
          ],
        );
      },
      child: child,
    );
  }
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:story_app/widgets/loader_animation.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController loaderController;
  late Animation<double> scaleAnimation;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();
    loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    scaleAnimation = Tween(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: loaderController, curve: Curves.easeIn));

    rotationAnimation = Tween(
      begin: 0.0,
      end: 2 * 3.1416,
    ).animate(loaderController);

    loaderController.repeat(reverse: true);
  }

  @override
  void dispose() {
    loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([scaleAnimation, rotationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimation.value,
              child: Transform.rotate(
                angle: rotationAnimation.value,
                child: CustomPaint(
                  foregroundPainter: LoaderAnimation(
                    radiusRatio: 1.0, // tetap konstan
                  ),
                  size: Size(300, 300),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

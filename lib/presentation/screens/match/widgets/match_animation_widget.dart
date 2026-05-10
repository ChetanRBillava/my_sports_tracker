import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../logic/match_screen_bloc.dart';
import '../logic/match_screen_event.dart';

class MatchAnimationWidget extends StatefulWidget {
  final String lottie;
  const MatchAnimationWidget({super.key, required this.lottie});

  @override
  State<MatchAnimationWidget> createState() => _MatchAnimationWidgetState();
}

class _MatchAnimationWidgetState extends State<MatchAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Future<LottieComposition> _compositionFuture;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);

    animationController.addStatusListener((status) {
      print('Animation status: $status');
      if (status == AnimationStatus.completed) {
        context.read<MatchScreenBloc>().add(AnimateLottieEvent(animate: false));
      }
    });
    _compositionFuture = _loadComposition();
  }

  Future<LottieComposition> _loadComposition() async {
    final composition = await AssetLottie(widget.lottie).load();

    animationController.duration = composition.duration;

    animationController
      ..reset()
      ..repeat(count: 3);
    return composition;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LottieComposition>(
      future: _compositionFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return Lottie(
          composition: snapshot.data!,
          controller: animationController,
        );
      },
    );
  }
}

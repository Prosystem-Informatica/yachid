import 'package:flutter/material.dart';

class YachidBackgroundWidget extends StatelessWidget {
  const YachidBackgroundWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/yachid_logo.jpeg'),
          fit: BoxFit.contain,
        ),
      ),
      child: child,
    );
  }
}

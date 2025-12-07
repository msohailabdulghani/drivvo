import 'package:flutter/material.dart';

class RefreshIndicatorView extends StatelessWidget {
  const RefreshIndicatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

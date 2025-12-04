import 'package:flutter/material.dart';

class ErrorRefreshView extends StatelessWidget {
  final Function onRefresh;

  const ErrorRefreshView({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("No record found!"),
          IconButton(onPressed: () => onRefresh(), icon: const Icon(Icons.refresh_rounded))
        ],
      ),
    );
  }
}

import 'package:drivvo/modules/more/more_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MoreView extends GetView<MoreController> {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("More")));
  }
}

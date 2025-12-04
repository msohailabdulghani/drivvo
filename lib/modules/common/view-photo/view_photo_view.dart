import 'package:drivvo/modules/common/view-photo/view_photo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPhotoView extends GetView<ViewPhotoController> {
  const ViewPhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0XffFB5C7C),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "",
          style: TextStyle(
            fontFamily: "D-FONT-M",
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(),
        // Hero(
        //   tag: controller.url,
        //   child: PhotoView(
        //     imageProvider: NetworkImage(controller.url),
        //     minScale: PhotoViewComputedScale.contained,
        //     maxScale: PhotoViewComputedScale.contained * 1.5,
        //     initialScale: PhotoViewComputedScale.contained * .5,
        //     basePosition: Alignment.center,
        //     enableRotation: true,
        //   ),
        // ),
      ),
    );
  }
}

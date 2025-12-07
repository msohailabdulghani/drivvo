import 'package:drivvo/custom-widget/common/profile_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final double width;
  final double height;
  final String photoUrl;
  final double radius;
  final String placeholder;
  final bool view;

  const ProfileImage({
    super.key,
    required this.photoUrl,
    required this.width,
    required this.height,
    required this.radius,
    required this.placeholder,
    this.view = true,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = photoUrl.startsWith('http');

    return GestureDetector(
      onTap: isNetwork ? () {} : null,
      child: isNetwork
          ? ProfileNetworkImage(
              imageUrl: photoUrl,
              width: width,
              height: height,
              borderRadius: radius,
              placeholder: placeholder,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(
                photoUrl,
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  placeholder,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final String placeholder;

  const ProfileNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.placeholder = 'assets/images/placeholder.png',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/loading_gf_small.gif',
        image: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholderScale: 0.3,
        imageErrorBuilder: (context, error, stackTrace) => Image.asset(
          placeholder,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

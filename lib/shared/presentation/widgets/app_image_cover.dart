import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImageCover extends StatelessWidget {
  const AppImageCover({
    this.assetPath,
    this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.overlayOpacity = 0,
    this.borderRadius,
    this.child,
    super.key,
  }) : assert(
          assetPath != null || imageUrl != null,
          'Provide assetPath or imageUrl',
        );

  final String? assetPath;
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double overlayOpacity;
  final BorderRadius? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final image = imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: fit,
            width: width,
            height: height,
            placeholder: (_, __) => const ColoredBox(color: Color(0xFF2A2118)),
            errorWidget: (_, __, ___) => const ColoredBox(color: Color(0xFF2A2118)),
          )
        : Image.asset(
            assetPath!,
            fit: fit,
            width: width,
            height: height,
          );

    final content = Stack(
      fit: StackFit.passthrough,
      children: [
        image,
        if (overlayOpacity > 0)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: overlayOpacity),
                borderRadius: borderRadius,
              ),
            ),
          ),
        if (child != null) Positioned.fill(child: child!),
      ],
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: content);
    }

    return content;
  }
}

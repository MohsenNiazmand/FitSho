import 'package:flutter/material.dart';

/// A widget that displays only the first frame of an animated image
/// (such as GIF), freezing animation to prevent continuous CPU/GPU overhead.
class StaticGifThumbnail extends StatefulWidget {

  const StaticGifThumbnail({
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.showPlayBadge = false,
    super.key,
  });

  final ImageProvider image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showPlayBadge;

  @override
  State<StaticGifThumbnail> createState() => _StaticGifThumbnailState();
}

class _StaticGifThumbnailState extends State<StaticGifThumbnail> {
  ImageInfo? _imageInfo;
  ImageStream? _imageStream;
  ImageStreamListener? _listener;
  bool _hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(StaticGifThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _resolveImage();
    }
  }

  void _resolveImage() {
    _cleanup();
    _hasError = false;
    _imageInfo = null;

    final ImageStream stream =
        widget.image.resolve(createLocalImageConfiguration(context));
    _imageStream = stream;
    _listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        if (mounted && _imageInfo == null) {
          setState(() {
            _imageInfo = info;
          });
          // Remove listener after first frame to freeze GIF animation
          _cleanup();
        }
      },
      onError: (exception, stackTrace) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
          _cleanup();
        }
      },
    );
    stream.addListener(_listener!);
  }

  void _cleanup() {
    if (_imageStream != null && _listener != null) {
      _imageStream!.removeListener(_listener!);
      _listener = null;
    }
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_hasError) {
      content = widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.white.withValues(alpha: 0.05),
            child: const Icon(
              Icons.fitness_center,
              size: 24,
              color: Colors.white54,
            ),
          );

    } else if (_imageInfo == null) {
      content = widget.placeholder ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.white.withValues(alpha: 0.05),
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
    } else {
      content = RawImage(
        image: _imageInfo!.image,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    if (!widget.showPlayBadge || _imageInfo == null) {
      return content;
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        content,
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 11,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

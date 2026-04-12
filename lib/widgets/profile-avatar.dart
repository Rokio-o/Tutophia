import 'package:flutter/material.dart';
import 'package:tutophia/services/repository/user_repository/user_repository.dart';

class ProfileAvatar extends StatefulWidget {
  final double size;
  final double iconSize;
  final String? imageSource;
  final String? userId;
  final bool grayscale;

  const ProfileAvatar({
    super.key,
    required this.size,
    required this.iconSize,
    this.imageSource,
    this.userId,
    this.grayscale = false,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String? _resolvedImageSource;

  @override
  void initState() {
    super.initState();
    _resolvedImageSource = _normalize(widget.imageSource);
    _loadImageSourceIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ProfileAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextImageSource = _normalize(widget.imageSource);
    final didImageChange = nextImageSource != _normalize(oldWidget.imageSource);
    final didUserChange = widget.userId != oldWidget.userId;

    if (!didImageChange && !didUserChange) {
      return;
    }

    _resolvedImageSource = nextImageSource;
    _loadImageSourceIfNeeded();
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  bool _isNetworkImage(String source) {
    return source.startsWith('http://') || source.startsWith('https://');
  }

  Future<void> _loadImageSourceIfNeeded() async {
    final userId = widget.userId?.trim() ?? '';
    if (_resolvedImageSource != null || userId.isEmpty) {
      return;
    }

    try {
      final data = await UserRepository.instance.getUserProfile(userId);
      if (!mounted) return;

      final imageSource = _normalize(data?['profileImageUrl'] as String?);
      if (imageSource == _resolvedImageSource) {
        return;
      }

      setState(() {
        _resolvedImageSource = imageSource;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _resolvedImageSource = null;
      });
    }
  }

  Widget _fallbackIcon() {
    return Center(
      child: Icon(Icons.person, size: widget.iconSize, color: Colors.grey),
    );
  }

  Widget _buildImage(String source) {
    if (_isNetworkImage(source)) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallbackIcon(),
      );
    }

    return Image.asset(
      source,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _fallbackIcon(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_resolvedImageSource == null) {
      content = _fallbackIcon();
    } else {
      content = _buildImage(_resolvedImageSource!);
    }

    if (widget.grayscale) {
      content = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: content,
      );
    }

    return Container(
      width: widget.size,
      height: widget.size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: content,
    );
  }
}

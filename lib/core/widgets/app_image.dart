import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final EdgeInsets? padding;
  final bool isCircle;
  final Color? color, bgColor;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0.0,
    this.isCircle = false,
    this.color,
    this.placeholder,
    this.errorWidget,
    this.bgColor,
    this.padding,
  });

  Widget _buildPlaceholder() {
    return Center(child: placeholder ?? const CircularProgressIndicator());
  }

  Widget _buildErrorWidget([BuildContext? context]) {
    final ctx = context ?? Get.context;
    final primary = ctx?.colorScheme.primary ?? const Color(0xFF4F46E5);
    final error = ctx?.colorScheme.error ?? const Color(0xFFEF4444);
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: primary.withValues(alpha: 0.08),
          child: Icon(Icons.broken_image_outlined, color: error),
        );
  }

  Widget _wrapShape(Widget child) {
    if (isCircle) {
      return Container(
        padding: padding,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: child,
      );
    }

    if (borderRadius > 0) {
      return Container(
        padding: padding,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      );
    }

    return Container(
      padding: padding,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (path.trim().isEmpty) {
      return _wrapShape(_buildErrorWidget(context));
    }

    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    final cleanPath = path.toLowerCase().split('?').first.split('#').first;
    final isSvg =
        cleanPath.endsWith('.svg') ||
        cleanPath.endsWith('/income.png') ||
        cleanPath.endsWith('/expense.png');

    Widget image;

    if (isNetwork && isSvg) {
      image = SvgPicture.network(
        path,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) => _buildPlaceholder(),
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context),
      );
    } else if (isNetwork) {
      image = CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(context),
      );
    } else if (isSvg) {
      final colorFilter = color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null;

      if (path.startsWith('assets/')) {
        image = SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          colorFilter: colorFilter,
          placeholderBuilder: (context) => _buildPlaceholder(),
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget(context),
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          image = SvgPicture.file(
            file,
            width: width,
            height: height,
            fit: fit,
            colorFilter: colorFilter,
            placeholderBuilder: (context) => _buildPlaceholder(),
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorWidget(context),
          );
        } else {
          image = SvgPicture.asset(
            path,
            width: width,
            height: height,
            fit: fit,
            colorFilter: colorFilter,
            placeholderBuilder: (context) => _buildPlaceholder(),
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorWidget(context),
          );
        }
      }
    } else if (path.startsWith('assets/')) {
      image = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context),
      );
    } else {
      image = Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context),
      );
    }

    return _wrapShape(image);
  }
}

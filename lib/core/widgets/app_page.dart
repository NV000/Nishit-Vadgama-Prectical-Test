import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/helper/app_helper.dart';

class AppPage extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;

  // Background and appearance
  final String? backgroundImage;
  final BoxFit backgroundImageFit;
  final bool resizeToAvoidBottomInset;
  final bool unfocusOnTap;

  // Curved header layout
  final bool curvedBody;
  final bool topCurvedBody;
  final Widget? header;
  final Color? curvedBodyColor;
  final double curvedRadius;

  // Scaffold navigation items
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool extendBodyBehindAppBar;
  final bool extendBody;

  // Navigation control
  final bool canPop;
  final VoidCallback? onPopInvoked;

  // Backward compatibility getters
  bool get hasCurvedBody => curvedBody;
  bool get setSafeArea => safeArea;

  const AppPage({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.padding,
    bool safeArea = false,
    bool? setSafeArea,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    bool? curvedSafeAreaBottom,
    this.backgroundImage,
    this.backgroundImageFit = BoxFit.cover,
    this.resizeToAvoidBottomInset = false,
    this.unfocusOnTap = true,
    bool curvedBody = false,
    bool? hasCurvedBody,
    this.header,
    this.curvedBodyColor,
    this.curvedRadius = 30.0,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.canPop = true,
    this.onPopInvoked,
    this.topCurvedBody = true,
  }) : curvedBody = hasCurvedBody ?? curvedBody,
       safeArea = setSafeArea ?? safeArea;

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    // 1. Content padding (for non-curved pages)
    if (!curvedBody && padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // 2. Safe area (if enabled)
    if (safeArea) {
      content = SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        child: content,
      );
    }

    // 3. Curved body layout (if enabled)
    if (curvedBody) {
      content = _buildCurvedBody(context, content);
    }
    if (topCurvedBody) {
      content = _buildTopCurvedBody(context, content);
    }

    // 4. Background image (if provided)
    content = _wrapWithBackground(content);

    // 5. Keyboard dismiss gesture
    content = _wrapWithUnfocus(context, content);

    // 6. Scaffold setup
    final scaffold = SafeArea(
      top: false,
      bottom: Platform.isAndroid ? true : false,
      child: GestureDetector(
        excludeFromSemantics: true,
        onTap: () => AppHelper.hideKeyboard(),
        child: Scaffold(
          appBar: appBar,
          backgroundColor: _resolveBackgroundColor(context),
          body: content,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          drawer: drawer,
          endDrawer: endDrawer,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          extendBody: extendBody,
        ),
      ),
    );

    // 7. System UI Overlay & PopScope
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: _wrapWithPopScope(scaffold),
    );
  }

  Widget _buildTopCurvedBody(BuildContext context, Widget child) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: kToolbarHeight,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }

  /// Builds the top-rounded sheet container for curved pages.
  Widget _buildCurvedBody(BuildContext context, Widget child) {
    final curvedSheet = Container(
      width: double.infinity,
      height: double.infinity,
      padding:
          padding ??
          const EdgeInsets.only(
            top: AppSizes.s20,
            left: AppSizes.s20,
            right: AppSizes.s20,
          ),
      decoration: BoxDecoration(
        color: curvedBodyColor ?? context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.vertical(top: Radius.circular(curvedRadius)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    Widget result;
    if (header != null) {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header!,
          Expanded(child: curvedSheet),
        ],
      );
    } else {
      result = curvedSheet;
    }

    if (appBar == null) {
      result = SafeArea(top: true, bottom: false, child: result);
    }

    return result;
  }

  /// Wraps content with a full-screen background image if configured.
  Widget _wrapWithBackground(Widget content) {
    if (backgroundImage == null || backgroundImage!.isEmpty) {
      return content;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          backgroundImage!,
          fit: backgroundImageFit,
          width: double.infinity,
          height: double.infinity,
        ),
        content,
      ],
    );
  }

  /// Automatically dismisses the keyboard when the user taps outside an input.
  Widget _wrapWithUnfocus(BuildContext context, Widget content) {
    if (!unfocusOnTap) return content;
    return GestureDetector(
      onTap: () => AppHelper.hideKeyboard(context),
      behavior: HitTestBehavior.translucent,
      child: content,
    );
  }

  /// Handles back button behavior via PopScope.
  Widget _wrapWithPopScope(Widget child) {
    if (canPop && onPopInvoked == null) {
      return child;
    }
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          onPopInvoked?.call();
        }
      },
      child: child,
    );
  }

  /// Determines default background color based on curved layout style.
  Color _resolveBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    return curvedBody
        ? context.colorScheme.onSurfaceVariant
        // ? AppColors.primary
        : context.colorScheme.onSurfaceVariant;
  }

  SystemUiOverlayStyle get _overlayStyle {
    final isLightIcons = curvedBody || backgroundColor == AppColors.primary;

    return isLightIcons
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );
  }
}

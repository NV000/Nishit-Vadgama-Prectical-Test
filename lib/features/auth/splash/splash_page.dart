import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/constants/app_assets.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/core/widgets/widgets.dart';
import 'package:nishit_vadgama/features/auth/splash/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SplashController>()) {
      Get.find<SplashController>();
    } else {
      Get.put(SplashController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      topCurvedBody: false,
      body: Center(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.onPrimary,
              ),
              child:
                  AppImage(
                        path: AppAssets.simpleIcon,
                        height: 50,
                        color: context.colorScheme.surface,
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                      .scale(
                        begin: const Offset(0.85, 0.85),
                        end: const Offset(1.0, 1.0),
                        duration: 500.ms,
                        curve: Curves.easeOutBack,
                      ),
            ),

            Text(
              context.l10n.appName,
              style: AppTextStyle.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/services/localization_service.dart';
import 'package:nishit_vadgama/core/theme/app_theme.dart';
import 'package:nishit_vadgama/features/auth/splash/splash_binding.dart';
import 'package:nishit_vadgama/generated/l10n.dart';
import 'package:nishit_vadgama/routes/app_pages.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationService.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const ServiceManagementApp());
}

class ServiceManagementApp extends StatelessWidget {
  const ServiceManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Service Management App",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: LocalizationService.currentLocale,
      fallbackLocale: LocalizationService.english,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1)),
          child: SkeletonizerConfig(
            data: SkeletonizerConfigData(brightness: Brightness.light),
            child: child!,
          ),
        );
      },
      initialBinding: SplashBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}

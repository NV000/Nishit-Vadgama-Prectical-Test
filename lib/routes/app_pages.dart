import 'package:get/get.dart';
import 'package:nishit_vadgama/features/auth/splash/splash_binding.dart';
import 'package:nishit_vadgama/features/auth/splash/splash_page.dart';
import 'package:nishit_vadgama/features/home/booking_detail_page.dart';
import 'package:nishit_vadgama/features/home/booking_form_page.dart';
import 'package:nishit_vadgama/features/home/booking_list_page.dart';
import 'package:nishit_vadgama/features/home/home_binding.dart';
import 'package:nishit_vadgama/features/home/main_page.dart';
import 'package:nishit_vadgama/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const String initial = AppRoutes.splash;

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.bookingList,
      page: () => const BookingListPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.createBooking,
      page: () => const BookingFormPage(),
    ),
    GetPage(
      name: AppRoutes.bookingDetail,
      page: () => const BookingDetailPage(),
      binding: HomeBinding(),
    ),
  ];
}

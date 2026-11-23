import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/features/home/booking_list_page.dart';
import 'package:nishit_vadgama/features/home/dashboard_page.dart';
import 'package:nishit_vadgama/features/home/main_controller.dart';

/// Root bottom-nav shell. Fully reactive with GetX [MainController] (no setState).
class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  static const List<Widget> _pages = [DashboardPage(), BookingListPage()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          await controller.onBackInvoked();
        }
      },
      child: Obx(
        () => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: _pages,
          ),
          bottomNavigationBar: _AppBottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
          ),
        ),
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _AppBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSizes.bottomNavBarHeight,
          child: Row(
            children: [
              _NavItem(
                icon: Iconsax.home,
                activeIcon: Iconsax.home_1,
                label: 'Dashboard',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Iconsax.calendar,
                activeIcon: Iconsax.calendar_2,
                label: 'Bookings',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyle.labelSmall.copyWith(
                color: isActive ? AppColors.primary : AppColors.grey,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

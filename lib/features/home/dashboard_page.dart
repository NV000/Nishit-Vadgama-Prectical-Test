import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_enums.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/core/widgets/app_appbar.dart';
import 'package:nishit_vadgama/core/widgets/app_datebox.dart';
import 'package:nishit_vadgama/core/widgets/app_empty_widget.dart';
import 'package:nishit_vadgama/core/widgets/app_exit_bottom_sheet.dart';
import 'package:nishit_vadgama/core/widgets/app_gredient_card.dart';
import 'package:nishit_vadgama/core/widgets/app_page.dart';
import 'package:nishit_vadgama/core/widgets/section_header.dart';
import 'package:nishit_vadgama/features/home/booking_controller.dart';
import 'package:nishit_vadgama/model/booking_model.dart';
import 'package:nishit_vadgama/routes/app_routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BookingController>();

    return AppPage(
      canPop: false,
      onPopInvoked: () => AppExitBottomSheet.show(),
      topCurvedBody: false,
      curvedBody: false,
      backgroundColor: AppColors.primaryBg,
      appBar: AppAppbar(
        title: 'Dashboard',
        showBackBtn: false,
        showNotification: false,
      ),
      body: Obx(() {
        final bookings = ctrl.allBookings;
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ctrl.loadBookings(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s20,
              AppSizes.s20,
              AppSizes.s20,
              AppSizes.bottomNavBarHeight + AppSizes.s20,
            ),
            children: [
              // ── Summary gradient card ──────────────────────
              _buildSummaryCard(context, ctrl),
              AppSizes.s20.heightBox,

              // ── Recent bookings section ────────────────────
              SectionHeader(
                title: 'Recent Bookings',
                onViewAll: () => Get.toNamed(AppRoutes.bookingList),
              ),
              AppSizes.s12.heightBox,

              if (bookings.isEmpty)
                AppEmptyWidget(
                  title: 'No Bookings Yet',
                  message: 'Tap the + button to create your first booking.',
                  icon: Iconsax.calendar_add,
                  buttonText: 'Create Booking',
                  onButtonPressed: () => Get.toNamed(AppRoutes.createBooking),
                )
              else
                ...ctrl.recentBookings.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.s12),
                    child: _BookingListTile(
                      booking: b,
                      onTap: () =>
                          Get.toNamed(AppRoutes.bookingDetail, arguments: b.id),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'dashboard_fab',
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.createBooking);
          if (result is BookingModel) {
            ctrl.addBooking(result);
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'New Booking',
          style: AppTextStyle.labelLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, BookingController ctrl) {
    return AppGredientCard(
      padding: const EdgeInsets.all(AppSizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Manager',
            style: AppTextStyle.bodySmall.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSizes.s4.heightBox,
          Text(
            'All Bookings Overview',
            style: AppTextStyle.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSizes.s16.heightBox,
          Row(
            children: [
              _SummaryStatBox(
                label: 'Total',
                count: ctrl.totalCount,
                color: Colors.white,
              ),
              AppSizes.s12.widthBox,
              _SummaryStatBox(
                label: 'Pending',
                count: ctrl.pendingCount,
                color: const Color(0xFFFFD54F),
              ),
              AppSizes.s12.widthBox,
              _SummaryStatBox(
                label: 'Confirmed',
                count: ctrl.confirmedCount,
                color: const Color(0xFF90CAF9),
              ),
              AppSizes.s12.widthBox,
              _SummaryStatBox(
                label: 'Done',
                count: ctrl.completedCount,
                color: const Color(0xFFA5D6A7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStatBox extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _SummaryStatBox({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: AppSizes.radiusMd,
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: AppTextStyle.h3.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSizes.s4.heightBox,
            Text(
              label,
              style: AppTextStyle.labelSmall.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingListTile extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;
  const _BookingListTile({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: AppSizes.radiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSizes.radiusLg,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            borderRadius: AppSizes.radiusLg,
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Row(
            children: [
              AppDatebox(date: booking.bookingDate.toIso8601String()),
              AppSizes.s12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      booking.customerName,
                      style: AppTextStyle.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      booking.serviceName,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      booking.phoneNumber,
                      style: AppTextStyle.labelSmall.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              AppSizes.s8.widthBox,
              _StatusBadge(status: booking.status),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: AppSizes.radiusSm,
      ),
      child: Text(
        status.displayName,
        style: AppTextStyle.labelSmall.copyWith(
          color: status.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

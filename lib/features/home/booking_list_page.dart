import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_enums.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/core/widgets/app_appbar.dart';
import 'package:nishit_vadgama/core/widgets/app_chip.dart';
import 'package:nishit_vadgama/core/widgets/app_datebox.dart';
import 'package:nishit_vadgama/core/widgets/app_empty_widget.dart';
import 'package:nishit_vadgama/core/widgets/app_page.dart';
import 'package:nishit_vadgama/features/home/booking_controller.dart';
import 'package:nishit_vadgama/model/booking_model.dart';
import 'package:nishit_vadgama/routes/app_routes.dart';

class BookingListPage extends StatelessWidget {
  const BookingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BookingController>();

    return AppPage(
      topCurvedBody: false,
      curvedBody: false,
      backgroundColor: AppColors.primaryBg,
      appBar: AppAppbar(
        title: 'All Bookings',
        showNotification: false,
        showBackBtn: false,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'booking_list_fab',
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.createBooking);
          if (result is BookingModel) {
            ctrl.addBooking(result);
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Column(
        children: [
          // ── Filter chips bar ───────────────────────────────
          Container(
            color: AppColors.primaryBg,
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s20,
              AppSizes.s12,
              AppSizes.s20,
              AppSizes.s12,
            ),
            child: Obx(
              () => SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: AppSizes.s8,
                  children: BookingFilterStatus.values.map((f) {
                    final isSelected = ctrl.activeFilter.value == f;
                    return AppChip(
                      text: f.displayName,
                      isSelected: isSelected,
                      onTap: () => ctrl.setFilter(f),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // ── Booking list ───────────────────────────────────
          Expanded(
            child: Obx(() {
              final list = ctrl.filteredBookings;
              if (list.isEmpty) {
                return AppEmptyWidget(
                  title: 'No Bookings Found',
                  message: ctrl.activeFilter.value == BookingFilterStatus.all
                      ? 'Create your first booking using the + button.'
                      : 'No ${ctrl.activeFilter.value.displayName} bookings found.',
                  icon: Iconsax.calendar_remove,
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => ctrl.loadBookings(),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.s20,
                    AppSizes.s8,
                    AppSizes.s20,
                    AppSizes.bottomNavBarHeight + AppSizes.s20,
                  ),
                  itemCount: list.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.s12),
                  itemBuilder: (_, i) {
                    final booking = list[i];
                    return _BookingCard(
                      booking: booking,
                      onTap: () => Get.toNamed(
                        AppRoutes.bookingDetail,
                        arguments: booking.id,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;
  const _BookingCard({required this.booking, required this.onTap});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDatebox(date: booking.bookingDate.toIso8601String()),
              AppSizes.s12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            booking.customerName,
                            style: AppTextStyle.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _StatusBadge(status: booking.status),
                      ],
                    ),
                    AppSizes.s4.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Iconsax.briefcase,
                          size: 13,
                          color: AppColors.grey,
                        ),
                        AppSizes.s4.widthBox,
                        Text(
                          booking.serviceName,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    AppSizes.s4.heightBox,
                    Row(
                      children: [
                        const Icon(
                          Iconsax.call,
                          size: 13,
                          color: AppColors.grey,
                        ),
                        AppSizes.s4.widthBox,
                        Text(
                          booking.phoneNumber,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (booking.notes != null) ...[
                      AppSizes.s4.heightBox,
                      Text(
                        booking.notes!,
                        style: AppTextStyle.labelSmall.copyWith(
                          color: AppColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    AppSizes.s8.heightBox,
                    // ── Action buttons ───────────────────────────────
                    _ActionButtons(booking: booking),
                  ],
                ),
              ),
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

class _ActionButtons extends StatelessWidget {
  final BookingModel booking;
  const _ActionButtons({required this.booking});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BookingController>();
    final status = booking.status;

    if (!status.canConfirm && !status.canComplete && !status.canCancel) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      children: [
        if (status.canConfirm)
          _SmallActionBtn(
            label: 'Confirm',
            color: AppColors.primary,
            icon: Iconsax.tick_circle,
            onTap: () =>
                ctrl.updateBookingStatus(booking.id, BookingStatus.confirmed),
          ),
        if (status.canComplete)
          _SmallActionBtn(
            label: 'Complete',
            color: AppColors.success,
            icon: Iconsax.task_square,
            onTap: () =>
                ctrl.updateBookingStatus(booking.id, BookingStatus.completed),
          ),
        if (status.canCancel)
          _SmallActionBtn(
            label: 'Cancel',
            color: AppColors.error,
            icon: Iconsax.close_circle,
            onTap: () => ctrl.cancelBooking(booking),
          ),
      ],
    );
  }
}

class _SmallActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _SmallActionBtn({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: AppSizes.radiusSm,
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(icon, size: 13, color: color),
            Text(
              label,
              style: AppTextStyle.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

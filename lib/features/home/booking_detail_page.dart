import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_assets.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_enums.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';
import 'package:nishit_vadgama/core/helper/date_helper.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/core/widgets/app_appbar.dart';
import 'package:nishit_vadgama/core/widgets/app_button.dart';
import 'package:nishit_vadgama/core/widgets/app_divider.dart';
import 'package:nishit_vadgama/core/widgets/app_form_container.dart';
import 'package:nishit_vadgama/core/widgets/app_page.dart';
import 'package:nishit_vadgama/features/home/booking_controller.dart';
import 'package:nishit_vadgama/model/booking_model.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String bookingId = Get.arguments as String;
    final ctrl = Get.find<BookingController>();

    return Obx(() {
      final booking = ctrl.findById(bookingId);
      if (booking == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Booking Detail')),
          body: const Center(child: Text('Booking not found')),
        );
      }

      return AppPage(
        topCurvedBody: false,
        curvedBody: false,
        backgroundColor: AppColors.primaryBg,
        appBar: AppAppbar(
          title: 'Booking Detail',
          showNotification: false,
          actions: [
            if (booking.status != BookingStatus.completed &&
                booking.status != BookingStatus.cancelled)
              AppIconBtn(
                icon: AppAssets.documentIcon,
                iconColor: Colors.white,
                onTap: () => _showDeleteConfirm(ctrl, booking),
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSizes.s20),
          children: [
            // ── Status hero card ──────────────────────────────
            _StatusHeroCard(booking: booking),
            AppSizes.s20.heightBox,

            // ── Customer Info ─────────────────────────────────
            AppFormContainer(
              title: 'Customer Information',
              children: [
                _DetailRow(
                  icon: Iconsax.user,
                  label: 'Name',
                  value: booking.customerName,
                ),
                const AppDivider(),
                _DetailRow(
                  icon: Iconsax.call,
                  label: 'Phone',
                  value: booking.phoneNumber,
                ),
              ],
            ),
            AppSizes.s16.heightBox,

            // ── Service Info ──────────────────────────────────
            AppFormContainer(
              title: 'Service Information',
              children: [
                _DetailRow(
                  icon: Iconsax.briefcase,
                  label: 'Service',
                  value: booking.serviceName,
                ),
                const AppDivider(),
                _DetailRow(
                  icon: Iconsax.calendar,
                  label: 'Booking Date',
                  value: DateHelper.format(
                    booking.bookingDate,
                    pattern: 'dd MMM yyyy, hh:mm a',
                  ),
                ),
                const AppDivider(),
                _DetailRow(
                  icon: Iconsax.clock,
                  label: 'Created',
                  value: DateHelper.format(
                    booking.createdAt,
                    pattern: 'dd MMM yyyy',
                  ),
                ),
                if (booking.updatedAt != null) ...[
                  const AppDivider(),
                  _DetailRow(
                    icon: Iconsax.refresh,
                    label: 'Last Updated',
                    value: DateHelper.format(
                      booking.updatedAt!,
                      pattern: 'dd MMM yyyy, hh:mm a',
                    ),
                  ),
                ],
              ],
            ),

            // ── Notes ─────────────────────────────────────────
            if (booking.notes != null) ...[
              AppSizes.s16.heightBox,
              AppFormContainer(
                title: 'Notes',
                children: [
                  Text(
                    booking.notes!,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.darkGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],

            AppSizes.s24.heightBox,

            // ── Action Buttons ────────────────────────────────
            _ActionSection(booking: booking, ctrl: ctrl),
          ],
        ),
      );
    });
  }

  Future<void> _showDeleteConfirm(
    BookingController ctrl,
    BookingModel booking,
  ) async {
    await ctrl.deleteBooking(booking.id, booking.customerName);
    if (ctrl.findById(booking.id) == null) {
      Get.back();
    }
  }
}

class _StatusHeroCard extends StatelessWidget {
  final BookingModel booking;
  const _StatusHeroCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking.status;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: AppSizes.radiusXl,
        border: Border.all(color: status.color.withAlpha(60)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.s16),
            decoration: BoxDecoration(
              color: status.color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(status.icon, color: status.color, size: 32),
          ),
          AppSizes.s12.heightBox,
          Text(
            'BK-${booking.id}',
            style: AppTextStyle.labelSmall.copyWith(color: AppColors.grey),
          ),
          AppSizes.s4.heightBox,
          Text(
            status.displayName,
            style: AppTextStyle.h4.copyWith(
              color: status.color,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSizes.s4.heightBox,
          Text(
            DateHelper.format(
              booking.bookingDate,
              pattern: 'EEEE, dd MMM yyyy',
            ),
            style: AppTextStyle.bodySmall.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.s8),
          decoration: BoxDecoration(
            color: AppColors.primaryPastle,
            borderRadius: AppSizes.radiusSm,
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        AppSizes.s12.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.labelSmall.copyWith(color: AppColors.grey),
              ),
              AppSizes.s2.heightBox,
              Text(
                value,
                style: AppTextStyle.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionSection extends StatelessWidget {
  final BookingModel booking;
  final BookingController ctrl;
  const _ActionSection({required this.booking, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final status = booking.status;

    if (!status.canConfirm && !status.canComplete && !status.canCancel) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.s16),
        decoration: BoxDecoration(
          color: status.backgroundColor,
          borderRadius: AppSizes.radiusLg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(status.icon, color: status.color, size: 18),
            AppSizes.s8.widthBox,
            Text(
              'This booking is ${status.displayName}',
              style: AppTextStyle.bodyMedium.copyWith(
                color: status.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (status.canConfirm)
          AppButton(
            text: 'Confirm Booking',
            onPressed: () =>
                ctrl.updateBookingStatus(booking.id, BookingStatus.confirmed),
          ),
        if (status.canComplete) ...[
          if (status.canConfirm) AppSizes.s12.heightBox,
          AppButton(
            text: 'Mark as Completed',
            backgroundColor: AppColors.success,
            onPressed: () =>
                ctrl.updateBookingStatus(booking.id, BookingStatus.completed),
          ),
        ],
        if (status.canCancel) ...[
          AppSizes.s12.heightBox,
          AppButton(
            text: 'Cancel Booking',
            backgroundColor: AppColors.error,
            onPressed: () => ctrl.cancelBooking(booking),
          ),
        ],
      ],
    );
  }
}

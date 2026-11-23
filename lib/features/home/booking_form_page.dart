import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_enums.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';
import 'package:nishit_vadgama/core/helper/date_helper.dart';
import 'package:nishit_vadgama/core/widgets/app_appbar.dart';
import 'package:nishit_vadgama/core/widgets/app_button.dart';
import 'package:nishit_vadgama/core/widgets/app_dropdown.dart';
import 'package:nishit_vadgama/core/widgets/app_form_container.dart';
import 'package:nishit_vadgama/core/widgets/app_page.dart';
import 'package:nishit_vadgama/core/widgets/app_text_field.dart';
import 'package:nishit_vadgama/features/home/booking_form_controller.dart';

class BookingFormPage extends StatelessWidget {
  const BookingFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(BookingFormController());

    return AppPage(
      topCurvedBody: false,
      curvedBody: false,
      backgroundColor: AppColors.primaryBg,
      resizeToAvoidBottomInset: true,
      appBar: AppAppbar(
        title: 'Create Booking',
        showNotification: false,
      ),
      body: Form(
        key: ctrl.formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.s20),
          children: [
            // ── Customer Info ─────────────────────────────────
            AppFormContainer(
              title: 'Customer Information',
              children: [
                AppTextField(
                  controller: ctrl.customerNameCtrl,
                  labelText: 'Customer Name',
                  hintText: 'e.g. Aarav Shah',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(
                    Iconsax.user,
                    size: 18,
                    color: AppColors.grey,
                  ),
                  validator: ctrl.validateName,
                ),
                AppTextField(
                  controller: ctrl.phoneCtrl,
                  labelText: 'Phone Number',
                  hintText: 'e.g. 9876543210',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormator: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  prefixIcon: const Icon(
                    Iconsax.call,
                    size: 18,
                    color: AppColors.grey,
                  ),
                  validator: ctrl.validatePhone,
                ),
              ],
            ),
            AppSizes.s16.heightBox,

            // ── Service & Date ────────────────────────────────
            AppFormContainer(
              title: 'Service Details',
              children: [
                Obx(() => AppDropdown<String>(
                      items: PredefinedService.names,
                      value: ctrl.selectedService.value,
                      labelText: 'Service Type',
                      hintText: 'Select a service',
                      isSearchable: true,
                      prefixIcon: const Icon(
                        Iconsax.briefcase,
                        size: 18,
                        color: AppColors.grey,
                      ),
                      validator: ctrl.validateService,
                      onChanged: (v) => ctrl.selectedService.value = v,
                    )),

                // Date picker field ─────────────────────────────
                Obx(() {
                  final date = ctrl.selectedDate.value;
                  return AppTextField(
                    labelText: 'Booking Date',
                    hintText: 'Select booking date',
                    readOnly: true,
                    controller: TextEditingController(
                      text: date != null
                          ? DateHelper.format(date, pattern: 'dd MMM yyyy')
                          : '',
                    ),
                    prefixIcon: const Icon(
                      Iconsax.calendar,
                      size: 18,
                      color: AppColors.grey,
                    ),
                    suffixIcon: const Icon(
                      Iconsax.arrow_right_3,
                      size: 18,
                      color: AppColors.grey,
                    ),
                    onTap: () => ctrl.pickDate(context),
                  );
                }),
              ],
            ),
            AppSizes.s16.heightBox,

            // ── Notes ─────────────────────────────────────────
            AppFormContainer(
              title: 'Additional Notes',
              children: [
                AppTextField(
                  controller: ctrl.notesCtrl,
                  hintText: 'Enter any special instructions or notes...',
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
              ],
            ),
            AppSizes.s32.heightBox,

            // ── Submit ────────────────────────────────────────
            Obx(() => AppButton(
                  text: 'Create Booking',
                  isLoading: ctrl.isLoading.value,
                  showArrow: true,
                  onPressed: ctrl.submitBooking,
                )),
            AppSizes.s20.heightBox,
          ],
        ),
      ),
    );
  }
}

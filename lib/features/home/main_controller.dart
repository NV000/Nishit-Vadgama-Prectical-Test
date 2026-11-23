import 'package:get/get.dart';
import 'package:nishit_vadgama/core/widgets/app_exit_bottom_sheet.dart';

/// Reactive GetX controller for managing root navigation and bottom bar state.
class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }

  Future<void> onBackInvoked() async {
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
    } else {
      await AppExitBottomSheet.show();
    }
  }
}

import 'package:get/get.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/pages/authentication/login_page.dart';
import 'package:tasmee3/view_model/control_view_model.dart';

class AdminProfileViewModel extends GetxController {
  LocalStorageData localStorageData = Get.find();
  void signOut() {
    localStorageData.deleteUser();
    Get.find<ControlViewModel>().adminChangeSelectedValue(0);
    update();
    Get.offAll(() => LoginScreen());
  }
}

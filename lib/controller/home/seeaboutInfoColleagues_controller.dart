import 'package:get/get.dart';

class SeeAboutInfoColleaguesController extends GetxController {

    final RxMap personalData =
     {}.obs;

      final RxList<Map<String, String>> educationLevels =
      <Map<String, String>>[].obs;

        final RxList<Map<String, String>> practicalExperiences =
      <Map<String, String>>[].obs;

    void setpersonalData(RxMap data) {
    personalData.assignAll(data);
  }

    void setEducationLevels(List<Map<String, String>> data) {
    educationLevels.assignAll(data);
  }

    void setPracticalExperiences(List<Map<String, String>> data) {
    practicalExperiences.assignAll(data);
  }



}
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class NewPostControllerImp extends GetxController {
  RxString postContent = ''.obs;
  RxString selectedPrivacy = 'Any One'.obs;

  postNewPost(videoList,imageList,
      [bool? isPage, String? pageId]) async {
    if (isPage != null && isPage) {
      var url = "$urlStarter/user/postNewPagePost";

      Map<String, dynamic> jsonData = {
        "postContent": postContent.value,
        "videoList": videoList,
        "imageList": imageList,
        "pageId":pageId,
      };
      String jsonString = jsonEncode(jsonData);
      int contentLength = utf8.encode(jsonString).length;
      var responce =
          await http.post(Uri.parse(url), body: jsonString, headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      });
      return responce;
    } else {
      var url = "$urlStarter/user/postNewUserPost";

      Map<String, dynamic> jsonData = {
        "postContent": postContent.value,
        "selectedPrivacy": selectedPrivacy.value,
        "videoList": videoList,
        "imageList": imageList,
       
      };
      String jsonString = jsonEncode(jsonData);
      int contentLength = utf8.encode(jsonString).length;
      var responce =
          await http.post(Uri.parse(url), body: jsonString, headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      });
      return responce;
    }
  }

  post(videoList,imageList,
      [bool? isPage, String? pageId]) async {
        print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
        for (int i = 0; i < imageList.length; i++) {
    print("Image ${i + 1}: ${imageList[i]}");
  }
  print("ooooooooooooooooooooooooo");
     for (int i = 0; i < videoList.length; i++) {
    print("Video ${i + 1}: ${videoList[i]}");
  }
    var res = await postNewPost(
        videoList,imageList, isPage, pageId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      post(videoList,imageList, isPage, pageId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    print(resbody['message']);
    print(res.statusCode);
    if (res.statusCode == 409 || res.statusCode == 500) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
        Get.offNamed(AppRoute.homescreen);
    }
    //print('Posting: ${postContent.value}, Privacy: ${selectedPrivacy.value}');
  }

  void updatePrivacy(String newValue) {
    selectedPrivacy.value = newValue;
    update();
  }

  // for video 


  final RxString postVideoBytes = ''.obs;
  final RxString postVideoBytesName = ''.obs;
  final RxString postVideoExt = ''.obs;

    void updateVideo(
    String base64String,
    String imageName,
    String imageExt,
  ) {
    postVideoBytes.value = base64String;
    postVideoBytesName.value = imageName;
    postVideoExt.value = imageExt;
    update(); // This triggers a rebuild of the widget tree
  }




  ////////////

  final RxString postImageBytes = ''.obs;
  final RxString postImageBytesName = ''.obs;
  final RxString postImageExt = ''.obs;

  void updateProfileImage(
    String base64String,
    String imageName,
    String imageExt,
  ) {
    postImageBytes.value = base64String;
    postImageBytesName.value = imageName;
    postImageExt.value = imageExt;
    update(); // This triggers a rebuild of the widget tree
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/JobsPages/addnewjob.dart';
import 'package:growify/view/screen/homescreen/notificationspages/showPost.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class MyJobController {
  final List<Map<String, dynamic>> jobs = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getFields(String pageId,context) async {
    var url = "$urlStarter/user/getJobFields";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });

    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      getFields(pageId,context);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      if (kIsWeb) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return NewJobPost(
        pageId: pageId,
        availableFields: List<Map<String, dynamic>>.from(
          responseBody['availableFields'],
        ),
      );
    },
  );
} else {
  Get.off(
    NewJobPost(
      pageId: pageId,
      availableFields: List<Map<String, dynamic>>.from(
        responseBody['availableFields'],
      ),
    ),
  );
}


      isLoading = false;
    }

    return;
  }

  getPageJobs(int page, String pageId) async {
    var url =
        "$urlStarter/user/getPageJobs?page=$page&pageSize=$pageSize&pageId=$pageId";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadPageJobs(page, pageId) async {
    if (isLoading) {
      return;
    }

    isLoading = true;
    var response = await getPageJobs(page, pageId);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadPageJobs(page, pageId);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      final List<dynamic>? pageJobs = responseBody["pageJobs"];
      print(pageJobs);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      if (pageJobs != null) {
        final newJob = pageJobs.map((job) {
          return {
            'pageJobId': job['pageJobId'],
            'pageId': job['pageId'],
            'title': job['title'],
            'Fields': job['Fields'],
            'description': job['description'],
            'endDate': job['endDate'],
          };
        }).toList();

        jobs.addAll(newJob);
      }

      isLoading = false;
    }

    return;
  }



  // delete the job 
    final RxList<String> moreOptions = <String>[
    'Delete',
  ].obs;
  onMoreOptionSelected(option, pageid, jobid) async {
    switch (option) {
      case 'Delete':
        return await deleteJob(pageid, jobid);
        break;
    }
  }
    

    postSaveChanges(pageId, jobId) async {
  var url = "$urlStarter/user/deletePageJob";
  var response = await http.post(
    Uri.parse(url),
    body: jsonEncode({
      "pageId": pageId.toString(),  // Corrected key name
      "jobId": jobId,
    }),
    headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    },
  );
  return response;
}

 @override
deleteJob(pageId, jobId) async {
  print("uuuuuuuuuuuuuuuuuuuu");
  print(pageId);
  print("ddddddddddddddddd00000");
  print(jobId);
  try {
    var response = await postSaveChanges(pageId, jobId);  // Await here
    print("ddddddddddddddd");
    print(response.statusCode);

    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      await postSaveChanges(pageId, jobId);  // Await here
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    var responseBody = jsonDecode(response.body);
    print(responseBody['message']);
    print(response.statusCode);

    if (response.statusCode == 409 || response.statusCode == 500) {
      print(response.statusCode);
      return responseBody['message'];
    } else if (response.statusCode == 200) {
      responseBody['message'] = "";
      Get.back();
    }
  } catch (err) {
    print(err);
    return "server error";
  }
}

}

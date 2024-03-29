import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/notificationspages/showPost.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class CompanyJobController {
  final List<Map<String, dynamic>> jobs = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getJobs(page,pageId) async {
    
    var url =
        "$urlStarter/user/getJobs?page=$page&pageSize=$pageSize&pageId=$pageId";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadJobs(page,pageId) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getJobs(page,pageId);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadJobs(page,pageId);
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
        //print(notifications);
      }

      isLoading = false;
    }
    
    /*
    await Future.delayed(const Duration(seconds: 2), () {
    });*/
    return;
  }


  
}

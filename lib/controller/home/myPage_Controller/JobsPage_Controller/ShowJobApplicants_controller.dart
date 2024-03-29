import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());


class JobPost {
  final String title;
  final String Fields;
  final String deadline;
  final String description;
 

  JobPost({
    required this.title,
    required this.Fields,
    required this.deadline,
    required this.description,
   
  });
}

class ShowJobApplicantsController {
  final List<JobPost> jobPosts = [];
  
  final List Aqraba=[];

 
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;
generatePageAccessToken(pageId) async {
  var url = "$urlStarter/user/generatePageAccessToken?pageId=${pageId}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    if (responce.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      generatePageAccessToken(pageId);
      return;
    } else if (responce.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    
    if (responce.statusCode == 409) {
      var resbody = jsonDecode(responce.body);
      return resbody['message'];
    } else if (responce.statusCode == 200) {
      var resbody = jsonDecode(responce.body);
      return resbody['accessToken'];
      
    }
}
  getPageJobs(pageJobId) async {
    var url = "$urlStarter/user/getPageJobApplications?pageJobId=$pageJobId";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadPageJobs(pageJobId) async {
    if (isLoading) {
      return;
    }

    isLoading = true;
    var response = await getPageJobs(pageJobId);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadPageJobs(pageJobId);
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
      print(responseBody["pageJob"]);
       var pageJobData = responseBody["pageJob"];
      jobPosts.add(JobPost(
        title: pageJobData['title'],
        Fields: pageJobData['Fields'],
        deadline: pageJobData['endDate'], 
        description: pageJobData['description'],));
         print("/////////////////////////////////////////*//*/*/*/*/");
          print(responseBody["application"]) ;
          Aqraba.addAll(responseBody["application"]);
          print("hiiiiiiiiiiiiiii");
          print(Aqraba);

     

     
          
      isLoading = false;
    }

  }
getDashboard() async {
    var url = "$urlStarter/user/getUserProfileDashboard";
    var responce = await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  loadDashboard() async {
    var res = await getDashboard();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadDashboard();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      userPostCount = resbody['userPostCount'];
      userConnectionsCount = resbody['userConnectionsCount'];
      print(resbody);
    }
  }

  @override
  Future getprfilepage() async {
    var url =
        "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  @override
  goToprofilepage() async {
    await loadDashboard();
    var res = await getprfilepage();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToprofilepage();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      GetStorage().write("photo", resbody["user"]["photo"]);
      Get.to(ProfileMainPage(
          userData: [resbody["user"]],
          userPostCount: userPostCount,
          userConnectionsCount: userConnectionsCount));
    }
  }

  @override
  Future getUserProfilePage(String userUsername) async {
    var url =
        "$urlStarter/user/getUserProfileInfo?ProfileUsername=$userUsername";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  @override
  goToUserPage(String userUsername) async {
    if (userUsername == GetStorage().read('username')) {
      await goToprofilepage();
      return;
    }
    var res = await getUserProfilePage(userUsername);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToUserPage(userUsername);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      if (resbody['user'] is Map<String, dynamic>) {
        print("ppppp");
        print([resbody["user"]]);
        //  Get.to(ColleaguesProfile(userData: [resbody["user"]]));

        Get.to(() => ColleaguesProfile(userData: [resbody["user"]]));

        return true;
      }
    }
  }



}

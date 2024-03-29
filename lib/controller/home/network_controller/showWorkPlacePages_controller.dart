import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class ShowMyWorkPlacePagesController {
  final List<Map<String, dynamic>> WorkPlacePages = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int pageSize = 10;
  int page = 1;

  getWorkPlacePages(int page) async {
    
    var url =
        "$urlStarter/user/getUserEmployedPages?page=$page&pageSize=$pageSize";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return response;
  }

  Future<void> loadPages(page) async {
    if (isLoading) {
      return;
    }
    
    isLoading = true;
    var response = await getWorkPlacePages(page);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadPages(page);
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
      print("hiiiiiiiiii");
      print(responseBody);
      print("hiiiiiiiiii");

      final List<dynamic>? Pages = responseBody["pages"];
 // Update this line

      print(Pages);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");

      if (Pages != null) {
        final newPages = Pages.map((pages) {
          return {
            'name': pages[
                'name'], 
            'id': pages['id'],
            'photo': pages['photo'],
          };
        }).toList();

        WorkPlacePages.addAll(newPages);
      }

      isLoading = false;
    }
    

    return;
  }


  
}
 





import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

abstract class ForgetPasswordController extends GetxController{
checkemail();
goToVerfiycode(email);
postForgetPassword(email);
}

class ForgetPasswordControllerImp extends ForgetPasswordController{


  late TextEditingController email;

  @override
  checkemail() {
    
  }
  @override
  postForgetPassword(email)async {
        var ipAddress = IpAddress(type: RequestType.text);
    dynamic ip = await ipAddress.getIpAddress();

    var url = "$urlStarter/user/forgetpassword";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email": email.trim(),
          "ipAddress":ip,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    return responce;
  }
  @override
  goToVerfiycode(email)async {
    try {
      var res = await postForgetPassword(email);
      var resbody = jsonDecode(res.body);
      print(resbody['message']);
      print(res.statusCode);
      if(res.statusCode == 409){
        return resbody['message'];
      }else if(res.statusCode == 200 && resbody['message'] == email){
        print(res.statusCode);
        print(resbody['message']);
        resbody['message'] = "";
        Get.offNamed(AppRoute.verifycode);
      }

    } catch(err) {
      print(err);
      return "server error";
    }

 
  }

  @override
  void onInit() {
    email=TextEditingController();
    
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {

    email.dispose();
 
    super.dispose();
  }

}
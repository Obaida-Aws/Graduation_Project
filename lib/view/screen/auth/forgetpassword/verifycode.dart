import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:growify/controller/auth/verifycode_controller.dart';
import 'package:growify/core/functions/alertbox.dart';
import 'package:growify/global.dart';
import 'package:growify/view/widget/auth/textBodyAuth.dart';
import 'package:growify/view/widget/auth/textTitleAuth.dart';

class VerifyCode extends StatelessWidget {
  const VerifyCode({super.key});

  @override
  Widget build(BuildContext context) {
    VerifyCodeControllerImp controller=Get.put(VerifyCodeControllerImp());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white38,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Verification Code",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        child: ListView(
          children: [
         
            const TextTitleAuth(
              text: "Check Code",
            ),
            const SizedBox(
              height: 20,
            ),
            const TextBodyAuth(
                text:
                    "Please Enter The Code That You Received \n\nIn The Email"),
            const SizedBox(
              height: 60,
            ),
             OtpTextField(
              borderRadius: BorderRadius.circular(20),
              fieldWidth: 50,
        numberOfFields: 5,
        borderColor: const Color(0xFF512DA8),
        showFieldAsBox: true, 
        onCodeChanged: (String code) {        
        },
        onSubmit: (String verificationCode) async {
          var message = await controller.goToResetPassword(verificationCode,email);
          (message != null) ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                title: 'Error',
                icon: Icons.error,
                text: message,
                buttonText: 'OK',
              );
            },
          ) : null ;
        }, 
    ),

          ],
        ),
      ),
    );
  }
}

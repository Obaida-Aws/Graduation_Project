import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/widget/homePage/chatmessage.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final textController = TextEditingController();
  bool isLoading = false;
  int pageSize = 15;
  int page = 1;
  void sendMessage(String text) {
    if (text.isNotEmpty) {
      messages.insert(
        0,
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );
      textController.clear();
    }
  }

  getUserMessages(int page, String username, String type) async {
    var url =
        "$urlStarter/user/getUserMessages?page=${page}&pageSize=${pageSize}&type=${type}";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      'username': username,
    });
    return response;
  }

  Future<void> loadUserMessages(page, username, type) async {
    print("innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnm");
    if (isLoading) {
      return;
    }

    isLoading = true;
    var response = await getUserMessages(page, username, type);
    print(response.statusCode);
    if (response.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadUserMessages(page, username, type);
      return;
    } else if (response.statusCode == 401) {
      _logoutController.goTosigninpage();
    }

    if (response.statusCode == 409) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['message']);
      return;
    } else if (response.statusCode == 200) {
      if (type == "U") {}

      var responseBody = jsonDecode(response.body);
      print("////////////////////////////////////////");
      print(List<Map<String, dynamic>>.from(responseBody['messages']));
      List<Map<String, dynamic>> messagesData =
          List<Map<String, dynamic>>.from(responseBody['messages']);

// Create a list to store ChatMessage objects
      List<ChatMessage> chatMessages = [];

// Iterate through the messagesData and create ChatMessage objects
      for (var messageData in messagesData) {
        String text = messageData['text'];
        String senderUsername = messageData['senderUsername'];
        String receiverUsername = messageData['receiverUsername'];
        String? userPhoto = senderUsername != GetStorage().read("username")
            ? messageData['senderUsername_FK']['photo']
            : messageData['receiverUsername_FK']['photo'];

        // Create a ChatMessage object based on the conditions
        ChatMessage chatMessage = ChatMessage(
          text: text?? '',
          isUser: senderUsername == GetStorage().read("username"),
          userName: senderUsername != GetStorage().read("username")
              ? messageData['senderUsername_FK']['username'] 
              : messageData['receiverUsername_FK']['username'],
          userPhoto: (userPhoto==null) ? '': userPhoto,
          createdAt: messageData['createdAt'],
          image: messageData['image'],
        );

        // Add the ChatMessage object to the list
        messages.add(chatMessage);
      }
      /*messages.insert(
        0,
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );*/
      /*final List<dynamic>? userNotifications = responseBody["notifications"];
      print(userNotifications);
      print("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      if (userNotifications != null) {
        final newNotifications = userNotifications.map((notification) {
          return {
            'id': notification['id'],
            'notificationType': notification['notificationType'],
            'notificationContent': notification['notificationContent'],
            'notificationPointer': notification['notificationPointer'],
            'photo': notification['photo'],
            'date': notification['createdAt'],
          };
        }).toList();

        notifications.addAll(newNotifications);
        //print(notifications);
      }*/

      isLoading = false;
    }

    /*
    await Future.delayed(const Duration(seconds: 2), () {
    });*/
    return;
  }
}

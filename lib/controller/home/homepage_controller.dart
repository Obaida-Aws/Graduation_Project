import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/core/constant/routes.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/Calender/Calender.dart';
import 'package:growify/view/screen/homescreen/chat/chatmainpage.dart';
//import 'package:growify/view/screen/homescreen/myPage/ColleaguesPageProfile.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:growify/view/screen/homescreen/settings/myPages.dart';
import 'package:growify/view/widget/homePage/commentsMainpage.dart';
import 'package:growify/view/widget/homePage/like.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());

class CommentModel {
  final int? postId;
  final String username;
  final String comment;
  final AssetImage userImage;
  final DateTime time;
  final RxInt likes;
  final String email;
  final RxBool isLiked;

  CommentModel({
    required this.username,
    this.postId,
    required this.comment,
    required this.userImage,
    required this.time,
    required this.email,
    bool isLiked = false,
    int likes = 0,
  })  : likes = likes.obs,
        isLiked = isLiked.obs;
}

late int userPostCount;
late int userConnectionsCount;

abstract class HomePageController extends GetxController {
  goToSignup();
  goToForgetPassword();
  goToProfileColleaguesPage(String email);

  goToSettingsPgae();
  goToprofilepage();
  getprfilepage();
  getprfileColleaguespage(String email);

  //// for comment
  getprofilefromcomment(String email);
  gotoprofileFromcomment(String email);
  addComment(String username, String newComment, String email, int thePostId);
  toggleLikecomment(int index);
  gotoCommentPage(int id);
  //
  //
  goToCalenderPage();
}

class HomePageControllerImp extends HomePageController {
//////////////

  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;
  ///////////////////

  final RxList<CommentModel> comments = <CommentModel>[].obs;

  final RxList<CommentModel> comments1 = <CommentModel>[
    CommentModel(
      username: 'User1',
      comment: 'This is a comment.',
      userImage: const AssetImage('images/islam.jpeg'),
      time: DateTime.now(),
      email: 'awsobaida07@gmail.com',
      likes: 12,
      isLiked: true,
    ),
    CommentModel(
      username: 'User2',
      comment: 'Nice post!',
      userImage: const AssetImage('images/Netflix.png'),
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      likes: 5,
      email: 'awsobaida07@gmail.com',
    ),
    CommentModel(
      username: 'User3',
      comment: 'Great content.',
      userImage: const AssetImage('images/harri.png'),
      time: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 10,
      email: 's11923787@stu.najah.edu',
    ),
  ].obs;

  final RxList<Map<String, dynamic>> likesOnComment = <Map<String, dynamic>>[
    {
      'name': 'Islam Aws',
      'username': '@islam_aws',
      'image': 'images/islam.jpeg',
      'email': 'awsobaida07@gmail.com',
    },
    {
      'name': 'Obaida Aws',
      'username': '@obaida_aws',
      'image': 'images/obaida.jpeg',
      'email': 's11923787@stu.najah.edu',
    },
    // Add more colleagues as needed
  ].obs;

  final RxList<Map<String, dynamic>> likes = <Map<String, dynamic>>[
    {
      'name': 'Islam Aws',
      'username': '@islam_aws',
      'image': 'images/islam.jpeg',
      'email': 'awsobaida07@gmail.com',
    },
    {
      'name': 'Obaida Aws',
      'username': '@obaida_aws',
      'image': 'images/obaida.jpeg',
      'email': 's11923787@stu.najah.edu',
    },
    // Add more colleagues as needed
  ].obs;

  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[
    {
      'name': 'Obaida Aws',
      'id': 1,
      'time': '1 hour ago',
      'content': 'Computer engineer in my fifth year at Al Najah University.',
      'image': 'images/obaida.jpeg',
      'like': 165,
      'comment': 87,
      'isLiked': false,
      'email': 's11923787@stu.najah.edu',
    },
    {
      'name': 'Islam Aws',
      'id': 2,
      'time': '2 hours ago',
      'content': 'This is my brother, and he is 8 months old.',
      'image': 'images/islam.jpeg',
      'like': 123,
      'comment': 46,
      'isLiked': false,
      'email': 'awsobaida07@gmail.com',
    },
  ].obs;

  int getLikes(int index) {
    return posts[index]['like'];
  }

  int getComments(int index) {
    return posts[index]['comment'];
  }

  void toggleLike(int index) {
    final post = posts[index];
    post['isLiked'] = !post['isLiked'];

    if (post['isLiked']) {
      post['like']++;
      addLike({
        'name': 'Islam Aws',
        'username': '@islam_aws',
        'image': 'images/islam.jpeg',
        'email': 'awsobaida07@gmail.com'
      });
    } else {
      removeLike('awsobaida07@gmail.com');
      post['like']--;
    }

    update(); // Notify GetBuilder to rebuild
  }

  bool isLiked(int index) {
    return posts[index]['isLiked'];
  }

  RxList<String> moreOptions = <String>[
    'Save Post',
    'Hide Post',
  ].obs;

  void onMoreOptionSelected(String option) {
    // Handle the selected option here
    switch (option) {
      case 'Save Post':
        // Implement save post functionality
        break;
      case 'Hide Post':
        // Implement hide post functionality
        break;
      // Add more options as needed
    }
  }

  //////////////////////////////

  @override
  void addComment(
      String username, String newComment, String email, int thePostId) {
    const userImage = AssetImage('images/obaida.jpeg');
    final time = DateTime.now();
    comments.add(CommentModel(
        username: username,
        comment: newComment,
        userImage: userImage,
        time: time,
        email: email));
  }

  @override
  void toggleLikecomment(int index) {
    final comment = comments[index];
    comment.isLiked.value = !comment.isLiked.value;

    if (comment.isLiked.value) {
      comment.likes.value++;
      addLikeOnComment({
        'name': 'Islam Aws',
        'username': '@islam_aws',
        'image': 'images/islam.jpeg',
        'email': 'awsobaida07@gmail.com',
      });
    } else {
      removeLikeFromComment('awsobaida07@gmail.com');
      comment.likes.value--;
    }

    update(); // Notify GetBuilder to rebuild
  }

  @override
  void gotoCommentPage(int id) {
    Get.to(const CommentsMainPage(), arguments: {
      'comments': comments1,
    });
  }

  @override
  Future getprofilefromcomment(String email) async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=$email";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    //print(responce);
    return responce;
  }

  @override
  Future gotoprofileFromcomment(String email) async {
    var res = await getprofilefromcomment(email);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      gotoprofileFromcomment(email);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      Get.to(ColleaguesProfile(userData: [resbody["user"]]));
    }
  }

  @override
  void addLikeOnComment(Map<String, dynamic> likesOnComment) {
    likes.add(likesOnComment);
    update(); // Notify listeners
  }

  @override
  void removeLikeFromComment(String email) {
    likes.removeWhere((likesOnComment) => likesOnComment['email'] == email);
    update(); // Notify listeners
  }

  @override
  void addLike(Map<String, dynamic> newLike) {
    likes.add(newLike);
    update(); // Notify listeners
  }

  @override
  void removeLike(String email) {
    likes.removeWhere((like) => like['email'] == email);
    update(); // Notify listeners
  }

  @override
  void goToLikePage(int postId) {
    Get.to(const Like());
  }

  @override
  goToSettingsPgae() {
    Get.toNamed(AppRoute.settings);
  }

  @override
  goToSignup() {
    Get.offNamed(AppRoute.signup);
  }

  @override
  goToForgetPassword() {
    Get.to(AppRoute.forgetpassword);
  }
  goToMyPages() {
    Get.to(MyPages());
  }

  getDashboard() async {
    var url = "$urlStarter/user/getUserProfileDashboard";
    var responce = await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    //print(responce);
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
      //print(resbody);
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
    //print(responce);
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
  Future getprfileColleaguespage(String email) async {
    var url = "$urlStarter/user/settingsGetMainInfo?email=$email";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    //print(responce);
    return responce;
  }

  @override
  goToProfileColleaguesPage(String email) async {
    var res = await getprfileColleaguespage(email);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToProfileColleaguesPage(email);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      Get.to(ColleaguesProfile(userData: [resbody["user"]]));
    }
  }

  ///////////////////////////////////////////////////////////
  //here we have two list ,
  // the first one to get my colleagues , (row in the page)
  //the second one Colleagues I contacted "send message to him Recently"
  final RxList<Map<String, dynamic>> Mycolleagues =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> colleaguesPreviousmessages =
      <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    // Initialize the RxList

    super.onInit();
  }

  getChats() async {
    var url = "$urlStarter/user/getChats";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  goToChat() async {
    var res = await getChats();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToChat();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      Mycolleagues.clear();
      for (var conversation in resbody['activeConnectionsInfo']) {
        var name = conversation["firstname"] + " " + conversation["lastname"];
        var username = conversation["username"];
        var photo = conversation["photo"];
        final Map<String, dynamic> extractedInfo = {
          'name': name,
          'username': username,
          'photo': photo,
          'type':"U",
        };
        Mycolleagues.add(extractedInfo);
      }
      /*Mycolleagues.assignAll(
          List<Map<String, dynamic>>.from(resbody['activeConnectionsInfo']));*/
      colleaguesPreviousmessages.clear();
      for (var conversation
          in List<Map<String, dynamic>>.from(resbody['uniqueConversations'])) {
        var name;
        var username;
        var photo;
        String type = "U";
        if (conversation['senderUsername_FK'] != null &&
            conversation['senderUsername_FK']['username'] !=
                GetStorage().read('username')) {
          name = conversation['senderUsername_FK']['firstName'] +
              " " +
              conversation['senderUsername_FK']['lastName'];
          username = conversation['senderUsername_FK']['username'];
          photo = conversation['senderUsername_FK']['photo'];
          type = "U";
        } else if (conversation['receiverUsername_FK'] != null &&
            conversation['receiverUsername_FK']['username'] !=
                GetStorage().read('username')) {
          name = conversation['receiverUsername_FK']['firstName'] +
              " " +
              conversation['senderUsername_FK']['lastName'];
          username = conversation['receiverUsername_FK']['username'];
          photo = conversation['receiverUsername_FK']['photo'];
          type = "U";
        } else if (conversation['senderPageId_FK'] != null) {
          name = conversation['senderPageId_FK']['name'];
          username = conversation['senderPageId_FK']['id'];
          photo = conversation['senderPageId_FK']['photo'];
          type = "P";
        } else if (conversation['receiverPageId_FK'] != null) {
          name = conversation['receiverPageId_FK']['name'];
          username = conversation['receiverPageId_FK']['id'];
          photo = conversation['receiverPageId_FK']['photo'];
          type = "P";
        }
        final Map<String, dynamic> extractedInfo = {
          'name': name,
          'username': username,
          'photo': photo,
          'type': type,
        };

        colleaguesPreviousmessages.add(extractedInfo);
      }
      //print(colleaguesPreviousmessages);
    }
  }

  goToChatPage() async {
    await goToChat();
    Get.to(const ChatMainPage(), arguments: {
      'Mycolleagues': Mycolleagues,
      'colleaguesPreviousmessages': colleaguesPreviousmessages,
    });
  }
  getUserChatProfileInfo(String username) async {
    var url = "$urlStarter/user/getUserProfileInfo?ProfileUsername=${username}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }
  userChatProfileInfo(String username)async {
    var res = await getUserChatProfileInfo(username);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      userChatProfileInfo(username);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      print(resbody["user"]);
      var name = resbody["user"]["firstname"] + " " + resbody["user"]["lastname"];
      var photo = resbody["user"]["photo"];
      final Map<String, dynamic> extractedInfo = {
          'name': name,
          'username': username,
          'photo': photo,
          'type': "U",
        };
        print(extractedInfo);
        return extractedInfo;
    }
  }
  @override
  goToCalenderPage() {
    Get.to(const Calender());
  }
}

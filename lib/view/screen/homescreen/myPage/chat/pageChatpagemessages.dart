import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/controller/home/myPage_Controller/chat_controller/pageChatmainpage_controller.dart';
import 'package:growify/controller/home/myPage_Controller/chat_controller/pageChatspage_cnotroller.dart';
import 'package:growify/global.dart';
import 'package:growify/resources/jitsi_meet.dart';
import 'package:growify/view/screen/homescreen/chat/CallScreen.dart';
import 'package:growify/view/widget/homePage/chatmessage.dart';
import 'package:peerdart/peerdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;

class pageChatpagemessages extends StatefulWidget {
  final data;
  final pageId;
  final pageName;
  final pagePhoto;
  final pageAccessToken;
  const pageChatpagemessages(
      {super.key,
      this.data,
      required this.pageId,
      required this.pageName,
      required this.pagePhoto,
      required this.pageAccessToken});

  @override
  pageChatpagemessagesState createState() => pageChatpagemessagesState();
}

final ScrollController scrollController = ScrollController();

class pageChatpagemessagesState extends State<pageChatpagemessages> {
  final PageChatMainPageController controller =
      Get.put(PageChatMainPageController());
  var accessToken;
  late PageChatController chatController;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  late IO.Socket socket;
  var receivedCallAudio;
  var receivedCallAudioCounter = 0;
  String? messageImageBytes;
  String? messageImageBytesName;
  String? messageImageExt;
  String? messageVideoBytes;
  String? messageVideoBytesName;
  String? messageVideoExt;
  ImageProvider<Object> profileBackgroundImage =
      AssetImage("images/profileImage.jpg");

  final LogOutButtonControllerImp _logoutController =
      Get.put(LogOutButtonControllerImp());
  _initCallingListener() async {
    /*var authUrl = '$urlSSEStarter/userNotifications/notificationsAuth';
    var responce = await http.get(Uri.parse(authUrl), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });*/

    if (receivedCallAudio != null) {
      receivedCallAudio.currentPosition.listen((position) {
        if (receivedCallAudio != null &&
            position != null &&
            receivedCallAudio.current != null &&
            receivedCallAudio.current.hasValue &&
            receivedCallAudio.current.value != null) {
          print(position);
          print(receivedCallAudio.current.value?.audio.duration);
          print(receivedCallAudioCounter);

          if (position.inMilliseconds >= 4700) {
            receivedCallAudioCounter++;
            print(mounted);
            if (mounted) setState(() {});

            //position.inMilliseconds = 0;
            if (receivedCallAudioCounter >= 5) {
              decline();
              incomingSDPOffer = null;
              if (mounted) setState(() {});
            }
          }
        }
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    accessToken = widget.pageAccessToken;
    receivedCallAudio = AssetsAudioPlayer();
    receivedCallAudioCounter = 0;
    incomingSDPOffer = null;
    chatController = PageChatController();
    _socketConnect();
    _initCallingListener();
    _loadData();

    _scrollController.addListener(_scrollListener);
  }

  _socketConnect() async {
    try {
      /*var authUrl = '$urlSSEStarter/userNotifications/notificationsAuth';
      var responce = await http.get(Uri.parse(authUrl), headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + GetStorage().read('accessToken'),
      });*/
      socket = IO.io(urlSSEStarter, <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      socket.connect();
      socket.emit("/PageLogin", accessToken); //authenticate the user
      socket.onConnect((data) => {
            // read authentication status
            socket.on("status", (status) async {
              if (status == 403) {
                //accessToken expired
                accessToken = controller.generatePageAccessToken(widget.pageId);

                _socketConnect();
                return;
              } else if (status == 401) {
                //not valid accessToken
                accessToken = controller.generatePageAccessToken(widget.pageId);

                _socketConnect();
              } else if (status == 200) {
                //authenticated
              }
            }),
            socket.on("/chatStatus", (msg) async {
              //chat message token expired handle
              if (msg["status"] == 403) {
                accessToken = controller.generatePageAccessToken(widget.pageId);
                //reSend the message
                socket.emit("/pageChat", {
                  "message": msg["message"],
                  "token": accessToken,
                  "username": widget.data["username"],
                  "messageImageBytes": msg["messageImageBytes"],
                  "messageImageBytesName": msg["messageImageBytesName"],
                  "messageImageExt": msg["messageImageExt"],
                  "messageVideoBytes": msg["messageVideoBytes"],
                  "messageVideoBytesName": msg["messageVideoBytesName"],
                  "messageVideoExt": msg["messageVideoExt"],
                });
                return;
              } else if (msg["status"] == 401) {
                accessToken = controller.generatePageAccessToken(widget.pageId);
              }
            }),
            socket.on("/chat", (msg) {
              print(msg["video"]);
              print(
                  "ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");

              if (mounted) {
                setState(() {
                  chatController.messages;
                });
              }
              if (msg["sender"] == widget.data['username']) {
                // handel of user A,B,C has socket, A send to B message, but B is in C conversation (Dont show A message is B conversation)
                chatController.addMessage(
                    msg["message"],
                    msg["sender"],
                    widget.data["photo"],
                    msg["date"],
                    msg["image"],
                    msg["video"]);
              }
            }),
            socket.on("/chatMyVideo", (msg) {
              chatController.sendMessage(
                  msg["message"], msg["image"], msg["video"]);
            }),
            socket!.on("callEnded", (data) async {
              incomingSDPOffer = null;
              stopCallingSound();
              if (mounted) setState(() {});
            }),
          });

      print(socket.connected);
    } catch (err) {
      print(err);
    }
  }

  void playCallingSound() {
    receivedCallAudio = AssetsAudioPlayer();
    if (kIsWeb) {
      receivedCallAudio.open(Audio.network("audio/receivedCall.mp3"),
          loopMode: LoopMode.single);
    } else {
      receivedCallAudio.open(Audio("audio/receivedCall.mp3"),
          loopMode: LoopMode.single);
    }
    _initCallingListener();
    receivedCallAudio.play();
  }

  stopCallingSound() {
    receivedCallAudio.pause();
    receivedCallAudioCounter = 0;
    //receivedCallAudio = AssetsAudioPlayer();
  }

  _loadData() async {
    print('Loading data...');
    try {
      await chatController.loadUserMessages(chatController.page,
          widget.data['username'], widget.data['type'], widget.pageId);
      print(mounted);
      print("bbbbbbbbbbbbbbbbbbbbbbbb");
      if (mounted)
        setState(() {
          chatController.page++;
          chatController.messages;
        });
      print('Data loaded:');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    print(_scrollController.offset);
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // reached the bottom, load more notifications
      _loadData();
    }
  }

  @override
  void dispose() {
    chatController.dispose();
    _scrollController.dispose();
    socket.clearListeners();
    socket.dispose();
    if (receivedCallAudio != null) {
      receivedCallAudio.stop();
      receivedCallAudio.dispose();
    }

    receivedCallAudio = null;
    print("aaaa");
    if (incomingSDPOffer != null)
      socket!.emit("leavePageCall", {
        "user1": incomingSDPOffer["callerId"]!,
        "user2": widget.pageId,
      });
    super.dispose();
  }

  _joinCall(
      {required String callerId,
      required String calleeId,
      dynamic offer,
      String? photo,
      bool? isVideo,
      String? type,
      }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          callerId: callerId,
          calleeId: calleeId,
          offer: offer,
          photo: photo,
          socket: socket,
          isVideo: isVideo,
          type: type,
          onCallEnded: () {
            // rebuild the parent screen
            final chatPageState = widget.key;
            print(incomingSDPOffer);
            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  decline() {
    socket!.emit("leavePageCall", {
      "user1": incomingSDPOffer["callerId"]!,
      "user2": widget.pageId,
    });
    stopCallingSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true, // Display messages in reverse order
                controller: _scrollController,
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  //return chatController.messages[index];
                  return ChatMessage(
                    text: chatController.messages[index].text,
                    isUser: chatController.messages[index].isUser,
                    userName: chatController.messages[index].userName,
                    userPhoto: chatController.messages[index].userPhoto,
                    createdAt: chatController.messages[index].createdAt,
                    image: chatController.messages[index].image,
                    video: chatController.messages[index].video,
                    existingVideoController:
                        chatController.messages[index].existingVideoController,
                  );
                },
              );
            }),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 20, bottom: 5, right: 10),
      color: Colors.blue,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                if (receivedCallAudio != null) {
                  receivedCallAudio.stop();
                  receivedCallAudio.dispose();
                }

                receivedCallAudio = null;
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child:  SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              widget.data['name'],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.video_call),
                            color: Colors.white,
                            onPressed: () {
                              //createPeerConn(GetStorage().read('username'), widget.data["username"]);

                              //createNewMeeting();

                              _joinCall(
                                callerId: widget.pageId,
                                calleeId: widget.data["username"],
                                photo: widget.pagePhoto,
                                type: "P",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.call),
                            color: Colors.white,
                            onPressed: () {
                              //createPeerConn(GetStorage().read('username'), widget.data["username"]);

                              //createNewMeeting();

                              _joinCall(
                                callerId: widget.pageId,
                                calleeId: widget.data["username"],
                                photo: widget.pagePhoto,
                                isVideo: false,
                                type: "P",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon:
                (messageImageBytes != null) //choose icon based on image status
                    ? const Icon(Icons.cancel)
                    : const Icon(Icons.photo),
            onPressed: () async {
              try {
                if (messageImageBytes != null) {
                  //if user repress image button
                  setState(() {
                    messageImageBytes = null;
                    messageImageBytesName = null;
                    messageImageExt = null;
                  });
                } else {
                  final result = await FilePicker.platform.pickFiles(
                    //choose image
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                    allowMultiple: false,
                  );
                  if (result != null && result.files.isNotEmpty) {
                    PlatformFile file = result.files.first;
                    if (file.extension == "jpg" ||
                        file.extension == "jpeg" ||
                        file.extension == "png") {
                      String base64String;
                      if (kIsWeb) {
                        final fileBytes = file.bytes;
                        base64String = base64Encode(fileBytes as List<int>);
                      } else {
                        List<int> fileBytes =
                            await File(file.path!).readAsBytes();
                        base64String = base64Encode(fileBytes);
                      }
                      setState(() {
                        messageImageBytes = base64String;
                        messageImageBytesName = file.name;
                        messageImageExt = file.extension;
                      });
                    } else {
                      setState(() {
                        messageImageBytes = null;
                        messageImageBytesName = null;
                        messageImageExt = null;
                      });
                    }
                  } else {
                    // User canceled the picker
                    setState(() {
                      messageImageBytes = null;
                      messageImageBytesName = null;
                      messageImageExt = null;
                    });
                  }
                }
              } catch (err) {
                print(err);
                setState(() {
                  messageImageBytes = null;
                  messageImageBytesName = null;
                  messageImageExt = null;
                });
              }
            },
          ),
          IconButton(
            icon: (messageVideoBytes != null)
                ? const Icon(Icons.cancel)
                : const Icon(Icons.videocam),
            onPressed: () async {
              try {
                if (messageVideoBytes != null) {
                  // User cancels the video selection
                  setState(() {
                    messageVideoBytes = null;
                    messageVideoBytesName = null;
                    messageVideoExt = null;
                  });
                } else {
                  // Open file picker for video
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp4', 'avi', 'mov'],
                    allowMultiple: false,
                  );

                  if (result != null && result.files.isNotEmpty) {
                    PlatformFile file = result.files.first;
                    if (file.extension == "mp4" ||
                        file.extension == "avi" ||
                        file.extension == "mov") {
                      // Process the selected video
                      String base64String;
                      if (kIsWeb) {
                        final fileBytes = file.bytes;
                        base64String = base64Encode(fileBytes as List<int>);
                      } else {
                        List<int> fileBytes =
                            await File(file.path!).readAsBytes();
                        base64String = base64Encode(fileBytes);
                      }

                      setState(() {
                        messageVideoBytes = base64String;
                        messageVideoBytesName = file.name;
                        messageVideoExt = file.extension;
                      });
                    } else {
                      // File is not a video
                      setState(() {
                        messageVideoBytes = null;
                        messageVideoBytesName = null;
                        messageVideoExt = null;
                      });
                    }
                  } else {
                    // User canceled the picker
                    setState(() {
                      messageVideoBytes = null;
                      messageVideoBytesName = null;
                      messageVideoExt = null;
                    });
                  }
                }
              } catch (err) {
                print(err);
                setState(() {
                  messageVideoBytes = null;
                  messageVideoBytesName = null;
                  messageVideoExt = null;
                });
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: chatController.textController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
              maxLines: null, // Allows for multiple lines
              keyboardType: TextInputType.multiline, // Enables the Enter key
              onSubmitted: (value) {
                chatController.textController.text += '\n';
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              final messageText = chatController.textController.text.trim();
              if ((messageText.isNotEmpty || messageImageBytes != null) &&
                  messageVideoBytes == null) {
                //one of them not null
                chatController.sendMessage(chatController.textController.text,
                    messageImageBytes, messageVideoBytes);
                //show message to this user

                //emit message to server
                socket.emit("/pageChat", {
                  "message": chatController.textController.text,
                  "token": accessToken,
                  "username": widget.data["username"],
                  "messageImageBytes": messageImageBytes,
                  "messageImageBytesName": messageImageBytesName,
                  "messageImageExt": messageImageExt,
                  "messageVideoBytes": messageVideoBytes,
                  "messageVideoBytesName": messageVideoBytesName,
                  "messageVideoExt": messageVideoExt,
                });
                if (mounted) {
                  setState(() {
                    chatController.messages;
                    messageImageBytes = null;
                    messageImageBytesName = null;
                    messageImageExt = null;

                    messageVideoBytes = null;
                    messageVideoBytesName = null;
                    messageVideoExt = null;
                  });
                }
                chatController.textController.clear();
              } else if (messageVideoBytes != null) {
                //emit message to server
                socket.emit("/pageChat", {
                  "message": chatController.textController.text,
                  "token": accessToken,
                  "username": widget.data["username"],
                  "messageImageBytes": messageImageBytes,
                  "messageImageBytesName": messageImageBytesName,
                  "messageImageExt": messageImageExt,
                  "messageVideoBytes": messageVideoBytes,
                  "messageVideoBytesName": messageVideoBytesName,
                  "messageVideoExt": messageVideoExt,
                });
                if (mounted) {
                  setState(() {
                    messageImageBytes = null;
                    messageImageBytesName = null;
                    messageImageExt = null;

                    messageVideoBytes = null;
                    messageVideoBytesName = null;
                    messageVideoExt = null;
                  });
                }
                chatController.textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

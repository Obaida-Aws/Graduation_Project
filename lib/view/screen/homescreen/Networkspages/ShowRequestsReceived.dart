import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/network_controller/ShowRequestsReceived_controller.dart';
import 'package:growify/controller/home/network_controller/networdkmainpage_controller.dart';
import 'package:growify/global.dart';

class ShowRequestsReceived extends StatefulWidget {
  const ShowRequestsReceived({Key? key}) : super(key: key);

  @override
  _ShowRequestsReceivedState createState() => _ShowRequestsReceivedState();
}

final ScrollController scrollController = ScrollController();

class _ShowRequestsReceivedState extends State<ShowRequestsReceived> {
  final NetworkMainPageControllerImp Networkcontroller =
      Get.put(NetworkMainPageControllerImp());
  late ShowRequestsReceivedController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");

  @override
  void initState() {
    super.initState();
    _controller = ShowRequestsReceivedController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadNotifications(_controller.page);
      setState(() {
        _controller.page++;
        _controller.requestsReceived;
      });
      print(
          'Data loaded: ${_controller.requestsReceived.length} requestsReceived');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests Received'),
      ),
      body: Column(
        children: [
          const Divider(
            color: Color.fromARGB(255, 194, 193, 193),
            thickness: 2.0,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _controller.requestsReceived.length,
              itemBuilder: (context, index) {
                final received = _controller.requestsReceived[index];
                final firstname = received['firstname'];
                final lastname = received['lastname'];
                final username = received['username'];

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        final userUsername = username;
                              Networkcontroller.goToUserPage(userUsername!);
                      },
                      trailing: CircleAvatar(
                        backgroundImage: (received['photo'] != null &&
                                received['photo'] != "")
                            ? Image.network("$urlStarter/" + received['photo']!)
                                .image
                            : defultprofileImage,
                      ),
                      title: Text('$firstname $lastname'),
                      subtitle: Text('$username'),
                      
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 194, 193, 193),
                      thickness: 2.0,
                    ),
                  ],
                );
              },
            ),
          ),
          if (_controller.isLoading) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

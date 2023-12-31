import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/ShowAllMyJobs_controller.dart';
import 'package:growify/controller/home/myPage_Controller/JobsPage_Controller/companyJob_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/JobsPages/showthejob.dart';

class CompanyJobPage extends StatefulWidget {
  const CompanyJobPage({Key? key}) : super(key: key);

  @override
  _CompanyJobPageState createState() => _CompanyJobPageState();
}

final ScrollController scrollController = ScrollController();

class _CompanyJobPageState extends State<CompanyJobPage> {
  late CompanyJobController _controller;
  final ScrollController _scrollController = ScrollController();
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  final SearchControllerImp searchController = Get.put(SearchControllerImp());

  @override
  void initState() {
    super.initState();
    _controller = CompanyJobController();
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    print('Loading data...');
    try {
      await _controller.loadNotifications(_controller.page);
      setState(() {
        _controller.page++;
        _controller.jobs;
      });
      print('Data loaded: ${_controller.jobs.length} jobs');
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // reached the bottom, load more notifications
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
        title: const Text('Notifications'),
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
              itemCount: _controller.jobs.length,
              itemBuilder: (context, index) {
                final job = _controller.jobs[index];

                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundImage: (job['photo'] != null &&
                                  job['photo'] != "")
                              ? Image.network("$urlStarter/" + job['photo']!)
                                  .image
                              : defultprofileImage,
                        ),
                        title: Text(
                          "${job['notificationContent']}",
                          
                        ),
                        trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () {
                              Get.to(ShowTheJob());
                            },
                          ),
                        ],
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Deadline: ${job['date']}'),
                            const SizedBox(height: 8),
                            Text(job['notificationContent']),
                          ],
                        ),
                      ),
                    ],
                  ),
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












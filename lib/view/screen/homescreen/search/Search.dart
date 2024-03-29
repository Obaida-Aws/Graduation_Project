import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/ColleaguesProfile_controller.dart';
import 'package:growify/controller/home/Search_Cotroller.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/chat/chatForWeb/chatWebmainpage.dart';
import 'package:growify/view/screen/homescreen/myPage/JobsPages/showthejob.dart';
import 'package:growify/view/screen/homescreen/taskes/tasksmainpage.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class Search extends StatefulWidget {
  final List<Map<String, dynamic>> availableFields;
  const Search({Key? key, required this.availableFields}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  

  final SearchControllerImp controller = Get.put(SearchControllerImp());
  final ColleaguesProfileControllerImp _controller2 =
      Get.put(ColleaguesProfileControllerImp());
  final GlobalKey<FormState> formstate = GlobalKey();
  bool isLoading = false;
  var searchType = "U";
  final AssetImage defultprofileImage =
      const AssetImage("images/profileImage.jpg");
  ImageProvider<Object>? profileBackgroundImage;
  String? profileImage;
  late HomePageControllerImp HPcontroller = Get.put(HomePageControllerImp());
  ImageProvider<Object> avatarImage =
      const AssetImage("images/profileImage.jpg");
  String name =
      GetStorage().read("firstname") + " " + GetStorage().read("lastname");
  final LogOutButtonControllerImp logoutController =
      Get.put(LogOutButtonControllerImp());
  @override
  void initState() {
    super.initState();
    // Initialize non-dependent state here
    updateAvatarImage();
     controller.items.clear();
    controller.items = RxList<String>.from(
      widget.availableFields.map<String>((map) => map['Field'].toString()),
    );
    
  }

  void updateAvatarImage() {
    String profileImage = GetStorage().read("photo") ?? "";
    setState(() {
      avatarImage = (profileImage.isNotEmpty)
          ? Image.network("$urlStarter/$profileImage").image
          : const AssetImage("images/profileImage.jpg");
    });
  }

  @override
  Widget build(BuildContext context) {
    
    if (kIsWeb) {
      return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Color.fromARGB(0, 255, 251, 254),
                child: InkWell(
                  onTap: () {
                    HPcontroller.goToprofilepage();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: avatarImage,
                        ),
                        accountName: Text(
                          name ?? "",
                          style: const TextStyle(color: Colors.black),
                        ),
                        accountEmail: const Text(
                          "View profile",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ListTile(
                        title: const Text("Settings"),
                        leading: const Icon(Icons.settings),
                        onTap: () {
                          HPcontroller.goToSettingsPgae();
                        },
                      ),
                      ListTile(
                        title: const Text("Calender"),
                        leading: const Icon(Icons.calendar_today_rounded),
                        onTap: () {
                          HPcontroller.goToCalenderPage();
                        },
                      ),
                      ListTile(
                        title: const Text("Tasks"),
                        leading: const Icon(Icons.task),
                        onTap: () {
                          Get.to(const TasksHomePage());
                        },
                      ),
                      ListTile(
                        title: const Text("My Pages"),
                        leading: const Icon(Icons.contact_page),
                        onTap: () {
                          HPcontroller.goToMyPages();
                        },
                      ),
                      ListTile(
                        title: const Text("Log Out"),
                        leading: const Icon(Icons.logout_outlined),
                        onTap: () async {
                          await logoutController.goTosigninpage();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Color(0xfffefbfe),
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(70),
                    child: AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Get.back(); // Navigate back
                        },
                      ),
                      title: Form(
                        key: formstate,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 7),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 30),
                                  suffixIcon: InkWell(
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    onTap: () {
                                      if (formstate.currentState!.validate()) {
                                        setState(() {
                                          isLoading = false;
                                          controller.Upage = 1;
                                          controller.userList.clear();
                                          controller.pageList.clear();
                                          controller.jobeList.clear();
                                        });
                                        print(searchType);
                                        controller.goTosearchPage(
                                            controller.searchValue,
                                            controller.Upage,
                                            searchType);
                                      } else {
                                        print("Not Valid");
                                      }
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                validator: (value) {
                                  controller.searchValue = value;
                                  if (value == null || value.isEmpty) {
                                    return "";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
              IconButton(
                  icon: const Icon(
                    Icons.tune, // Replace with your filter icon
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (searchType == "U") {
                      // Handle filter for Users
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Filter for Users'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First TextField with Checkbox
                           Obx(
                        () =>    Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 30,
                                            ),
                                            label: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9),
                                              child: const Text(" Country"),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text(
                                            'Select Country',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: controller.countryList
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value:
                                              controller.country.value.isEmpty
                                                  ? null
                                                  : controller.country.value,
                                          onChanged: (value) {
                                            controller.country.value =
                                                value.toString();
                                            print(controller.country.value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select country';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                   Checkbox(
                                      value: controller
                                          .isSaveVisibleCountryUser.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleCountryUser
                                            .value = value!;
                                      },
                                    ),
                                  
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),
                           Obx(
                        () =>    Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 30,
                                            ),
                                            label: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9),
                                              child: const Text(" Gender"),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text(
                                            'Select Gender',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: controller.genderList
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value: controller.gender.value.isEmpty
                                              ? null
                                              : controller.gender.value,
                                          onChanged: (value) {
                                            controller.gender.value =
                                                value.toString();
                                            print(controller.gender.value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select gender';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                   Checkbox(
                                      value: controller
                                          .isSaveVisibleGenderUser.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleGenderUser
                                            .value = value!;
                                      },
                                    ),
                                 
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),
                             Obx(
                        () =>  Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 350,
                                      child: MultiSelectDropDown(
                                        searchEnabled: true,
                                        onOptionSelected:
                                            (List<ValueItem> selectedOptions) {
                                          controller.selectedItems.assignAll(
                                              selectedOptions
                                                  .map((item) => item.value));
                                        },
                                        options: controller.items
                                            .map((item) => ValueItem(
                                                label: item, value: item))
                                            .toList(),
                                        selectionType: SelectionType.multi,
                                        chipConfig: const ChipConfig(
                                            wrapType: WrapType.scroll),
                                        dropdownHeight: 300,
                                        optionTextStyle:
                                            const TextStyle(fontSize: 16),
                                        selectedOptionIcon:
                                            const Icon(Icons.check_circle),
                                      ),
                                    ),
                                  ),
                                   Checkbox(
                                      value: controller
                                          .isSaveVisibleFieldsUser.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleFieldsUser
                                            .value = value!;
                                      },
                                    ),
                                  
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),

                            Obx(
                        () =>   Row(
                                children: [
                                  Text(
                                    "Highest Connection",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                               Checkbox(
                                      value: controller
                                          .isSaveVisibleConnectionUser.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleConnectionUser
                                            .value = value!;
                                      },
                                    ),
                                  
                                ],
                              ))
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Handle OK button press
                                //  print('Option 1: ${textController1.text}, Checkbox 1: $checkbox1Value');
                                // print('Option 2: ${textController2.text}, Checkbox 2: $checkbox2Value');
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else if (searchType == "P") {
                      // Handle filter for Pages
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Filter for Pages'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Obx(
                        () =>  Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 30,
                                            ),
                                            label: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9),
                                              child: const Text(" Country"),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text(
                                            'Select Country',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: controller.countryList
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value:
                                              controller.country.value.isEmpty
                                                  ? null
                                                  : controller.country.value,
                                          onChanged: (value) {
                                            controller.country.value =
                                                value.toString();
                                            print(controller.country.value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select country';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                      value: controller
                                          .isSaveVisibleCountryPage.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleCountryPage
                                            .value = value!;
                                      },
                                    ),
                                 
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),
                          Obx(
                        () =>     Row(
                                children: [
                                  Text(
                                    "Highest Followers",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                   Checkbox(
                                      value: controller
                                          .isSaveVisibleFollowersPage.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleFollowersPage
                                            .value = value!;
                                      },
                                    ),
                                  
                                ],
                              )),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else if (searchType == "J") {
                      // Handle filter for Jobs
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Filter for Jobs'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           Obx(
                        () =>    Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 30,
                                            ),
                                            label: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9),
                                              child: const Text(" Country"),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text(
                                            'Select Country',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: controller.countryList
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value:
                                              controller.country.value.isEmpty
                                                  ? null
                                                  : controller.country.value,
                                          onChanged: (value) {
                                            controller.country.value =
                                                value.toString();
                                            print(controller.country.value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select country';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                    Checkbox(
                                    value: controller.isSaveVisibleCountryJob.value,
                                    onChanged: (value) {
                                  
                                        controller.isSaveVisibleCountryJob.value=value!;
                                     
                                    },
                                  ),
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),
                             Obx(
                        () =>  Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 350,
                                      child: MultiSelectDropDown(
                                        searchEnabled: true,
                                        onOptionSelected:
                                            (List<ValueItem> selectedOptions) {
                                          controller.selectedItems.assignAll(
                                              selectedOptions
                                                  .map((item) => item.value));
                                        },
                                        options: controller.items
                                            .map((item) => ValueItem(
                                                label: item, value: item))
                                            .toList(),
                                        selectionType: SelectionType.multi,
                                        chipConfig: const ChipConfig(
                                            wrapType: WrapType.scroll),
                                        dropdownHeight: 300,
                                        optionTextStyle:
                                            const TextStyle(fontSize: 16),
                                        selectedOptionIcon:
                                            const Icon(Icons.check_circle),
                                      ),
                                    ),
                                  ),
                                   Checkbox(
                                    value: controller.isSaveVisibleFieldsJob.value,
                                    onChanged: (value) {
                                  
                                        controller.isSaveVisibleFieldsJob.value=value!;
                                     
                                    },
                                  ),
                                ],
                              ))
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  })
            ],
                    ),
                  ),
                  body: Container(
                    color: Color(0xfffefbfe),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          Material(
                            child: Container(
                              height: 55,
                              child: TabBar(
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                unselectedLabelColor:
                                    const Color.fromARGB(255, 85, 191, 218),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      const Color.fromARGB(255, 85, 191, 218),
                                ),
                                onTap: (index) {
                                  // Handle tab click here
                                  if (index == 0) {
                                    searchType = "U";
                                    print('Users Tab clicked!');
                                  } else if (index == 1) {
                                    searchType = "P";
                                    print('Pages Tab clicked!');
                                  } else if (index == 2) {
                                    searchType = "J";
                                    print('Jobs Tab clicked!');
                                  }
                                },
                                tabs: [
                                  Tab(
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 85, 191, 218),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text("Users"),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 85, 191, 218),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text("Pages"),
                                      ),
                                    ),
                                  ),
                                  // for jobs

                                  Tab(
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 85, 191, 218),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text("Jobs"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification scrollInfo) {
                                    var currentPos = scrollInfo.metrics.pixels;
                                    var maxPos =
                                        scrollInfo.metrics.maxScrollExtent;
                                    //print(currentPos);
                                    //print(maxPos);
                                    if (!isLoading && currentPos == maxPos) {
                                      setState(() {
                                        isLoading =
                                            true; // Set loading to true to avoid multiple requests
                                        controller.Upage++;
                                      });

                                      controller
                                          .goTosearchPage(
                                              controller.searchValue,
                                              controller.Upage,
                                              "U")
                                          .then((result) async {
                                        if (result != null &&
                                            result.isNotEmpty) {
                                          await Future.delayed(const Duration(
                                              seconds:
                                                  1)); // to solve the problem when the user reach the bottom of the page1, it fetch page 3,4,5...etc.
                                          setState(() {
                                            isLoading =
                                                false; // Reset loading when the data is fetched
                                          });
                                          print(isLoading);
                                        }
                                      });
                                    }
                                    return false;
                                  },
                                  child: Obx(
                                    () => ListView.builder(
                                      // for user

                                      padding: const EdgeInsets.all(15),
                                      itemCount: controller.userList.length,
                                      itemBuilder: (context, index) {
                                        final firstname = controller
                                            .userList[index]['firstname'];
                                        final lastname = controller
                                            .userList[index]['lastname'];
                                        final username = controller
                                            .userList[index]['username'];
                                        final photo =
                                            controller.userList[index]['photo'];
                                        profileBackgroundImage =
                                            (photo != null &&
                                                    photo != "null" &&
                                                    photo != "")
                                                ? Image.network(
                                                        "$urlStarter/$photo")
                                                    .image
                                                : defultprofileImage;
                                        return ListTile(
                                          onTap: () {
                                            final userUsername = username;
                                            final userFirstname = firstname;
                                            final userLastname = lastname;
                                            final userPhoto = photo;

                                            Map<String, dynamic> userMap = {
                                              'name':
                                                  '$userFirstname $userLastname',
                                              'username': userUsername,
                                              'photo': userPhoto,
                                              'type': 'U'
                                            };

                                            _controller2.colleaguesmessages
                                                .assign(userMap);
                                            print(
                                                "lllllllllllllllllllllllllllllllllllllllll");
                                            print(_controller2
                                                .colleaguesmessages);
                                            print(
                                                "lllllllllllllllllllllllllllllllllllllllll");

                                            controller
                                                .goToUserPage(userUsername!);
                                            //  controller.goToprofile(email)
                                          },
                                          title: Text('$firstname $lastname'),
                                          subtitle: Text('$username'),
                                          trailing: CircleAvatar(
                                            backgroundImage:
                                                profileBackgroundImage,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification scrollInfo) {
                                    var currentPos = scrollInfo.metrics.pixels;
                                    var maxPos =
                                        scrollInfo.metrics.maxScrollExtent;
                                    //print(currentPos);
                                    //print(maxPos);
                                    if (!isLoading && currentPos == maxPos) {
                                      setState(() {
                                        isLoading =
                                            true; // Set loading to true to avoid multiple requests
                                        controller.Upage++;
                                      });

                                      controller
                                          .goTosearchPage(
                                              controller.searchValue,
                                              controller.Upage,
                                              "P")
                                          .then((result) async {
                                        if (result != null &&
                                            result.isNotEmpty) {
                                          await Future.delayed(const Duration(
                                              seconds:
                                                  1)); // to solve the problem when the user reach the bottom of the page1, it fetch page 3,4,5...etc.
                                          setState(() {
                                            isLoading =
                                                false; // Reset loading when the data is fetched
                                          });
                                          print(isLoading);
                                        }
                                      });
                                    }
                                    return false;
                                  },
                                  child: Obx(
                                    () => ListView.builder(
                                      // for user

                                      padding: const EdgeInsets.all(15),
                                      itemCount: controller.pageList.length,
                                      itemBuilder: (context, index) {
                                        final name =
                                            controller.pageList[index]['name'];
                                        final pageId =
                                            controller.pageList[index]['id'];
                                        final photo =
                                            controller.pageList[index]['photo'];
                                        profileBackgroundImage =
                                            (photo != null &&
                                                    photo != "null" &&
                                                    photo != "")
                                                ? Image.network(
                                                        "$urlStarter/$photo")
                                                    .image
                                                : defultprofileImage;
                                        return ListTile(
                                          onTap: () {
                                            controller.goToPage(pageId!);
                                          },
                                          title: Text('$name'),
                                          subtitle: Text('$pageId'),
                                          trailing: CircleAvatar(
                                            backgroundImage:
                                                profileBackgroundImage,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // jobbbbbsssssss
                                // for jobssssss
                                NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification scrollInfo) {
                                    var currentPos = scrollInfo.metrics.pixels;
                                    var maxPos =
                                        scrollInfo.metrics.maxScrollExtent;
                                    //print(currentPos);
                                    //print(maxPos);
                                    if (!isLoading && currentPos == maxPos) {
                                      setState(() {
                                        isLoading =
                                            true; // Set loading to true to avoid multiple requests
                                        controller.Upage++;
                                      });

                                      controller
                                          .goTosearchPage(
                                              controller.searchValue,
                                              controller.Upage,
                                              "J")
                                          .then((result) async {
                                        if (result != null &&
                                            result.isNotEmpty) {
                                          await Future.delayed(const Duration(
                                              seconds:
                                                  1)); // to solve the problem when the user reach the bottom of the page1, it fetch page 3,4,5...etc.
                                          setState(() {
                                            isLoading =
                                                false; // Reset loading when the data is fetched
                                          });
                                          print(isLoading);
                                        }
                                      });
                                    }
                                    return false;
                                  },
                                  child: Obx(
                                    () => ListView.builder(
                                      // for user

                                      padding: const EdgeInsets.all(15),
                                      itemCount: controller.jobeList.length,
                                      itemBuilder: (context, index) {
                                        final title =
                                            controller.jobeList[index]['title'];
                                        final Fields = controller
                                            .jobeList[index]['Fields'];
                                        final pageId = controller
                                            .jobeList[index]['pageId'];
                                        final jobId = controller.jobeList[index]
                                            ['pageJobId'];

                                        return ListTile(
                                          onTap: () {
                                            Get.to(ShowTheJob(
                                              jopId: jobId,
                                              title: title!,
                                              company: pageId!,
                                              Fields: Fields!,
                                              image: controller.jobeList[index]
                                                  ['photo'],
                                              deadline: controller
                                                  .jobeList[index]['endDate']!,
                                              content:
                                                  controller.jobeList[index]
                                                      ['description']!,
                                            ));
                                          },
                                          title: Text('$title'),
                                          subtitle: Text('$Fields'),
                                          trailing: Text('$pageId'),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: ChatWebMainPage(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back(); // Navigate back
              },
            ),
            title: Form(
              key: formstate,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        suffixIcon: InkWell(
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          onTap: () {
                            if (formstate.currentState!.validate()) {
                              setState(() {
                                isLoading = false;
                                controller.Upage = 1;
                                controller.userList.clear();
                                controller.pageList.clear();
                                controller.jobeList.clear();
                              });
                              print(searchType);
                              controller.goTosearchPage(controller.searchValue,
                                  controller.Upage, searchType);
                            } else {
                              print("Not Valid");
                            }
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        controller.searchValue = value;
                        if (value == null || value.isEmpty) {
                          return "";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                  icon: const Icon(
                    Icons.tune, // Replace with your filter icon
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (searchType == "U") {
                      // Handle filter for Users
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Filter for Users'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First TextField with Checkbox
                           Obx(
                        () =>    Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 30,
                                            ),
                                            label: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9),
                                              child: const Text(" Country"),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text(
                                            'Select Country',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: controller.countryList
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value:
                                              controller.country.value.isEmpty
                                                  ? null
                                                  : controller.country.value,
                                          onChanged: (value) {
                                            controller.country.value =
                                                value.toString();
                                            print(controller.country.value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select country';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                   Checkbox(
                                      value: controller
                                          .isSaveVisibleCountryUser.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleCountryUser
                                            .value = value!;
                                      },
                                    ),
                                  
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),
                           Obx(
                        () =>    Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 30,
                                            ),
                                            label: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9),
                                              child: const Text(" Gender"),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text(
                                            'Select Gender',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: controller.genderList
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value: controller.gender.value.isEmpty
                                              ? null
                                              : controller.gender.value,
                                          onChanged: (value) {
                                            controller.gender.value =
                                                value.toString();
                                            print(controller.gender.value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select gender';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                   Checkbox(
                                      value: controller
                                          .isSaveVisibleGenderUser.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleGenderUser
                                            .value = value!;
                                      },
                                    ),
                                 
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),
                             Obx(
                        () =>  Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 350,
                                      child: MultiSelectDropDown(
                                        searchEnabled: true,
                                        onOptionSelected:
                                            (List<ValueItem> selectedOptions) {
                                          controller.selectedItems.assignAll(
                                              selectedOptions
                                                  .map((item) => item.value));
                                        },
                                        options: controller.items
                                            .map((item) => ValueItem(
                                                label: item, value: item))
                                            .toList(),
                                        selectionType: SelectionType.multi,
                                        chipConfig: const ChipConfig(
                                            wrapType: WrapType.scroll),
                                        dropdownHeight: 300,
                                        optionTextStyle:
                                            const TextStyle(fontSize: 16),
                                        selectedOptionIcon:
                                            const Icon(Icons.check_circle),
                                      ),
                                    ),
                                  ),
                                   Checkbox(
                                      value: controller
                                          .isSaveVisibleFieldsUser.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleFieldsUser
                                            .value = value!;
                                      },
                                    ),
                                  
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),

                            Obx(
                        () =>   Row(
                                children: [
                                  Text(
                                    "Highest Connection",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                               Checkbox(
                                      value: controller
                                          .isSaveVisibleConnectionUser.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleConnectionUser
                                            .value = value!;
                                      },
                                    ),
                                  
                                ],
                              ))
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Handle OK button press
                                //  print('Option 1: ${textController1.text}, Checkbox 1: $checkbox1Value');
                                // print('Option 2: ${textController2.text}, Checkbox 2: $checkbox2Value');
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else if (searchType == "P") {
                      // Handle filter for Pages
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Filter for Pages'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Obx(
                        () =>  Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 30,
                                            ),
                                            label: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9),
                                              child: const Text(" Country"),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text(
                                            'Select Country',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: controller.countryList
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value:
                                              controller.country.value.isEmpty
                                                  ? null
                                                  : controller.country.value,
                                          onChanged: (value) {
                                            controller.country.value =
                                                value.toString();
                                            print(controller.country.value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select country';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                      value: controller
                                          .isSaveVisibleCountryPage.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleCountryPage
                                            .value = value!;
                                      },
                                    ),
                                 
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),
                          Obx(
                        () =>     Row(
                                children: [
                                  Text(
                                    "Highest Followers",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                   Checkbox(
                                      value: controller
                                          .isSaveVisibleFollowersPage.value,
                                      onChanged: (value) {
                                        controller.isSaveVisibleFollowersPage
                                            .value = value!;
                                      },
                                    ),
                                  
                                ],
                              )),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else if (searchType == "J") {
                      // Handle filter for Jobs
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Filter for Jobs'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           Obx(
                        () =>    Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 15,
                                              horizontal: 30,
                                            ),
                                            label: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9),
                                              child: const Text(" Country"),
                                            ),
                                          ),
                                          isExpanded: true,
                                          hint: const Text(
                                            'Select Country',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: controller.countryList
                                              .map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value:
                                              controller.country.value.isEmpty
                                                  ? null
                                                  : controller.country.value,
                                          onChanged: (value) {
                                            controller.country.value =
                                                value.toString();
                                            print(controller.country.value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select country';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                    Checkbox(
                                    value: controller.isSaveVisibleCountryJob.value,
                                    onChanged: (value) {
                                  
                                        controller.isSaveVisibleCountryJob.value=value!;
                                     
                                    },
                                  ),
                                ],
                              ),),
                              SizedBox(
                                height: 20,
                              ),
                             Obx(
                        () =>  Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 350,
                                      child: MultiSelectDropDown(
                                        searchEnabled: true,
                                        onOptionSelected:
                                            (List<ValueItem> selectedOptions) {
                                          controller.selectedItems.assignAll(
                                              selectedOptions
                                                  .map((item) => item.value));
                                        },
                                        options: controller.items
                                            .map((item) => ValueItem(
                                                label: item, value: item))
                                            .toList(),
                                        selectionType: SelectionType.multi,
                                        chipConfig: const ChipConfig(
                                            wrapType: WrapType.scroll),
                                        dropdownHeight: 300,
                                        optionTextStyle:
                                            const TextStyle(fontSize: 16),
                                        selectedOptionIcon:
                                            const Icon(Icons.check_circle),
                                      ),
                                    ),
                                  ),
                                   Checkbox(
                                    value: controller.isSaveVisibleFieldsJob.value,
                                    onChanged: (value) {
                                  
                                        controller.isSaveVisibleFieldsJob.value=value!;
                                     
                                    },
                                  ),
                                ],
                              ))
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Material(
                child: Container(
                  height: 55,
                  color: Colors.white,
                  child: TabBar(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    unselectedLabelColor:
                        const Color.fromARGB(255, 85, 191, 218),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 85, 191, 218),
                    ),
                    onTap: (index) {
                      // Handle tab click here
                      if (index == 0) {
                        searchType = "U";
                        print('Users Tab clicked!');
                      } else if (index == 1) {
                        searchType = "P";
                        print('Pages Tab clicked!');
                      } else if (index == 2) {
                        searchType = "J";
                        print('Jobs Tab clicked!');
                      }
                    },
                    tabs: [
                      Tab(
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color.fromARGB(255, 85, 191, 218),
                              width: 1,
                            ),
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text("Users"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color.fromARGB(255, 85, 191, 218),
                              width: 1,
                            ),
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text("Pages"),
                          ),
                        ),
                      ),
                      // for jobs

                      Tab(
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color.fromARGB(255, 85, 191, 218),
                              width: 1,
                            ),
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text("Jobs"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        var currentPos = scrollInfo.metrics.pixels;
                        var maxPos = scrollInfo.metrics.maxScrollExtent;
                        //print(currentPos);
                        //print(maxPos);
                        if (!isLoading && currentPos == maxPos) {
                          setState(() {
                            isLoading =
                                true; // Set loading to true to avoid multiple requests
                            controller.Upage++;
                          });

                          controller
                              .goTosearchPage(
                                  controller.searchValue, controller.Upage, "U")
                              .then((result) async {
                            if (result != null && result.isNotEmpty) {
                              await Future.delayed(const Duration(
                                  seconds:
                                      1)); // to solve the problem when the user reach the bottom of the page1, it fetch page 3,4,5...etc.
                              setState(() {
                                isLoading =
                                    false; // Reset loading when the data is fetched
                              });
                              print(isLoading);
                            }
                          });
                        }
                        return false;
                      },
                      child: Obx(
                        () => ListView.builder(
                          // for user

                          padding: const EdgeInsets.all(15),
                          itemCount: controller.userList.length,
                          itemBuilder: (context, index) {
                            final firstname =
                                controller.userList[index]['firstname'];
                            final lastname =
                                controller.userList[index]['lastname'];
                            final username =
                                controller.userList[index]['username'];
                            final photo = controller.userList[index]['photo'];
                            profileBackgroundImage = (photo != null &&
                                    photo != "null" &&
                                    photo != "")
                                ? Image.network("$urlStarter/$photo").image
                                : defultprofileImage;
                            return ListTile(
                              onTap: () {
                                final userUsername = username;
                                final userFirstname = firstname;
                                final userLastname = lastname;
                                final userPhoto = photo;

                                Map<String, dynamic> userMap = {
                                  'name': '$userFirstname $userLastname',
                                  'username': userUsername,
                                  'photo': userPhoto,
                                  'type': 'U'
                                };

                                _controller2.colleaguesmessages.assign(userMap);
                                print(
                                    "lllllllllllllllllllllllllllllllllllllllll");
                                print(_controller2.colleaguesmessages);
                                print(
                                    "lllllllllllllllllllllllllllllllllllllllll");

                                controller.goToUserPage(userUsername!);
                                //  controller.goToprofile(email)
                              },
                              title: Text('$firstname $lastname'),
                              subtitle: Text('$username'),
                              trailing: CircleAvatar(
                                backgroundImage: profileBackgroundImage,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        var currentPos = scrollInfo.metrics.pixels;
                        var maxPos = scrollInfo.metrics.maxScrollExtent;
                        //print(currentPos);
                        //print(maxPos);
                        if (!isLoading && currentPos == maxPos) {
                          setState(() {
                            isLoading =
                                true; // Set loading to true to avoid multiple requests
                            controller.Upage++;
                          });

                          controller
                              .goTosearchPage(
                                  controller.searchValue, controller.Upage, "P")
                              .then((result) async {
                            if (result != null && result.isNotEmpty) {
                              await Future.delayed(const Duration(
                                  seconds:
                                      1)); // to solve the problem when the user reach the bottom of the page1, it fetch page 3,4,5...etc.
                              setState(() {
                                isLoading =
                                    false; // Reset loading when the data is fetched
                              });
                              print(isLoading);
                            }
                          });
                        }
                        return false;
                      },
                      child: Obx(
                        () => ListView.builder(
                          // for user

                          padding: const EdgeInsets.all(15),
                          itemCount: controller.pageList.length,
                          itemBuilder: (context, index) {
                            final name = controller.pageList[index]['name'];
                            final pageId = controller.pageList[index]['id'];
                            final photo = controller.pageList[index]['photo'];
                            profileBackgroundImage = (photo != null &&
                                    photo != "null" &&
                                    photo != "")
                                ? Image.network("$urlStarter/$photo").image
                                : defultprofileImage;
                            return ListTile(
                              onTap: () {
                                controller.goToPage(pageId!);
                              },
                              title: Text('$name'),
                              subtitle: Text('$pageId'),
                              trailing: CircleAvatar(
                                backgroundImage: profileBackgroundImage,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // jobbbbbsssssss
                    // for jobssssss
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        var currentPos = scrollInfo.metrics.pixels;
                        var maxPos = scrollInfo.metrics.maxScrollExtent;
                        //print(currentPos);
                        //print(maxPos);
                        if (!isLoading && currentPos == maxPos) {
                          setState(() {
                            isLoading =
                                true; // Set loading to true to avoid multiple requests
                            controller.Upage++;
                          });

                          controller
                              .goTosearchPage(
                                  controller.searchValue, controller.Upage, "J")
                              .then((result) async {
                            if (result != null && result.isNotEmpty) {
                              await Future.delayed(const Duration(
                                  seconds:
                                      1)); // to solve the problem when the user reach the bottom of the page1, it fetch page 3,4,5...etc.
                              setState(() {
                                isLoading =
                                    false; // Reset loading when the data is fetched
                              });
                              print(isLoading);
                            }
                          });
                        }
                        return false;
                      },
                      child: Obx(
                        () => ListView.builder(
                          // for user

                          padding: const EdgeInsets.all(15),
                          itemCount: controller.jobeList.length,
                          itemBuilder: (context, index) {
                            final title = controller.jobeList[index]['title'];
                            final Fields = controller.jobeList[index]['Fields'];
                            final pageId = controller.jobeList[index]['pageId'];
                            final jobId =
                                controller.jobeList[index]['pageJobId'];

                            return ListTile(
                              onTap: () {
                                Get.to(ShowTheJob(
                                  jopId: jobId,
                                  title: title!,
                                  company: pageId!,
                                  Fields: Fields!,
                                  image: controller.jobeList[index]['photo'],
                                  deadline: controller.jobeList[index]
                                      ['endDate']!,
                                  content: controller.jobeList[index]
                                      ['description']!,
                                ));
                              },
                              title: Text('$title'),
                              subtitle: Text('$Fields'),
                              trailing: Text('$pageId'),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

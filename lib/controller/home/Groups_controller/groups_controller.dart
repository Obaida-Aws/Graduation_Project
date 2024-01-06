import 'package:get/get.dart';
import 'package:growify/view/screen/homescreen/Groups/chatGroupMessage.dart';

class Group {
  String id;
  String name;
  String? description;
  String? imagePath;
  Group? parentNode;
  bool isExpanded;

  Group({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
    this.parentNode,
    this.isExpanded = false,
  });
}

class GroupsController {
  late RxList<Map<String, dynamic>> Groupmessages = <Map<String, dynamic>>[].obs;

  getPageAllGroup(String pageId) {
    // Your implementation for fetching groups based on pageId
  }

  goToGroupChatMessage() async {
    print("Hamassssssssss");
    print(Groupmessages);
    print("Hamassssssssss");
    Get.to(GroupChatPageMessages(
      data: Groupmessages[0],
    ));
  }

  List<Group> groups = [];

  GroupsController() {
    Group mainGroup = Group(
      id: "1", 
      name: "Main Group",
      imagePath: null,
    );
    groups.add(mainGroup);

    Group parentGroup1 = Group(
      id: "2", 
      name: "Parent Group 1",
      imagePath: null,
      parentNode: mainGroup,
    );
    groups.add(parentGroup1);

    Group subgroup1_1 = Group(
      id: "3", 
      name: "Subgroup 1.1",
      imagePath: null,
      parentNode: parentGroup1,
    );
    groups.add(subgroup1_1);

    Group subgroup1_2 = Group(
      id: "4", 
      name: "Subgroup 1.2",
      imagePath: null,
      parentNode: parentGroup1,
    );
    groups.add(subgroup1_2);

    
  }

  List<String> get parentGroupNames {
    List<String> names = [];
    for (var group in groups) {
      if (group.parentNode == null) {
        names.add(group.name);
      }
    }
    return names;
  }

  Group? findGroupByName(String groupName) {
    for (var group in groups) {
      if (group.name == groupName) {
        return group;
      }
    }
    return null;
  }
}

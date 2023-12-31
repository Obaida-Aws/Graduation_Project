import 'package:flutter/material.dart';
import 'package:growify/controller/home/Groups_controller/createGroup_controller.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController _groupNameController = TextEditingController();
  String? _selectedParentNode;
  TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late CreateGroupsController groupsController;

  late List<String> defaultParentNodes;

  @override
  void initState() {
    super.initState();
    groupsController = CreateGroupsController();
    defaultParentNodes = groupsController.parentGroupNames;
  }

  void _createGroup() {
    if (formKey.currentState!.validate()) {
      String groupName = _groupNameController.text.trim();
      String description = _descriptionController.text.trim();

      Group newGroup = Group(
        name: groupName,
        imagePath: null,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: description,
      );

      if (_selectedParentNode != null) {
        Group? parentGroup = groupsController.findGroupByName(_selectedParentNode!);

        if (parentGroup != null) {
          groupsController.setParentNode(newGroup, parentGroup);
        } else {
          print("Parent node not found: $_selectedParentNode");
        }
      } else {
        groupsController.groups.add(newGroup);
      }

      _groupNameController.clear();
      _descriptionController.clear();
      _selectedParentNode = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Group',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: "Enter a unique group id",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      labelText: "Group id",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Group Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      hintText: "Enter Group Name",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      labelText: "Group Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Group Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Enter Your Group description",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Group Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedParentNode,
                    onChanged: (value) {
                      setState(() {
                        _selectedParentNode = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "All groups",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Parent Node",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    items: defaultParentNodes.map((String parentNode) {
                      return DropdownMenuItem<String>(
                        value: parentNode,
                        child: Text(parentNode),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 380,
                  child: MaterialButton(
                    color: const Color.fromARGB(255, 85, 191, 218),
                    onPressed: _createGroup,
                    child: Text('Create',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
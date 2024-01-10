import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/Members_controller/AddEmployeeMember_controller.dart';
import 'package:growify/controller/home/Groups_controller/Members_controller/AddOtherMembers_controller.dart';
import 'package:growify/controller/home/myPage_Controller/Employee_Controller/AddEmployee_controller.dart';
import 'package:growify/core/functions/alertbox.dart';

class AddEmployeeMember extends StatefulWidget {
  final pageId;
  final groupId;

  const AddEmployeeMember({Key? key, required this.pageId, this.groupId}) : super(key: key);

  @override
  _AddEmployeeMemberState createState() => _AddEmployeeMemberState();
}

class _AddEmployeeMemberState extends State<AddEmployeeMember> {
  late AddEmployeeMembersController _controller;

  TextEditingController _usernameController = TextEditingController();
 

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AddEmployeeMembersController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Add a member of the company\'s employees',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: "Enter Username",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      labelText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
               
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (_usernameController.text.trim().isNotEmpty ) {
                      var message = await _controller.addEmployeeMember(
                          widget.pageId,
                          _usernameController.text.trim(),
                          widget.groupId);
                      (message != null)
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertDialog(
                                  title: 'Error',
                                  icon: Icons.error,
                                  text: message,
                                  buttonText: 'OK',
                                  
                                );
                              },
                            )
                          : null;
                          _usernameController.clear();
                    }
                  }
                },
                color: const Color.fromARGB(255, 85, 191, 218),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                child: Text('Add Member',
                style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
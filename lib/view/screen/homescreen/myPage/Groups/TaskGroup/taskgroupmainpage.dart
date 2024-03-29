import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/Groups_controller/taskGroup_controller/taskGroup_Controller.dart';
import 'package:growify/view/screen/homescreen/myPage/Groups/TaskGroup/descriptiongroup.dart';
import 'package:intl/intl.dart';
import 'taskGroup.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/network_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_dropdown/widgets/hint_text.dart';
import 'package:multi_dropdown/widgets/selection_chip.dart';
import 'package:multi_dropdown/widgets/single_selected_item.dart';

class TasksGroupHomePage extends StatefulWidget {
  const TasksGroupHomePage(
      {super.key,
      this.isAdmin,
      this.members,
      this.isUserAdminInPage,
      this.groupData});
  final isAdmin;
  final members;
  final isUserAdminInPage;
  final groupData;
  @override
  _TasksGroupHomePageState createState() => _TasksGroupHomePageState();
}

TasksGroupController controller = Get.put(TasksGroupController());

class _TasksGroupHomePageState extends State<TasksGroupHomePage> {
  GlobalKey<FormState> formstate = GlobalKey();

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? startDate;
  DateTime? endDate;
  List<String> usernames = [];
  List<String> selectedUsernames = [];
  @override
  void initState() {
    super.initState();
    if (widget.members != null && widget.members is List) {
      usernames = widget.members
          .whereType<Map<String, dynamic>>()
          .where((member) => member['username'] is String)
          .map<String>((member) => member['username'] as String)
          .toList();
    }
    // to store in the database
  }

  void _addTask() async {
    var selectedStatus = 'ToDo';
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final result = await showDialog<Task>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController taskNameController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Task'),
          contentPadding: const EdgeInsets.all(15.0),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: taskNameController,
                              decoration: InputDecoration(
                                hintText: "Enter Your Task Name",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 30,
                                ),
                                labelText: "Task Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a task name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              maxLines: 6,
                              controller: descriptionController,
                              decoration: InputDecoration(
                                hintText: "Enter Your Description",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 30,
                                ),
                                labelText: "Description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text('Status:'),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: 60,
                                    child: DropdownButtonFormField<String>(
                                      value: selectedStatus,
                                      items: [
                                        'ToDo',
                                        'Doing',
                                        'Done',
                                        'Archived'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            selectedStatus = newValue;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text('Members:'),
                                const SizedBox(width: 10),
                                Container(
                                  width: 200,
                                  child: MultiSelectDropDown(
                                    searchEnabled: true,
                                    onOptionSelected:
                                        (List<ValueItem> selectedOptions) {
                                      print("p888888888888888888888");
                                      print(
                                          "Selected options: $selectedOptions");
                                      selectedUsernames = selectedOptions
                                          .map((option) =>
                                              option.value.toString())
                                          .toList();
                                    },
                                    options: usernames
                                        .map((username) => ValueItem(
                                            label: username, value: username))
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
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: const Text(
                                    'Start',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              startDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            startDate = pickedDate;
                                          });
                                        }
                                      },
                                      child: const Text('Select Date'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              startTime ?? TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            startTime = pickedTime;
                                          });
                                        }
                                      },
                                      child: const Text('Select Time'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            if (startDate != null && startTime != null)
                              Row(
                                children: [
                                  const Text('Selected Start: '),
                                  Text(
                                    '${_formatDate(startDate!)} , ${startTime!.format(context)}',
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: const Text(
                                    'End',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              endDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            endDate = pickedDate;
                                          });
                                        }
                                      },
                                      child: const Text('Select Date'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              endTime ?? TimeOfDay.now(),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            endTime = pickedTime;
                                          });
                                        }
                                      },
                                      child: const Text('Select Time'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (endDate != null && endTime != null)
                              Row(
                                children: [
                                  const Text('Selected End: '),
                                  Text(
                                    '${_formatDate(endDate!)} , ${endTime!.format(context)}',
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (endDate != null && startDate != null) {
                              if (endDate!.isBefore(startDate!)) {
                                // Show an error message
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'End date cannot be earlier than the start date'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }

                              if (endDate!.isAtSameMomentAs(startDate!) &&
                                  endTime != null &&
                                  startTime != null) {
                                if (endTime!.hour < startTime!.hour ||
                                    (endTime!.hour == startTime!.hour &&
                                        endTime!.minute < startTime!.minute)) {
                                  // Show an error message
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: const Text(
                                            'End time cannot be earlier than the start time'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                              }
                            }
                            if (taskNameController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty &&
                                startTime != null &&
                                endTime != null &&
                                startDate != null &&
                                endDate != null &&
                                selectedStatus != null) {
                              var task = Task(
                                taskNameController.text,
                                descriptionController.text,
                                startTime ??
                                    const TimeOfDay(hour: 0, minute: 0),
                                endTime ?? const TimeOfDay(hour: 0, minute: 0),
                                startDate ?? DateTime.now(),
                                endDate ?? DateTime.now(),
                                selectedStatus,
                              );
                              await controller.createUserTask(task,
                                  selectedUsernames, widget.groupData['id']);
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    // Update the buttons directly when TimePicker is confirmed
    setState(() {
      if (result != null) {
        tasks.add(result);
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  void _goToDescriptionPage(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescriptionGroupPage(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return Row(
       mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes the position of shadow
                      ),
                    ],
                  ),
            child: FutureBuilder(
                // Replace this with your actual future operation
                future: controller.initUserTasks(widget.groupData['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Return a loading indicator while waiting for the future to complete
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Handle any errors that occurred during the initialization
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return DefaultTabController(
                      length: 4,
                      child: Scaffold(
                        appBar: AppBar(
                          title: const Text('My Tasks'),
                          bottom: const TabBar(
                            tabs: [
                              Tab(text: 'ToDo'),
                              Tab(text: 'Doing'),
                              Tab(text: 'Done'),
                              Tab(text: 'Archived'),
                            ],
                          ),
                        ),
                        body: TabBarView(
                          children: [
                            buildTab('ToDo', widget.isAdmin),
                            buildTab('Doing', widget.isAdmin),
                            buildTab('Done', widget.isAdmin),
                            buildTab('Archived', widget.isAdmin),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
    }else{
      return FutureBuilder(
        // Replace this with your actual future operation
        future: controller.initUserTasks(widget.groupData['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading indicator while waiting for the future to complete
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle any errors that occurred during the initialization
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('My Tasks'),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'ToDo'),
                      Tab(text: 'Doing'),
                      Tab(text: 'Done'),
                      Tab(text: 'Archived'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    buildTab('ToDo', widget.isAdmin),
                    buildTab('Doing', widget.isAdmin),
                    buildTab('Done', widget.isAdmin),
                    buildTab('Archived', widget.isAdmin),
                  ],
                ),
              ),
            );
          }
        });
    }
  }

  bool isBefore(TimeOfDay a, TimeOfDay b) {
    return a.hour * 60 + a.minute < b.hour * 60 + b.minute;
  }

  Widget buildTab(String status, bool isAdmin) {
    List<Task> filteredTasks =
        tasks.where((task) => task.status == status).toList();

    List<String> dropdownItems = ['ToDo', 'Doing', 'Done'];

    if (isAdmin ||
        (widget.isUserAdminInPage != null &&
            widget.isUserAdminInPage == true)) {
      // Add 'Archived' and 'Delete' only if isAdmin is true
      dropdownItems.addAll(['Archived', 'Delete']);
    }

    return Scaffold(
      body: filteredTasks.isEmpty
          ? const Center(child: Text('No tasks yet.'))
          : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (BuildContext context, int index) {
                DateTime now = DateTime.now();
                DateTime endDate = DateTime(
                  filteredTasks[index].endDate.year,
                  filteredTasks[index].endDate.month,
                  filteredTasks[index].endDate.day,
                  filteredTasks[index].endTime.hour,
                  filteredTasks[index].endTime.minute,
                );

                bool isTaskCompleted = endDate.isBefore(now) ||
                    (endDate.isAtSameMomentAs(now) &&
                        isBefore(
                          TimeOfDay.fromDateTime(now),
                          filteredTasks[index].endTime,
                        ));
                return ListTile(
                  title: Text(filteredTasks[index].taskName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start: ${_formatDate(filteredTasks[index].startDate)}, ${filteredTasks[index].startTime.format(context)}',
                      ),
                      Text(
                        'End: ${_formatDate(filteredTasks[index].endDate)}, ${filteredTasks[index].endTime.format(context)}',
                        style: TextStyle(
                          color: !isTaskCompleted
                              ? Colors.green[800]
                              : Colors.red[800],
                        ),
                      ),
                    ],
                  ),
                  trailing: (status != 'Archived') ||
                          isAdmin ||
                          (isAdmin && status == 'Archived') ||
                          (widget.isUserAdminInPage != null &&
                              widget.isUserAdminInPage == true)
                      ? DropdownButton<String>(
                          value: filteredTasks[index].status,
                          items: dropdownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              var result =
                                  await controller.changeUserTaskStatus(
                                      filteredTasks[index],
                                      newValue,
                                      widget.groupData['id']);
                              if (result && newValue != 'Delete') {
                                filteredTasks[index].status = newValue;
                                setState(() {});
                              }
                              if (result && newValue == 'Delete') {
                                filteredTasks[index].status = newValue;
                                setState(() {
                                  // Remove the task from filteredTasks if the status is 'Delete'
                                  filteredTasks.removeWhere(
                                      (task) => task.status == 'Delete');
                                });
                              }
                            }
                          },
                        )
                      : null,
                  onTap: () {
                    _goToDescriptionPage(filteredTasks[index]);
                  },
                );
              },
            ),
      floatingActionButton: isAdmin ||
              (widget.isUserAdminInPage != null &&
                  widget.isUserAdminInPage == true)
          ? FloatingActionButton(
              onPressed: _addTask,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

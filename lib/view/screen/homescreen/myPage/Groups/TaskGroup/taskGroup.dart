import 'package:flutter/material.dart';

class Task {
  int? id;
  final String taskName;
  
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime startDate; // Added field for start date
  final DateTime endDate; // Added field for end date
  String status; 
  String? username;
  Task(
    this.taskName,
    
    this.description,
    this.startTime,
    this.endTime,
    this.startDate, // Updated constructor to include start date
    this.endDate, // Updated constructor to include end date
    this.status,
    [this.username, this.id]
  );
}

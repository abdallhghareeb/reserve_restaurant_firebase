import 'package:flutter/material.dart';
List pm =['12:00 PM','1:00 PM','2:00 PM','3:00 PM','4:00 PM','5:00 PM','6:00 PM','7:00 PM','8:00 PM','9:00 PM','10:00 PM','11:00 PM'];
List am =['12:00 AM','1:00 AM','2:00 AM','3:00 AM','4:00 AM','5:00 AM','6:00 AM','7:00 AM','8:00 AM','9:00 AM','10:00 AM','11:00 AM'];
List<String> months  =['Jan','Feb','Mar','Apr','May','Jun','July','Aug','Sept','Oct','Nov','Dec'];
List categories = ['food','drinks','sweets'];
var startDateController = TextEditingController();
var startTimeController = TextEditingController();
var endDateController = TextEditingController();
var endTimeController = TextEditingController();
var foodController = TextEditingController();
var tablesController = TextEditingController();
var chairsController = TextEditingController();
var idController = TextEditingController();
var imgController = TextEditingController();
var titleController = TextEditingController();
var catController = TextEditingController();
var priceController = TextEditingController();
var descriptionController = TextEditingController();
var rateController = TextEditingController();
var checkTime;
int? itemIndex;
var category;
double? rate;
int? num;
bool enable = true;
var foodBookingController = TextEditingController();
var drinkBookingController = TextEditingController();
var sweetsBookingController = TextEditingController();
var idBookingController = TextEditingController();
var dateBookingController = TextEditingController();
var timeBookingController = TextEditingController();
var durationBookingController = TextEditingController();
var tableBookingController = TextEditingController();
var chairsBookingController = TextEditingController();
int startTime = 12;
int endTime = 4;
var start ;
var end ;
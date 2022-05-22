import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multiselect/multiselect.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/components.dart';
import 'package:resturant/constant.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../bloc/cubit/states.dart';


class BookingScreen extends StatelessWidget {
  BookingScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    var firstDate = DateTime.now();
    var lastDate = DateTime(2023);
    var cubit = RestaurantCubit.get(context);
    List allTimes =[];
    var fullTimeSet ;
    var allTimesSet ;

    return BlocConsumer<RestaurantCubit, RestaurantStates>(
        listener: (BuildContext context, RestaurantStates state) {},
    builder: (BuildContext context, RestaurantStates state) {

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Reservation Time"),
              const SizedBox(height: 25.0),
              Row(
                children: [
                  Expanded(
                    child: defaultFormField(
                        onTap: () async {
                          await showDatePicker(
                            firstDate: firstDate,
                            lastDate: lastDate,
                            initialDate: DateTime.now(),
                            context: context,
                          ).then((value) {
                            startDateController.text = value.toString().split(" ")[0];





                          });
                        },
                        controller: startDateController,
                        type: TextInputType.datetime,
                        validate: (value) {},
                        name: "Date",
                        label: "Date"),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              Row(
                children: [
                  Expanded(
                    child: defaultFormField(
                        name: "Time",
                        onTap: () {
                          var myTime;
                          showCustomTimePicker(
                              context: context,
                              onFailValidation: (context) =>
                                  print('Unavailable selection'),
                              initialTime: const TimeOfDay(hour: 14, minute: 0),
                              selectableTimePredicate: (time) =>
                                  (time!.hour >= startTime ||
                                      time.hour <= endTime) &&
                                  time.minute == 00).then((time) => myTime = time).then((value) {
                            final localizations = MaterialLocalizations.of(context);
                            final formattedTimeOfDay = localizations.formatTimeOfDay(value!);
                            checkTime = value.hour;
                            start = value.hour;
                            // print(formattedTimeOfDay);
                            // print(checkTime);
                            // print(TimeOfDay.now().hour);
                            //   String realHour = "${myTime.hour - 12}:${myTime.minute}0 PM" ;
                            startTimeController.text = formattedTimeOfDay;
                          });
                        },
                        controller: startTimeController,
                        type: TextInputType.datetime,
                        validate: () {},
                        label: "from"),
                  ),
                  const SizedBox(width: 25.0),
                  Expanded(
                    child: defaultFormField(
                        name: "time",
                        onTap: () {
                          // var check = (startTimeController.text.split(" ").first).split(":").first;
                          var nTime;
                          // showTimePicker(initialTime: const TimeOfDay(hour: 14, minute: 0),context: context,);
                          showCustomTimePicker(
                              context: context,
                              onFailValidation: (context) =>
                                  print('Unavailable selection'),
                              initialTime: const TimeOfDay(hour: 14, minute: 0),
                              selectableTimePredicate: (time) =>
                                  (time!.hour >= startTime ||
                                      time.hour <= endTime) &&
                                  time.minute ==
                                      00).then((time) => nTime = time).then(
                              (value) {
                            final localizations =
                                MaterialLocalizations.of(context);
                            final formattedTimeOfDay = localizations.formatTimeOfDay(value!);
                            print(formattedTimeOfDay);
                            endTimeController.text = formattedTimeOfDay;
                            end = value.hour;

                            if (startTimeController.text.contains("AM") && endTimeController.text.contains("AM") ||
                                startTimeController.text.contains("PM") && endTimeController.text.contains("PM")
                            ) {
                              endDateController.text = startDateController.text;

                              print("hhhhhhhh${endDateController.text}");
                            } else{

                              String last= '';
                              final DateFormat formatter = DateFormat('yyyy-MM-dd');
                              var y = startDateController.text.split("-").first;
                              var m = startDateController.text.split("-").skip(1).first;
                              var d = startDateController.text.split("-").last;
                              var date =  DateTime(int.parse(y),int.parse(m)+1,0);
                              if(int.parse(m)<12){

                                if(int.parse(d) == date.day){
                                  if(int.parse(m) < 10 ){
                                    last = "$y-0${int.parse(m)+1}-01";
                                    print("$y-0${int.parse(m)+1}-01");
                                  }else{
                                    last ="$y-${int.parse(m)+1}-01";
                                    print("$y-${int.parse(m)+1}-01");
                                  }
                                }else{
                                  if(int.parse(d) < 10 ){
                                    last = "$y-$m-0${int.parse(d) + 1}";
                                    print("$y-$m-0${int.parse(d) + 1}");
                                  }else{
                                    last ="$y-$m-${int.parse(d) + 1}";
                                    print("$y-$m-${int.parse(d) + 1}");
                                  }
                                }

                              }else{
                                last ="${int.parse(y)+1}-01-01" ;
                              }
                                endDateController.text = last;
                                print("nnnnnnnnnnnn${endDateController.text}");
                                }
                          });
                        },
                        controller: endTimeController,
                        type: TextInputType.datetime,
                        validate: () {},
                        label: "to"),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              defaultButton(
                  function: () {
                    allTimes = [];
                    if (formKey.currentState!.validate()) {
                      String t = startTimeController.text.toString().split(":").first;
                      String m = endTimeController.text.toString().split(":").first;

                      if (startTimeController.toString().contains("AM")) {

                        if(int.parse(t) == 12){
                          t="0";
                          for (int i = 0; i < end - start; i++) {
                            allTimes.add("${am[int.parse(t)+i]} " + startDateController.text);
                          }
                        }else{
                          for (int i = 0; i < end-start; i++) {
                            allTimes.add("${am[int.parse(t)+i]} " + startDateController.text);
                          }
                        }
                      }
                      else if (startTimeController.toString().contains("PM") && endTimeController.toString().contains("PM")) {
                        if(int.parse(t) == 12){
                          t="0";
                          for (int i = 0; i < end - start; i++) {
                            allTimes.add("${pm[int.parse(t)+i]} " + startDateController.text);
                          }
                        }else{
                          for (int i = 0; i < end-start; i++) {
                            allTimes.add("${pm[int.parse(t)+i]} " + startDateController.text);
                          }
                        }
                      }
                      else if(startTimeController.toString().contains("PM") && endTimeController.toString().contains("AM")) {
                        if(int.parse(t) == 12){

                        t = "0";
                        int b = 0;
                        for (int r = 0; r < 12 - int.parse(t); r++) {
                          // print("aaaaaaaaaaaaaaaaaaa ,gg${(24 + (end - start)) - b}");
                          allTimes.add("${pm[int.parse(t) + r]} " + startDateController.text);
                          b++;
                        }
                        for (int x = 0; x < (24 + (end - start)) - b; x++) {
                          allTimes.add("${am[x]} " + endDateController.text);
                        }
                      }else{
                          int b = 0;
                          for (int r = 0; r < 12 - int.parse(t); r++) {
                            // print("aaaaaaaaaaaaaaaaaaa ,gg${(24 + (end - start)) - b}");
                            allTimes.add("${pm[int.parse(t) + r]} " + startDateController.text);
                            b++;
                          }
                          for (int x = 0; x < (24 + (end - start)) - b; x++) {
                            allTimes.add("${am[x]} " + endDateController.text);
                          }
                      }

                      }
                      if (  startDateController.text.length != 10 ||
                              startTimeController.text.length < 7 ||
                              startTimeController.text.length > 8 ||
                              endTimeController.text.length < 7 ||
                              endTimeController.text.length > 8 ||
                              startTimeController.text.split(" ").last != "PM" &&startTimeController.text.split(" ").last != "AM"||
                              endTimeController.text.split(" ").last != "PM" && endTimeController.text.split(" ").last != "AM"||
                              end == start || end <= start && startDateController.text == endDateController.text ||
                              checkTime <= TimeOfDay.now().hour && DateTime.now().toString().split(" ")[0] == startDateController.text ||
                              startTimeController.text.contains("AM") && endTimeController.text.contains("PM") ||
                              startTimeController.text.contains("AM") && end <= start) {



                          startTimeController.text='';
                          startDateController.text='';
                          endTimeController.text='';
                        showDialog(context: context, builder: (context) {
                          return const AlertDialog(title: Text("Data isn't correct"),);});
                      }else{
                        var y = startDateController.text.split("-").first;
                        var m = startDateController.text.split("-").skip(1).first;
                        var d = startDateController.text.split("-").last;
                        cubit.getReserve(year: y,month: m,day:d).then((value) {
                          print("aaaaaaaaaaaaavvvvvvvvvvv$allTimes");
                          print("aaaaaaaaaaaavv${cubit.fullTime}");
                          fullTimeSet = cubit.fullTime.toSet();
                          allTimesSet = allTimes.toSet();
                          y = endDateController.text.split("-").first;
                          m = endDateController.text.split("-").skip(1).first;
                          d = endDateController.text.split("-").last;
                          cubit.getReserve(year: y, month: m, day: d).then((value) {
                            fullTimeSet = cubit.fullTime.toSet();
                            allTimesSet = allTimes.toSet();
                            print("aaaaaaaaaaaaavvvvvvvvvvv$allTimes");
                            print("aaaaaaaaaaaavv${cubit.fullTime}");
                            print('mmmmmmmmm ${fullTimeSet.intersection(allTimesSet)}');
                            cubit.fullTime=[];
                            if (fullTimeSet.intersection(allTimesSet).isEmpty) {
                              makeReservation(context, cubit);
                            } else {
                              showDialog(context: context, builder: (context) {
                                    return const AlertDialog(
                                  title: Text(
                                    "Reservation Time not available ....  Please choose another time",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold
                                    ),),
                                );
                              });
                            }
                          });
                        });
                      }

                    }
                    },
                  text: 'Continue')
            ],
          ),
        ),
      ),
    );
});
  }
}

void makeReservation(context, cubit) {
  var anotherFormKey = GlobalKey<FormState>();
  var food;
  var drinks;
  var sweets;
  showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text('select Item and tables'),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 400,
              width: 400,
              child: Form(
                key: anotherFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 360,
                        height: 70,
                        child: DropDownMultiSelect(
                          decoration: const InputDecoration(
                              label: Text('Food'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
                          onChanged: (List<String> x) {
                            food = x;
                          },
                          selectedValues: [],
                          options: cubit.foodTitles,
                          whenEmpty: '',
                        ),
                      ),
                      SizedBox(
                        width: 360,
                        height: 70,
                        child: DropDownMultiSelect(
                          decoration: const InputDecoration(
                              label: Text("Drinks"),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
                          onChanged: (List<String> dr) {
                            drinks = dr;
                          },
                          selectedValues: [],
                          options: cubit.drinksTitles,
                          whenEmpty: '',
                        ),
                      ),
                      SizedBox(
                        width: 360,
                        height: 70,
                        child: DropDownMultiSelect(
                          decoration: const InputDecoration(
                              label: Text("Sweets"),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
                          onChanged: (List<String> sw) {
                            sweets = sw;
                          },
                          selectedValues: [],
                          options: cubit.sweetsTitles,
                          whenEmpty: '',
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                          onTap: () {},
                          controller: tablesController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'number of tables is required';
                            } else if (int.parse(value) < 1) {
                              return "that is impossible";
                            }
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "number of tables")),
                      const SizedBox(height: 25.0),
                      TextFormField(
                          onTap: () {},
                          controller: chairsController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'number of chairs is required';
                            } else if (int.parse(value) < 1) {
                              return "that is impossible";
                            }
                          },
                          decoration: const InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "number of chairs")),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel')),
            TextButton(
              onPressed: () {
                if (anotherFormKey.currentState!.validate()) {
                  var d = int.parse(chairsController.text) /
                      int.parse(tablesController.text);
                  if (d != 4.0) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                              title: Text(
                            'for each table there are 4 chairs',
                            style: TextStyle(fontSize: 12.0),
                          ));
                        });
                  } else {
                    if (startDateController.text == endDateController.text ||
                        startDateController.text != endDateController.text &&
                            startTimeController.text.contains("AM")) {
                      print(end - start);
                      cubit.uploadReserve(
                          startDate: startDateController.text,
                          endDate: endDateController.text,
                          startTime: startTimeController.text,
                          reserveDate:DateTime.now().toString().split(" ")[0],
                          endTime: endTimeController.text,
                          duration: "${end - start}",
                          food: food.toString() == "[]" ||
                                  food.toString() == "null"
                              ? "No Food Selected"
                              : food.toString(),
                          drinks: drinks.toString() == "[]" ||
                                  drinks.toString() == "null"
                              ? "No Drinks Selected"
                              : drinks.toString(),
                          sweets: sweets.toString() == "[]" ||
                                  sweets.toString() == "null"
                              ? "No Sweets Selected"
                              : sweets.toString(),
                          tables: tablesController.text,
                          chairs: chairsController.text);
                      print('done');
                    } else {
                      cubit.uploadReserve(
                          startDate: startDateController.text,
                          endDate: endDateController.text,
                          startTime: startTimeController.text,
                          endTime: endTimeController.text,
                          duration: "${(end - start) + 24}",
                          reserveDate:DateTime.now().toString().split(" ")[0],
                          food: food.toString() == "[]" ||
                                  food.toString() == "null"
                              ? "No Food Selected"
                              : food.toString(),
                          drinks: drinks.toString() == "[]" ||
                                  drinks.toString() == "null"
                              ? "No Drinks Selected"
                              : drinks.toString(),
                          sweets: sweets.toString() == "[]" ||
                                  sweets.toString() == "null"
                              ? "No Sweets Selected"
                              : sweets.toString(),
                          tables: tablesController.text,
                          chairs: chairsController.text);
                    }

                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("Thank You For Reservation , you can cancel reservation during the day only",style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                            ),),
                          );
                        });
                    food = [];
                    sweets = [];
                    drinks = [];
                    startDateController.clear();
                    startTimeController.clear();
                    endDateController.clear();
                    endTimeController.clear();
                    tablesController.clear();
                    chairsController.clear();
                  }
                }
              },
              child: const Text('confirm'),
            ),
          ],
        );
      });
}

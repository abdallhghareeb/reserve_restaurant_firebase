import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultFormField({
  String? name,
  required TextEditingController? controller,
  required TextInputType? type,
  Function(String)? onSubmit,
  Function? onChange,
  required Function? validate,
  required String label,
  IconData? prefix,
  VoidCallback? onTap,
  IconData? suffix,
  bool isPassword = false,
  bool isClickable = true,
  Function? suffixPressed,
  int maxLine = 1,
  bool readOnly = false,
}) =>
    TextFormField(
      readOnly: readOnly,
      maxLines: maxLine,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (value) {
        if (onSubmit != null) {
          onSubmit(value);
        }
      },
      onTap:onTap,
      // onChanged:(String value) {
      //     if (value != null) {
      //     print(NewsCubit.get(context));
      //     return NewsCubit.get(context).getSearch(value) ;
      //     }else if(value ==null){
      //       return null;
      // };
      // },
      validator: (value) {
        if (value!.isEmpty) {
          return '$name is required';
        }
        if(name=='Password'&&value.length<6){
          return "Password must be more than 6 chars";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: () {
                  suffixPressed!();
                },
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.teal,
  required Function function,
  // required VoidCallback function,
  required String text,
  bool isUpperCase = true,
}) =>
    Container(
      color: background,
      width: width,
      height: 60.0,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );



/// A Custom Dialog that displays a single question & list of answers.
class MultiSelectDialog extends StatelessWidget {
  /// List to display the answer.
  final List<String> ? answers;

  /// Widget to display the question.
  final Widget ?question;

  /// List to hold the selected answer
  /// i.e. ['a'] or ['a','b'] or ['a','b','c'] etc.
  final List<String> selectedItems = [];

  /// Map that holds selected option with a boolean value
  /// i.e. { 'a' : false}.
  static Map<String, bool> ?mappedItem;

  MultiSelectDialog({this.answers, this.question});

  /// Function that converts the list answer to a map.
  Map<String, bool> initMap() {
    return mappedItem = Map.fromIterable(answers!,
        key: (k) => k.toString(),
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (mappedItem == null) {
      initMap();
    }
    return SimpleDialog(
      title: question,
      children: [
        ...mappedItem!.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(key), // Displays the option
                value: mappedItem![key], // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) => setState(() => mappedItem![key] = value!)),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                style: ButtonStyle(visualDensity: VisualDensity.comfortable),
                child: Text('Submit'),
                onPressed: () {
                  // Clear the list
                  selectedItems.clear();

                  // Traverse each map entry
                  mappedItem!.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                }))
      ],
    );
  }
}


Widget different({
  String? name,
  required TextEditingController? controller,
  required TextInputType? type,
  Function(String)? onSubmit,
  Function? onChange,
  required Function? validate,
  required String label,
  IconData? prefix,
  VoidCallback? onTap,
  IconData? suffix,
  bool isPassword = false,
  bool isClickable = true,
  Function? suffixPressed,
  required int min ,
  required int max,
  required BuildContext context,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (value) {
        if (onSubmit != null) {
          onSubmit(value);
        }
      },
      onTap:onTap,
      // onChanged:(String value) {
      //     if (value != null) {
      //     print(NewsCubit.get(context));
      //     return NewsCubit.get(context).getSearch(value) ;
      //     }else if(value ==null){
      //       return null;
      // };
      // },
      validator: (value) {
        if (value!.isEmpty) {
          return '$name is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          icon: Icon(suffix),
          onPressed: () {
            suffixPressed!();
          },
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );



void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.black45,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color? color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.greenAccent;
      break;
    case ToastStates.ERROR:
      color = Colors.redAccent;
      break;
    case ToastStates.WARNING:
      color = Colors.amberAccent;
      break;
  }
  return color;
}

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (Route<dynamic> route) => false,
);

Widget defaultTextButton({
  required Function function,
  required String text,
}) =>
    TextButton(
        onPressed: () {
          function();
        },
        child: Text(text.toUpperCase()));
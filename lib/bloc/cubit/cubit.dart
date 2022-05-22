import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resturant/admin/admin.dart';
import 'package:resturant/admin/adminhomescreen.dart';
import 'package:resturant/bloc/cubit/states.dart';
import 'package:resturant/constant.dart';
import 'package:resturant/user/bookingscreen.dart';
import 'package:resturant/user/user_home_screen.dart';
import 'package:resturant/admin/reservation.dart';
import 'package:resturant/model/itemmodel.dart';
import 'package:resturant/model/reservationmodel.dart';
import 'package:resturant/model/user_model.dart';
import 'package:resturant/user/userscreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RestaurantCubit extends Cubit<RestaurantStates> {
  RestaurantCubit() : super(InitialState());
  static RestaurantCubit get(context) => BlocProvider.of(context);

  String? userId;
  int currentIndex = 0;
  int listIndex = 0;
  Color buttonColors = Colors.deepPurple;
  ItemModel? itemModel;
  UserModel? userModel;
  List<BottomNavigationBarItem> adminBottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.book,
        ),
        label: "Reservation"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.account_circle_outlined,
        ),
        label: "Account"),
  ];

  List<BottomNavigationBarItem> userBottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.book,
        ),
        label: "Booking"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.account_circle_outlined,
        ),
        label: "Account"),
  ];

  List<Widget> adminScreens = [
    const AdminHomeScreen(),
    Reservation(),
    adminScreen(),
  ];
  List<Widget> userScreens = [
    UserHomeScreen(),
    BookingScreen(),
    UserScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) {
      BookingScreen();
    }
    if (index == 2) {
      UserScreen();
    }
    emit(BottomNavBar());
  }

  void changListSuccess() {
    emit(GetItemsSuccessState());
  }

  List<ItemModel> items = [];
  List<ItemModel> food = [];
  List<ItemModel> drinks = [];
  List<ItemModel> sweets = [];
  List<String> titles = [];
  List<String> foodTitles = [];
  List<String> drinksTitles = [];
  List<String> sweetsTitles = [];

  Future<void> getItems() {
    items = [];
    titles = [];
    food = [];
    sweets = [];
    drinks = [];
    foodTitles = [];
    drinksTitles = [];
    sweetsTitles = [];
    return FirebaseFirestore.instance.collection('items').get().then((value) {
      value.docs.forEach((element) {
        items.add(ItemModel.fromJson(element.data()));
        if (element.data()['category'] == "food") {
          food.add(ItemModel.fromJson(element.data()));
          foodTitles.add(element['title']);
        }
        if (element.data()['category'] == "drink") {
          drinks.add(ItemModel.fromJson(element.data()));
          drinksTitles.add(element['title']);
        }
        if (element.data()['category'] == "sweets") {
          sweets.add(ItemModel.fromJson(element.data()));
          sweetsTitles.add(element['title']);
        }
        titles.add(element['title'] + "    " + element['price'] + " EGP");
        print(element.data());
        emit(GetItemsSuccessState());
      });
    });
  }

  String? reserveIdd;
  void uploadReserve({
    required String startDate,
    required String endDate,
    required String startTime,
    required String reserveDate,
    required String endTime,
    required String duration,
    required String food,
    required String drinks,
    required String sweets,
    required String tables,
    required String chairs,
    String? reserveID,
    int? price,
  }) {
    reserveIdd ??= "${UniqueKey()}";
    emit(PostReserveLoadingState());
    ReserveModel model = ReserveModel(
      price: 2450,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      food: food,
      drinks: drinks,
      sweets: sweets,
      tables: tables,
      chairs: chairs,
      reserveDate: reserveDate,
      reserveID: reserveIdd,
      userId: userId,
    );

    var y = startDate.split("-").first;
    var m = startDate.split("-").skip(1).first;
    var d = startDate.split("-").last;
    FirebaseFirestore.instance
        .collection('reserves')
        .doc("$y ${months[int.parse(m)-1]}")
        .set({"year":y})
        .then((value) {
    });
    FirebaseFirestore.instance
        .collection("reserves")
        .doc("$y ${months[int.parse(m)-1]}")
        .collection(d)
        .doc(reserveIdd)
        .set(model.toMap())
        .then((value) {


      var y = endDate.split("-").first;
      var m = endDate.split("-").skip(1).first;
      var d = endDate.split("-").last;
      FirebaseFirestore.instance
          .collection("reserves")
          .doc("$y ${months[int.parse(m)-1]}")
          .collection(d)
          .doc(reserveIdd)
          .set(model.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('reserves')
            .doc("$y ${months[int.parse(m)-1]}")
            .set({"year":y})
            .then((value) {
        });
        reserveIdd = null;
        emit(PostReserveSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(PostReserveErrorState());
      });
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("myReserves")
        .doc(reserveIdd)
        .set(model.toMap())
        .then((value) {
      getUserData(userId);

      emit(PostReserveSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(PostReserveErrorState());
    });
  }

  List<ReserveModel> reserves = [];
  List<Map> allReserves = [];
  List fullTime = [];
  Future getReserve({required String year,required String month, required String day}) {
    reserves = [];
    print("aaaaaaaaaaaavvvvvvvvvvvvvvvvvvvvvvvvvvvv${int.parse(month)-1}");
    return FirebaseFirestore.instance.collection('reserves')
        .doc("$year ${months[(int.parse(month)-1)]}")
        .collection(day).get().then((value) {
      value.docs.forEach((element) {
        allReserves.add(element.data());
        reserves.add(ReserveModel.fromJson(element.data()));
        String t = element['startTime'].toString().split(":").first;
        if (element['startTime'].toString().contains("AM")) {
          if(int.parse(t) == 12){
            t="0";
            for (int i = 0; i < int.parse(element['duration']); i++) {
              fullTime.add("${am[int.parse(t) + i]} " + element['startDate']);
            }
          }else{
            for (int i = 0; i < int.parse(element['duration']); i++) {
              fullTime.add("${am[int.parse(t) + i]} " + element['startDate']);
            }
          }

        }
        else if (element['startTime'].toString().contains("PM") && element['endTime'].toString().contains("PM")) {
          if(int.parse(t) == 12){
            t="0";
            for (int i = 0; i < int.parse(element['duration']); i++) {
              fullTime.add("${pm[int.parse(t) + i]} " + element['startDate']);
            }
          }else{
            for (int i = 0; i < int.parse(element['duration']); i++) {
              fullTime.add("${pm[int.parse(t) + i]} " + element['startDate']);
            }
          }
        }
        else {
          if(int.parse(t) == 12){
            t='0';
            String m = element['endTime'].toString().split(":").first;
            int b = 0;
            for (int r = 0; r < int.parse(m); r++) {
              fullTime.add("${am[r]} " + element['endDate']);
              b++;
            }
            for (int x = 0; x < (int.parse(element['duration']) - b); x++) {
              fullTime.add("${pm[int.parse(t) + x]} " + element['startDate']);
            }
          }else{
            String m = element['endTime'].toString().split(":").first;
            int b = 0;
            for (int r = 0; r < int.parse(m); r++) {
              fullTime.add("${am[r]} " + element['endDate']);
              b++;
            }
            for (int x = 0; x < (int.parse(element['duration']) - b); x++) {
              fullTime.add("${pm[int.parse(t) + x]} " + element['startDate']);
            }
          }

          }

        print(element.data());
        print("ششششششششششششششششششششششششششششششششششششششششششششششششششششششش$fullTime");
        print("sssssssssssssssssssssssssssssssssssssssssss$allReserves");
      });

      emit(GetReserveSuccessState());
    });
  }

  List<Map> reservesByMonth = [];
  Future getReservesByMonth({required int dayIndex,required int monthIndex}) async {
    reservesByMonth = [];
    if((dayIndex)<10){
      print("a,sbmkbk k$dayIndex");
      await FirebaseFirestore.instance.collection('reserves').doc("2022 ${months[monthIndex]}")
          .collection("0$dayIndex")
          .get().then((value) {
        value.docs.forEach((element) {
            reservesByMonth.add(element.data());
        });
      });
    }else{
      await FirebaseFirestore.instance.collection('reserves').doc("2022 ${months[monthIndex]}")
          .collection("$dayIndex")
          .get().then((value) {
        value.docs.forEach((element) {
            reservesByMonth.add(element.data());
        });
      });
    }

    print("nbbbbbbbbbbbbbb$reservesByMonth");
  }

  List<String> available = [];
  Future checkMonth() async {
    available=[];
    print("aaaaaghwh$available");
    await FirebaseFirestore.instance.collection("reserves").get().then((value) {
      print("aaaaaghwh${value.docs.length}");
      value.docs.forEach((element) {
        available.add(element.id);
        print("aaaaaghwh$available");
      });
    });
  }
  Map myData = {};
  List<Map> myReserves = [];
  Future getUserData(userId) async {
    myReserves = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myReserves')
        .orderBy("startDate")
        .get()
        .then((value) {
      print(value);
      value.docs.forEach((element) {
        myReserves.add(element.data());
      });
    });
    print("my reserves$myReserves");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      print("qqqqqqqqqqqqqqqqqqq ${value.data()}");
      myData.addAll(value.data()!);
      emit(GetUserReserveSuccessState());
    }).catchError((error) {
      print(error.toString());
    });
  }

  void deleteReserve(
      {required String id, required String userIdDelete, required int index}) {
    print("aaaaaaaaaaaaa$userId");
    FirebaseFirestore.instance
        .collection('reserves')
        .doc(id)
        .delete()
        .then((value) {});
    FirebaseFirestore.instance
        .collection('users')
        .doc(userIdDelete)
        .collection("myReserves")
        .doc(id)
        .delete()
        .then((value) {});
  }

  File? itemImage;
  var picker = ImagePicker();

  Future getItemImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      itemImage = File(pickedFile.path);
    } else {
      print("No image selected");
    }
  }

  String? itemImageUrl;
  void uploadItemImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(itemImage!.path).pathSegments.last}")
        .putFile(itemImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        itemImageUrl = value;
        print(itemImageUrl);
        emit(SelectImageSuccess());
      }).catchError((error) {});
    }).catchError((error) {});
  }

  String? itemID;
  void uploadItem({
    required String title,
    required String price,
    required String description,
    required String img,
    required String category,
    String? itemId,
    String? rate,
    String? numUserRate,
  }) {
    if (itemID == null) {
      itemID = "${UniqueKey()}";
    }
    items = [];
    emit(PostItemsLoadingState());
    ItemModel model = ItemModel(
      title: title,
      img: img,
      description: description,
      price: price,
      itemID: itemID,
      category: category,
      rate: rate,
      numUserRate: numUserRate,
    );

    FirebaseFirestore.instance
        .collection("items")
        .doc(itemID)
        .set(model.toMap())
        .then((value) {
      getItems();
      itemId = null;
      emit(PostItemsSuccessState());
    }).catchError((error) {
      emit(PostItemsErrorState());
    });
  }

  double? rating;
  void submitUserRates(
      {required String user,
      required String id,
      required double rate,
      int? num}) {
    FirebaseFirestore.instance
        .collection('items')
        .doc(id)
        .collection("rate")
        .get()
        .then((value) {
      num = value.docs.length;
      rating = 0;
      value.docs.forEach((element) {
        rating = rating! + double.parse(element['rate']);
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection('items')
          .doc(id)
          .update({'rate': '${rating! / num!}'});
      FirebaseFirestore.instance
          .collection('items')
          .doc(id)
          .update({'numUserRate': '${num!}'});
      updateRate(id: id);

    });
    FirebaseFirestore.instance
        .collection('items')
        .doc(id)
        .collection("rate")
        .doc(userId)
        .set({"userId": user, "rate": "$rate"});
  }

  void updateRate({
    required String id,
  }) {
    FirebaseFirestore.instance.collection('items').doc(id).get().then((value) {
      print(value['rate']);
      print(value['numUserRate']);
      num = int.parse(value['numUserRate']);
      rate = double.parse(value['rate']);
      emit(UpdateItemsRateSuccessState(num!, rate!));
    });
  }

  Future <void> getUpdate({required String id,}){
    return FirebaseFirestore.instance.collection('items').doc(id).get().then((value) {
      num = int.parse(value['numUserRate']);
      rate = double.parse(value['rate']);
      getItems();
    });
  }
  void deleteItem({required String itemId}) {
    FirebaseFirestore.instance
        .collection('items')
        .doc(itemId)
        .delete()
        .then((value) {
      getItems();
      emit(DeletedItemSuccess());
    });
  }
}

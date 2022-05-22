import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/bloc/cubit/states.dart';
import '../cache_helper.dart';

class LayoutPage extends StatelessWidget {
  bool isUser = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LayoutPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantCubit, RestaurantStates>(
        listener: (BuildContext context, RestaurantStates state) {
          RestaurantCubit.get(context).userId = CacheHelper.getData(key: "uId");
            if(RestaurantCubit.get(context).myData['email'] == 'a@rest.com' )  {
              isUser = false;
            }else{
              isUser = true;
            }
        },
        builder: (BuildContext context, RestaurantStates state) {


          var cubit =RestaurantCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.grey[300],
            key: scaffoldKey,
            appBar: AppBar(title: const Text("Restaurant"),elevation: 0.0,),
            body: isUser ? cubit.userScreens[cubit.currentIndex] : cubit.adminScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.white,
              onTap: (index){
                cubit.changeBottomNavBar(index);
                print(cubit.currentIndex);
              },
              items: isUser ? cubit.userBottomItems : cubit.adminBottomItems,
              currentIndex: cubit.currentIndex,
            ),
          );
        });
  }

}

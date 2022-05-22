import 'package:flutter/material.dart';
import 'package:resturant/admin/uploaditemscreen.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/components.dart';
import 'package:resturant/constant.dart';
import 'package:resturant/user/restaurant_login/restaurant_login_screen.dart';

import '../cache_helper.dart';


class adminScreen extends StatelessWidget {
   adminScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    // var cubit = RestaurantCubit.get(context);
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25.0,),
              defaultButton(function: (){
                catController.text = '';
                rateController.text = '';
                imgController.text = '';
                titleController.text = '';
                priceController.text = '';
                descriptionController.text = '';
                RestaurantCubit.get(context).itemID = null;
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadItemScreen()));
              }, text: 'Upload Items '),
              const SizedBox(
                height: 25.0,
              ),

              defaultButton(function: (){
                CacheHelper.removeData(key: "uId");
                RestaurantCubit.get(context).currentIndex = 0;
                RestaurantCubit.get(context).listIndex = 0;
                navigateAndFinish(context, RestaurantLoginScreen());

              }, text: "LogOut",),
            ],
          ),
        ),
      ),
    );
  }
}

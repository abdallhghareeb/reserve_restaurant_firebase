import 'package:flutter/material.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/cache_helper.dart';
import 'package:resturant/user/restaurant_login/restaurant_login_screen.dart';
import '../components.dart';
import '../constant.dart';

class UserScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          buildUserData(context),
        ],
      ),
    );
  }

  Widget buildUserData(context) {
    var model = RestaurantCubit.get(context);
    return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        const SizedBox(
          height: 15.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.text,
                      validate: (){}, label: "${model.myData['name']}",
                      isClickable: false
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (){}, label: "${model.myData['email']}",
                      isClickable: false
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (){}, label: "${model.myData['phone']}",
                      isClickable: false
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultButton(function: (){
                    RestaurantCubit.get(context).getUserData(CacheHelper.getData(key: "uId")).then((value) {
                      showDialog(context: context, builder: (context)
                      {
                        return AlertDialog(
                          title: const Text('My Booking',style: TextStyle(fontSize: 15.0),),
                          content:RestaurantCubit.get(context).myReserves.isEmpty ?  const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Text('no reserves yet',style:  TextStyle(fontSize: 15.0),),
                          ): Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              height: 250,
                              width: 300,
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return buildMyReservation(index,model,context);
                                  },
                                  separatorBuilder: (BuildContext context, int index) => Column(
                                    children: const [
                                      SizedBox(height: 25.0,),
                                    ],
                                  ),
                                  itemCount: model.myReserves.length),
                            ),
                          ),
                        );
                      });
                    });

                  }, text: "My Booking",),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultButton(function: (){
                    CacheHelper.removeData(key: "uId");
                    RestaurantCubit.get(context).currentIndex = 0;
                    RestaurantCubit.get(context).listIndex = 0;
                    navigateAndFinish(context, RestaurantLoginScreen());

                  }, text: "LogOut",),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
  }

  buildMyReservation(index,model,context){
    var model = RestaurantCubit.get(context).myReserves;
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child:InkWell(
       onTap: (){
         showDialog(context: context, builder: (context){
           idBookingController.text = model[index]['ReserveID'] ;
           dateBookingController.text = model[index]['startDate'] ;
           timeBookingController.text = model[index]['startTime'] ;
           durationBookingController.text = model[index]['duration'] ;
           tableBookingController.text = model[index]['tables'] ;
           chairsBookingController.text = model[index]['chairs'] ;
           foodBookingController.text = model[index]['food'] ;
           drinkBookingController.text = model[index]['drinks'] ;
           sweetsBookingController.text = model[index]['sweets'] ;

           return AlertDialog(
             title: const Text('My Booking',style:  TextStyle(fontSize: 15.0),),
             content: SizedBox(
               height: 600,
               width: 300,
               child: buildUserReserve(model[index], context,index),
             ) ,
           );
         });

       },
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text("${RestaurantCubit.get(context).myReserves[index]['startDate']}"),
         ],
       ),
     ) ,
   );
  }

  buildUserReserve(model,context,index){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reserve Id'),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: idBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Text('Date'),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: dateBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15.0,),
          const Text('Time'),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: timeBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),const Text('Duration'),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: durationBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Text('Food'),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: foodBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15.0,),
          const Text('Drinks '),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: drinkBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15.0,),
          const Text('Sweets'),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: sweetsBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),const Text('Tables Quantity'),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: tableBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),const Text('Chairs Quantity'),
          const SizedBox(height: 5.0,),
          TextFormField(
            readOnly: true,
            controller: chairsBookingController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),const Text('Total Bills'),

          const SizedBox(
            height: 5.0,
          ),
          defaultFormField(
              controller: emailController,
              type: TextInputType.emailAddress,
              validate: (){}, label: "${model['price']}",
              isClickable: false
          ),
          const SizedBox(
            height: 15.0,
          ),
          model['reserveDate'] != DateTime.now().toString().split(" ")[0] ? Container() : Row(
            children: [
              TextButton(onPressed: (){
                startDateController.text = model['startDate'];
                startTimeController.text = model['time'];
                checkTime = model['time'][0]==1?int.parse(model['time'][0]+model['time'][0]):int.parse(model['time'][0]);
                // durationController.text = model['duration'];
                tablesController.text = model['tables'];
                chairsController.text = model['chairs'];
                RestaurantCubit.get(context).reserveIdd = model['ReserveID'];
                Navigator.pop(context);
                Navigator.pop(context);
                RestaurantCubit.get(context).changeBottomNavBar(1);
              }, child:const Text("Edit" ),),
              const SizedBox(width: 5.0,),
              TextButton(onPressed: (){
                RestaurantCubit.get(context).deleteReserve(index: index,id : model['ReserveID'],userIdDelete: model['userId']);
                Navigator.pop(context);Navigator.pop(context);
              }, child:const Text("Delete"),),
            ],
          ),
      ],),
    );
  }

}

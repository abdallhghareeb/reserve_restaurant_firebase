import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/constant.dart';

import '../components.dart';

class Reservation extends StatelessWidget {
   Reservation({Key? key}) : super(key: key);

   var currentIndex;
  @override
  Widget build(BuildContext context) {
    
    var model =RestaurantCubit.get(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(child: Text('Reservation System')),
              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                  height: 500,
                  width: 400,
                  child: GridView.count(
                    padding: const EdgeInsets.all(2.5),
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 3,
                    children: List.generate(12, (monthIndex) {
                      return Container(
                        color: Colors.black45,
                        child: InkWell(
                            child: Center(child: Text(months[monthIndex])),
                            onTap: () async {
                              currentIndex = monthIndex;
                              print("${monthIndex + 1}");
                              model.checkMonth().then((value) {
                                showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                          title: model.available.contains("2022 ${months[monthIndex]}") ? const Center(child: Text("Choose Day", style: TextStyle(fontSize: 15.0),)) : const Text(""),
                                          content: !model.available.contains("2022 ${months[monthIndex]}") ? const Padding(padding: EdgeInsets.symmetric(horizontal: 50.0),
                                            child: Text("No Reservation this month", style: TextStyle(fontSize: 13.0), ),) :
                                          ConditionalBuilder(condition: true,
                                              builder: (context) {
                                                return Padding(padding: const EdgeInsets.all(1.0),
                                                  child: SizedBox(
                                                    height: 400,
                                                    width: 600,
                                                    child: GridView.count(
                                                      padding: const EdgeInsets.all(2.5), physics: const BouncingScrollPhysics(),
                                                      crossAxisCount: 4,
                                                      children: List.generate(
                                                          MyDateUtils.lastDayOfMonth(DateTime.utc(DateTime.now().year,monthIndex + 1)).day, (index) {
                                                        return Container(
                                                          color: Colors.black45,
                                                          child: InkWell(
                                                              child: Center(child: Text("${index + 1}")),
                                                              onTap: () async {
                                                                currentIndex = index;
                                                                print("my  index ${index + 1} ${months[monthIndex]}");
                                                                model.getReservesByMonth(dayIndex: index+1, monthIndex: monthIndex)
                                                                    .then((value) {
                                                                  showDialog(context: context, builder: (context) {
                                                                        return AlertDialog(
                                                                          title: model.reservesByMonth.isNotEmpty ? const Center(child: Text("",)) : const Text("",),
                                                                          content: model.reservesByMonth.isEmpty ? const Padding(padding: EdgeInsets.symmetric(horizontal: 50.0),
                                                                            child: Text("No Reservations today", style: TextStyle(fontSize: 13.0),),) :
                                                                          SizedBox(height: 350, width: 600,
                                                                            child: Column(
                                                                              children: [
                                                                                const Text("Reserves", style: TextStyle(fontSize: 13.0),),
                                                                                const SizedBox(height: 30.0,),
                                                                                Row(
                                                                                  children: const [
                                                                                    SizedBox(width: 15.0,),
                                                                                    Expanded(child: Text('start date')),
                                                                                    SizedBox(width: 45.0,),
                                                                                    Expanded(child: Text("end date")),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(height: 30.0,),
                                                                                Expanded(child: ListView.separated(
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return buildMyReservation(index, context);},
                                                                                    separatorBuilder: (BuildContext context, int index) => Column(
                                                                                      children: const [SizedBox(height: 25.0,),

                                                                                      ],
                                                                                    ),
                                                                                    itemCount: model.reservesByMonth.length,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                });
                                                              }),
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                );
                                              },
                                              fallback: (context) => const Center(child: CircularProgressIndicator())));
                                    });
                              });
                            }),
                      );
                    }),
                  )),
            ],
          ),
        ),
      ),
    );
  }

   buildMyReservation(index,context){
     var model = RestaurantCubit.get(context).reservesByMonth;
     return Padding(
       padding: const EdgeInsets.all(10.0),
       child:InkWell(
         onTap: (){
           idBookingController.text = model[index]['ReserveID'] ;
           dateBookingController.text = model[index]['startDate'] ;
           timeBookingController.text = model[index]['startTime'] ;
           durationBookingController.text = model[index]['duration'] ;
           tableBookingController.text = model[index]['tables'] ;
           chairsBookingController.text = model[index]['chairs'] ;
           foodBookingController.text = model[index]['food'] ;
           drinkBookingController.text = model[index]['drinks'] ;
           sweetsBookingController.text = model[index]['sweets'] ;
           showDialog(context: context, builder: (context){
             return AlertDialog(
               title: const Text('My Booking',style:  TextStyle(fontSize: 15.0),),
               content: SizedBox(
                 height: 600,
                 width: 300,
                 child: buildUserReserve(model[index], context,index),
               ),
             );
           });

         },
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                 Expanded(child: Text("${model[index]['startDate']}")),
                 const SizedBox(width: 50.0,),
                 Expanded(child: Text("${model[index]['endDate']}")),
               ],
             ),
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
               controller: idController,
               type: TextInputType.emailAddress,
               validate: (){}, label: "${model['price']}",
               isClickable: false
           ),
           const SizedBox(
             height: 15.0,
           ),
            model['reserveDate'] != DateTime.now().toString().split(" ")[0] ? Container() :TextButton(onPressed: (){
             RestaurantCubit.get(context).deleteReserve(index: index,id : RestaurantCubit.get(context).reservesByMonth[index]['ReserveID'],userIdDelete:RestaurantCubit.get(context).reservesByMonth[index]['userId']);
             Navigator.pop(context);Navigator.pop(context);
           }, child:const Text("Cancel Reservation"),),
         ],),
     );
   }

}

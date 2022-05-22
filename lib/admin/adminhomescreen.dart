import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/admin/uploaditemscreen.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/bloc/cubit/states.dart';
import 'package:resturant/constant.dart';
import 'package:resturant/model/itemmodel.dart';

class AdminHomeScreen extends StatelessWidget {

  const AdminHomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color defaultColor = Colors.teal;
    Color markColor = Colors.teal.withOpacity(0.4);
    var cubit = RestaurantCubit.get(context);
    return BlocConsumer<RestaurantCubit, RestaurantStates>(
        listener: (BuildContext context, RestaurantStates state) {},
        builder: (BuildContext context, RestaurantStates state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),color: cubit.listIndex == 0 ?markColor  : defaultColor
                          ),
                          child: TextButton(
                            onPressed: (){
                              cubit.listIndex =0;
                              cubit.changListSuccess();
                            },
                            child:const Text("Food",style: TextStyle(color: Colors.white),),),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),color: cubit.listIndex == 1 ? markColor  : defaultColor
                          ),
                          child: TextButton(
                            onPressed: (){
                              cubit.listIndex =1;
                              cubit.changListSuccess();
                            },
                            child:const Text("Drinks",style: TextStyle(color: Colors.white),),),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),color: cubit.listIndex == 2 ? markColor : defaultColor
                            ),
                            child: TextButton(
                              onPressed: (){
                                cubit.listIndex =2;
                                cubit.changListSuccess();
                              },
                              child:const Text("Sweets",style: TextStyle(color: Colors.white),),)
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container (
                  child: changItemList(cubit.listIndex, context) ,
                )


              ],
            ),
          );
        });
  }

  Widget foodList(context) {
    var cubit = RestaurantCubit.get(context);
    return SizedBox(
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(cubit.food.length, (index) {
          return InkWell(
              onTap: () {
                itemIndex = index;
                category = RestaurantCubit.get(context).food;
                catController.text = category[index].category!;
                rateController.text = category[index].rate!;
                imgController.text = category[index].img!;
                titleController.text = category[index].title!;
                priceController.text = category[index].price!;
                descriptionController.text = category[index].description!;
                RestaurantCubit.get(context).itemID = category[index].itemID;
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadItemScreen()));
              },
              child: buildItem(cubit.food[index], context, index));
        }),
      ),
    );
  }

  Widget drinkList(context) {
    var cubit = RestaurantCubit.get(context);
    return SizedBox(
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(cubit.drinks.length, (index) {
          return InkWell(
              onTap: () {
                itemIndex = index;
                category = RestaurantCubit.get(context).drinks;
                catController.text = category[index].category!;
                rateController.text = category[index].rate!;
                imgController.text = category[index].img!;
                titleController.text = category[index].title!;
                priceController.text = category[index].price!;
                descriptionController.text = category[index].description!;
                RestaurantCubit.get(context).itemID = category[index].itemID;
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadItemScreen()));
              },
              child: buildItem(cubit.drinks[index], context, index));
        }),
      ),
    );
  }

  Widget sweetsList(context) {
    var cubit = RestaurantCubit.get(context);
    return SizedBox(
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(cubit.sweets.length, (index) {
          return InkWell(
              onTap: () {
                itemIndex = index;
                category = RestaurantCubit.get(context).sweets;
                rateController.text = category[index].rate!;
                catController.text = category[index].category!;
                imgController.text = category[index].img!;
                rateController.text = category[index].rate!;
                titleController.text = category[index].title!;
                priceController.text = category[index].price!;
                descriptionController.text = category[index].description!;
                RestaurantCubit.get(context).itemID = category[index].itemID;
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadItemScreen()));
              },
              child: buildItem(cubit.sweets[index], context, index));
        }),
      ),
    );
  }

  Widget buildItem(ItemModel model, context, index) {
    var cubit = RestaurantCubit.get(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Dismissible(
        direction: DismissDirection.startToEnd,
        key: UniqueKey(),
        background: Container(
          color: Colors.redAccent,
          child: const Center(child:  Text('Delete Item',style: TextStyle(fontWeight: FontWeight.bold),)),
        ),
        onDismissed: (direction){
          if(direction == DismissDirection.startToEnd){
            var deletedItem =model;
            cubit.deleteItem(itemId: model.itemID!);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1),
                content: Row(
                  children: [
                    Text('Item ${model.title} Deleted'),
                    TextButton(onPressed: (){
                      cubit.uploadItem(rate: deletedItem.rate,title: deletedItem.title!,price: deletedItem.price!,description: deletedItem.description!,img: deletedItem.img!,category: deletedItem.category!,);
                    }, child: const Text('Undo',style:  TextStyle(color:Colors.redAccent),))
                  ],
                )
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topRight:  Radius.circular(7.0),topLeft:  Radius.circular(7.0),bottomLeft: Radius.circular(7.0) ,bottomRight:  Radius.circular(7.0)),
                child: Container(
                  height: 163,
                  width: 180,
                  color :Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(

                          child: Image(
                            isAntiAlias: true,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            image: NetworkImage("${model.img}",),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${model.title}',
                              style: const TextStyle(color: Colors.black, fontSize: 13.0),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              '${model.price} EGP',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 2.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget changItemList(int index, context) {
    if (index == 0) {
      return foodList(context);
    }
    if (index == 1) {
      return drinkList(context);
    }
    if (index == 2) {
      return sweetsList(context);
    }
    return Container();
  }
}

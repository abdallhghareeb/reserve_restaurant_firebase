import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/bloc/cubit/states.dart';
import 'package:resturant/components.dart';
import 'package:resturant/constant.dart';
import 'package:resturant/model/itemmodel.dart';
import 'package:resturant/user/item_screen.dart';

class UserHomeScreen extends StatelessWidget {


   UserHomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    Color defaultColor = Colors.teal;
    Color markColor = Colors.teal.withOpacity(0.4);
    var cubit = RestaurantCubit.get(context);
    return BlocConsumer<RestaurantCubit, RestaurantStates>(
        listener: (BuildContext context, RestaurantStates state) {},
        builder: (BuildContext context, RestaurantStates state) {

          return RefreshIndicator(
            onRefresh: cubit.getItems,
            child: SingleChildScrollView(
              physics : const AlwaysScrollableScrollPhysics(),
              child: RefreshIndicator(
                onRefresh: cubit.getItems,
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
                                  cubit.listIndex = 0;
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
              ),
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
                if(enable){
                  itemIndex = index;
                  category = RestaurantCubit.get(context).food;
                  descriptionController.text = category[itemIndex!].description;
                  cubit.getUpdate(id:category[itemIndex].itemID ).then((value) {
                    navigateTo(context, const ItemScreen());
                  });
                  rate=null;
                  enable = false;
                }


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
                if(enable){
                  itemIndex = index;
                  category = RestaurantCubit.get(context).drinks;
                  descriptionController.text = category[itemIndex].description;
                  cubit.getUpdate(id:category[itemIndex].itemID ).then((value) {
                    navigateTo(context, const ItemScreen());
                  });
                  rate=null;
                  enable = false;
                }

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
                if(enable){
                  itemIndex = index;
                  category = RestaurantCubit.get(context).sweets;
                  descriptionController.text = category[itemIndex!].description;
                  cubit.getUpdate(id:category[itemIndex].itemID ).then((value) {
                    navigateTo(context, const ItemScreen());
                  });
                  rate=null;
                  enable = false;
                }

              },
              child: buildItem(cubit.sweets[index], context, index));
        }),
      ),
    );
  }

  Widget buildItem(ItemModel model, context, index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(7.0),topLeft: Radius.circular(7.0),bottomLeft:Radius.circular(7.0) ,bottomRight: Radius.circular(7.0)),
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
    );
  }

  changItemList(int index, context) {
    if (index == 0) {
      return foodList(context);
    }
    if (index == 1) {
      return drinkList(context);
    }
    if (index == 2) {
      return sweetsList(context);
    }

  }

}

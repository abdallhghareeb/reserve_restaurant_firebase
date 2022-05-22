import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/bloc/cubit/states.dart';
import 'package:resturant/constant.dart';

import '../cache_helper.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(rate == null){
      rate = double.parse(category[itemIndex].rate);
      num = int.parse(category[itemIndex].numUserRate);
    }
    var cubit = RestaurantCubit.get(context);
    return BlocConsumer<RestaurantCubit, RestaurantStates>(
        listener: (BuildContext context, RestaurantStates state) {

        },
        builder: (BuildContext context, RestaurantStates state) {
          enable = true;
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  "${category[itemIndex!].title}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(alignment: AlignmentDirectional.bottomStart, children: [
                    Image(
                      height: 250.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      image: NetworkImage("${category[itemIndex!].img}"),
                    ),
                    Center(
                      child: Container(
                        height: 40.0,
                        width: double.infinity,
                        color: Colors.teal.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${category[itemIndex!].price} EGP",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.white.withOpacity(1),
                      child: TextFormField(
                        readOnly: true,
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: [
                        const Text(
                          "Rate Me !",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        const Text(
                          " Evaluators is ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "$num",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          rate!.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                        RatingBar.builder(
                            initialRating: rate!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            maxRating: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.teal,
                                ),
                            onRatingUpdate: (rating)  {
                              cubit.submitUserRates(
                                user: CacheHelper.getData(key: "uId"),
                                rate: rating,
                                id: category[itemIndex].itemID,
                              );
                              },
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

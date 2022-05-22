import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resturant/bloc/Layout.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/components.dart';
import 'package:resturant/constant.dart';
import 'package:resturant/user/user_home_screen.dart';

class UploadItemScreen extends StatelessWidget {
   UploadItemScreen({Key? key}) : super(key: key);


  var formKey = GlobalKey<FormState>();


   @override
  Widget build(BuildContext context) {
    var cubit = RestaurantCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("admin control")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "image",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          controller: imgController,
                          validator: (value){
                            if(value!.isEmpty && RestaurantCubit.get(context).itemImageUrl==null){
                              return "image is required";
                            }
                          },
                        ),
                      ),
                      IconButton(onPressed: (){
                        cubit.getItemImage().then((value) {
                          cubit.uploadItemImage();
                        });
                      }, icon:Icon(Icons.camera_alt)),
                    ],
                  ),
                  SizedBox(height: 25.0,),
                  defaultFormField(
                    label: "title",
                    name: "title",
                    type: TextInputType.text,
                    controller: titleController,
                    validate: (){},
                  ),
                  SizedBox(height: 25.0,),
                  defaultFormField(
                    label: "price",
                    name: "price",
                    type: TextInputType.number,
                    controller: priceController,
                    validate: (){},
                  ),
                  SizedBox(height: 25.0,),
                  defaultFormField(
                    label: "description",
                    name: "description",
                    type: TextInputType.text,
                    controller: descriptionController,
                    validate: (){},
                  ),
                  SizedBox(height: 25.0,),
                  defaultFormField(
                    isClickable: false,
                    label: "Choose Category below",
                    name: "Category",
                    type: TextInputType.text,
                    controller: catController,
                    validate: (){},
                  ),
                  SizedBox(height: 25.0,),
                  Row(
                    children: [
                      Expanded(child: TextButton(onPressed: (){catController.text = "food";}, child: Text("Food"))),
                      Expanded(child: TextButton(onPressed: (){catController.text = "drink";}, child: Text("Drink"))),
                      Expanded(child: TextButton(onPressed: (){catController.text = "sweets";}, child: Text("Sweet"))),
                    ],
                  ),
                  SizedBox(height: 25.0,),
                  TextFormField(decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Rating',
                  ),
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: rateController,
                  ),
                  SizedBox(height: 25.0,),
                  defaultButton(function: (){
                    if(formKey.currentState!.validate()){
                      cubit.uploadItem(
                        category: catController.text,
                        img: RestaurantCubit.get(context).itemImageUrl == null ? imgController.text : cubit.itemImageUrl!,
                        title: titleController.text,
                        description: descriptionController.text,
                        price: priceController.text,
                        rate: rateController.text == "" ? "1.0": rateController.text,
                      );
                      Navigator.pop(context);
                      RestaurantCubit.get(context).itemImageUrl=null;
                    }

                  }, text: "Upload Item"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

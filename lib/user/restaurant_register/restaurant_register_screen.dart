import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/components.dart';
import 'package:resturant/user/restaurant_login/restaurant_login_screen.dart';
import 'package:resturant/user/restaurant_register/cubit/cubit.dart';
import 'package:resturant/user/restaurant_register/cubit/states.dart';

class RestaurantRegisterScreen extends StatelessWidget {
  const RestaurantRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocConsumer<RestaurantRegisterCubit,RestaurantRegisterStates>(
      listener: (context,state){
        if(state is RestaurantRegisterErrorState){
          showToast(text:"Email already exists", state: ToastStates.ERROR);

        }
        if(state is RestaurantCreateUserSuccessState){
          showToast(text:"Register Successfully", state: ToastStates.SUCCESS);
          navigateAndFinish(
              context,
              RestaurantLoginScreen());
        }
      },
      builder: (context,state){
        var regCubit = RestaurantRegisterCubit.get(context);
        return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REGISTER",
                      style:
                      Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Register now to Easy Booking",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.grey),
                    ),
                    SizedBox(
                      height:20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "User Name",prefixIcon: Icon(Icons.person),
                      ),
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'User Name is required';
                          }
                        },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),labelText: "Email Address",
                      ),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                        if(value!.isEmpty){
                          return "Email is required";
                        }
                        },

                        ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                        name: "Password",
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        suffix: regCubit.suffix,
                        suffixPressed: () {
                         regCubit.changePasswordVisibility();
                        },
                        isPassword: regCubit.isPassword,
                        onSubmit:(value){},
                        validate: () {},
                        label: "Password",
                        prefix: Icons.lock_outlined
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(

                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if(value!.isEmpty ){
                          return "Phone is required";
                        }
                        if(value.length != 11){
                          return "Phone isn't correct";
                        }
                      },

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "Phone Number",
                      ),

                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! RestaurantRegisterLoadingState,
                      builder: (context) => defaultButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            regCubit.userRegister(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              phone:phoneController.text,
                            );
                          }
                        },
                        text: "Register",
                        isUpperCase: true,
                      ),
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                defaultButton(
                  function: () {
                    navigateAndFinish(
                          context,
                          RestaurantLoginScreen());
                    },
                  text: "Login",
                  isUpperCase: true,
                ),

                  ],
                ),
              ),
            ),
          ),
        ),
      );},
    );
  }
}

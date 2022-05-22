import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/bloc/Layout.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/cache_helper.dart';
import 'package:resturant/components.dart';
import 'package:resturant/user/restaurant_login/cubit/cubit.dart';
import 'package:resturant/user/restaurant_login/cubit/states.dart';
import 'package:resturant/user/restaurant_register/restaurant_register_screen.dart';

class RestaurantLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();

    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => RestaurantLoginCubit() ,
      child: BlocConsumer<RestaurantLoginCubit, RestaurantLoginStates>(
        listener: (context, state) {
          if (state is RestaurantLoginErrorState) {
            showToast(text:"Email or Password doesn't correct", state: ToastStates.ERROR);
            }
          else if (state is RestaurantLoginSuccessState)
          {
            RestaurantCubit.get(context).getUserData(state.uId);
            RestaurantCubit.get(context).userId = state.uId;

            showToast(text:"Login Successfully",
                state: ToastStates.SUCCESS);
            CacheHelper.savaData(
                key: "uId",
                value: state.uId
            )
                .then((value) {

              navigateAndFinish(context, LayoutPage());
            });
          }
        },
        builder: (context, state) {
          var logCubit = RestaurantLoginCubit.get(context);
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
                          "Login",
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          "Login now to Easy Booking",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            name: "Email",
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: () {},
                            label: "Email Address",
                            prefix: Icons.email_outlined),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            name: "Password",
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: logCubit.suffix,
                            suffixPressed: () {
                              logCubit.changePasswordVisibility();
                            },
                            isPassword: logCubit.isPassword,
                            validate: () {},
                            label: "Password",
                            prefix: Icons.lock_outlined),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! RestaurantLoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                logCubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: "Login",
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have account ?"),
                            defaultTextButton(
                              function: () {
                                navigateAndFinish(
                                    context, RestaurantRegisterScreen());
                              },
                              text: "Register",
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

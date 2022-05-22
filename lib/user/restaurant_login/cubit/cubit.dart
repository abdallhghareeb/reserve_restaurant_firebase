import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/user/restaurant_login/cubit/states.dart';

class RestaurantLoginCubit extends Cubit<RestaurantLoginStates> {
  RestaurantLoginCubit() : super(RestaurantLoginInitialState());

  static RestaurantLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(RestaurantLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((value){
      print(value.user?.email);
      print(value.user?.uid);
      emit(RestaurantLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(RestaurantLoginErrorState(error.toString()));
    });

  }
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true ;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RestaurantChangePasswordVisibilityState());
  }

}
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/bloc/Layout.dart';
import 'package:resturant/bloc/cubit/cubit.dart';
import 'package:resturant/cache_helper.dart';
import 'package:resturant/user/restaurant_login/cubit/cubit.dart';
import 'package:resturant/user/restaurant_login/restaurant_login_screen.dart';
import 'package:resturant/user/restaurant_register/cubit/cubit.dart';
import 'bloc/cubit/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Widget? widget ;
  String? uId =  CacheHelper.getData(key:"uId");
  if(uId == null){
    widget = RestaurantLoginScreen();
  }else{
    widget=LayoutPage();
  }

  BlocOverrides.runZoned(
        () {
      runApp(MyApp(startWidget:widget));
    },
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget {
  final Widget? startWidget;


  MyApp({this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => RestaurantCubit()..getItems()..getUserData(CacheHelper.getData(key: "uId"))),
          BlocProvider(create: (context) => RestaurantRegisterCubit()),
          BlocProvider(
            create: (context) => RestaurantLoginCubit(),
          ),
        ],
        child: MaterialApp(
          home: AnimatedSplashScreen(
              duration: 2500,
              splash: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Image.asset("images/logo.png",height: 84),
                ],
              ),
              nextScreen: startWidget!,
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: Colors.white

          ),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.teal,
              bottomNavigationBarTheme:const BottomNavigationBarThemeData(backgroundColor: Colors.teal)),
        ));
  }
}

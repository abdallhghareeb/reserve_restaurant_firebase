
abstract class RestaurantRegisterStates {}

class RestaurantRegisterInitialState extends RestaurantRegisterStates {}

class RestaurantRegisterLoadingState extends RestaurantRegisterStates {
}
class RestaurantRegisterSuccessState extends RestaurantRegisterStates {}

class RestaurantRegisterErrorState extends RestaurantRegisterStates {
  final String error;
  RestaurantRegisterErrorState(this.error);
}
class RestaurantRegisterChangePasswordVisibilityState extends RestaurantRegisterStates{}

class RestaurantCreateUserSuccessState extends RestaurantRegisterStates {}

class RestaurantCreateUserErrorState extends RestaurantRegisterStates {
  final String error;
  RestaurantCreateUserErrorState(this.error);
}

class SocialRegisterChangePasswordVisibilityState extends RestaurantRegisterStates {}

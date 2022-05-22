
abstract class RestaurantLoginStates {}

class RestaurantLoginInitialState extends RestaurantLoginStates {}

class RestaurantLoginLoadingState extends RestaurantLoginStates {
}
class RestaurantLoginSuccessState extends RestaurantLoginStates {
  final String uId;
  RestaurantLoginSuccessState(this.uId);

}
class RestaurantLoginErrorState extends RestaurantLoginStates {
  final String? error;
  RestaurantLoginErrorState(this.error);
}
class RestaurantChangePasswordVisibilityState extends RestaurantLoginStates{}
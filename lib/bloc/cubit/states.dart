abstract class RestaurantStates {}

class InitialState extends RestaurantStates {}

class BottomNavBar extends RestaurantStates {}

class GetListSuccess extends RestaurantStates {}

class UpdateItemsRateSuccessState extends RestaurantStates {
  final double rate;
  final int num;
  UpdateItemsRateSuccessState(this.num,this.rate);

}

class PostItemsSuccessState extends RestaurantStates {}

class PostItemsLoadingState extends RestaurantStates {}

class PostItemsErrorState extends RestaurantStates {}

class GetItemsSuccessState extends RestaurantStates {}

class GetItemsLoadingState extends RestaurantStates {}

class GetItemsErrorState extends RestaurantStates {}

class PostReserveSuccessState extends RestaurantStates {}

class PostReserveLoadingState extends RestaurantStates {}

class PostReserveErrorState extends RestaurantStates {}

class GetReserveSuccessState extends RestaurantStates {}

class GetReserveLoadingState extends RestaurantStates {}

class GetReserveErrorState extends RestaurantStates {}

class GetUserReserveSuccessState extends RestaurantStates {}

class DeleteReserveSuccessState extends RestaurantStates {}

class DeleteReserveErrorState extends RestaurantStates {}

class GetUserReserveLoadingState extends RestaurantStates {}

class GetUserReserveErrorState extends RestaurantStates {}

class UpdateReserveLoadingState extends RestaurantStates {}

class UpdateReserveSuccessState extends RestaurantStates {}

class UpdateReserveErrorState extends RestaurantStates {}

class DeletedItemSuccess extends RestaurantStates {}

class SelectImageSuccess extends RestaurantStates {}

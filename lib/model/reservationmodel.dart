class ReserveModel {
  String? reserveID;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? duration;
  String? food;
  String? drinks;
  String? sweets;
  String? tables;
  String? chairs;
  String? userId;
  int? price;
  String? reserveDate;
  ReserveModel({
    this.reserveID,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.duration,
    this.food,
    this.tables,
    this.chairs,
    this.userId,
    this.price,
    this.sweets,
    this.drinks,
    this.reserveDate
  });
  ReserveModel.fromJson(Map<String,dynamic> data){
    reserveID = data['ReserveID'];
    startTime = data['startTime'];
    endTime = data['endTime'];
    startDate = data['startDate'];
    endDate = data['endDate'];
    duration = data['duration'];
    food = data['food'];
    sweets = data['sweets'];
    drinks = data['drinks'];
    tables = data['tables'];
    chairs = data['chairs'];
    userId = data['userId'];
    price = data['price'];
    reserveDate = data['reserveDate'];

  }

  Map<String,dynamic> toMap(){
    return {
      'ReserveID': reserveID,
      'startDate': startDate,
      'endDate':endDate,
      'startTime': startTime,
      'endTime':endTime,
      'food': food,
      'duration':duration,
      'tables':tables,
      'chairs':chairs,
      'userId':userId,
      'price':price,
      'drinks':drinks,
      'sweets':sweets,
      'reserveDate':reserveDate,
    };
  }

}
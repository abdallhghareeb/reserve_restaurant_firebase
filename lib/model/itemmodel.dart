class ItemModel {
  String? itemID;
  String? title;
  String? img;
  String? description;
  String? category;
  String? price;
  String ? rate;
  String ? numUserRate;
  ItemModel({
    this.itemID,
    this.title,
    this.img,
    this.description,
    this.price,
    this.category,
    this.rate,
    this.numUserRate
  });
  ItemModel.fromJson(Map<String,dynamic> json){
    itemID = json['ItemID'];
    img = json['img'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    category = json['category'];
    rate = json['rate'];
    numUserRate = json['numUserRate'];
  }

  Map<String,dynamic> toMap(){
    return {
      'ItemID': itemID,
      'title': title,
      'img': img,
      'description': description,
      'price':price,
      'category':category,
      'rate':rate,
      'numUserRate':numUserRate,
    };
  }

}
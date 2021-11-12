
// Product (name + image) Model
class Product{
  final int       id;
  final String    brand;
  final String    name;
  final String    shade;
  final String    imageLargeURL;
  final String    imageThumbURL;
  final String    rate;

  Product({
    this.id,
    this.brand,
    this.name,
    this.shade,
    this.imageLargeURL,
    this.imageThumbURL,
    this.rate,
  });

  factory Product.fromJson(Map<String, dynamic> json){
    return  Product(
      id:     json['id'],
      brand:  json['marque'],
      name:   json['nom'],
      shade:  json['teinte'],
      rate:   json['rate'],
      imageLargeURL: json['large_image'],
      imageThumbURL: json['thumb_image'],
    );
  }
}


// Inventory List Model
class InventoryList {
  List<Product>   products;

  InventoryList({ this.products });

  // Json factory
  factory InventoryList.fromJson(List<dynamic> parsedJson) {
    List<Product>     products;

    products = parsedJson.map( (i) => Product.fromJson(i) ).toList();
    return InventoryList(
       products: products,
    );
  }

  // List factory
  factory InventoryList.fromList(List<Product> products) {
    return InventoryList(
       products: products,
    );
  }

  // Is Empty method
  bool      isEmpty() {
    return (this.products.length == 0);
  } 

  // Is Empty method
  int       length() {
    return this.products.length;
  } 

}
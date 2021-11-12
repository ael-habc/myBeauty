//
/// Product (name + image) Model
//


class Product{
  final String    name;
  final String    imageLargeURL;
  final String    imageThumbURL;

  Product({
    this.name,
    this.imageLargeURL,
    this.imageThumbURL
  });

  factory Product.fromJson(Map<String, dynamic> json){
    return  Product(
      name:          json['nom'],
      imageLargeURL: json['large_image'],
      imageThumbURL: json['thumb_image'],
    );
  }
}


// List of Products Model
class ProductsList {
  List<Product>   products;

  ProductsList({ this.products });

  // Json factory
  factory ProductsList.fromJson(List<dynamic> parsedJson) {
    List<Product>     products;

    products = parsedJson.map( (i) => Product.fromJson(i) ).toList();
    return ProductsList(
       products: products,
    );
  }

  // List factory
  factory ProductsList.fromList(List<Product> products) {
    return ProductsList(
       products: products,
    );
  }

  // Is Empty method
  bool      isEmpty() {
    return (this.products.length == 0);
  } 

}
//
/// Teinte (shade + id) Model
//

class Teinte{
  final int       id;
  final String    shade;

  Teinte({
    this.id,
    this.shade,
  });

  factory Teinte.fromJson(Map<String, dynamic> json){
    return  Teinte(
      id:     json['id'],
      shade:  json['teinte'],
    );
  }
}


// List of Teintes Model
class TeintesList {
  List<Teinte>   teintes;

  TeintesList({ this.teintes });

  // Json factory
  factory TeintesList.fromJson(List<dynamic> parsedJson) {
    List<Teinte>     teintes;

    teintes = parsedJson.map( (i) => Teinte.fromJson(i) ).toList();
    return TeintesList(
       teintes: teintes,
    );
  }

  // List factory
  factory TeintesList.fromList(List<Teinte> teintes) {
    return TeintesList(
       teintes: teintes,
    );
  }

  // Is Empty method
  bool      isEmpty() {
    return (this.teintes.length == 0);
  }

  // Get Id from shade
  int       getID(String shade) {
    int   id = 0;
  
    this.teintes.forEach((element) {
      if (element.shade.toLowerCase() == shade.toLowerCase())
        id = element.id;
    });
    return id;
  } 

}
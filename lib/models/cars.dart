class Car {
  final int _id;
  final String _name;
  final String _brand;
  final int _year;
  final double _price; 
  final String _description;
  final String _image;

  Car({
    required this._id,
    required this._name,
    required this._brand,
    required this._year,
    required this._price,
    required this._description,
    required this._image,
  });

  // Getter
  int get id => _id;
  String get name => _name;
  String get brand => _brand;
  int get year => _year;
  double get price => _price;
  String get description => _description;
  String get image => _image;

  @override
  String toString() {
    return 'Cars(name: $_name, brand: $_brand, year: $_year, price: $_price, description: $_description, image: $_image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Car) return false;
    return _id == other._id &&_name == other._name;
  }

  @override
  int get hashCode => Object.hash(_id, _name);
}

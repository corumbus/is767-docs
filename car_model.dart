import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Car {
  String id;
  String brand;
  String imagePath;
  String model;
  num price;

  Car(this.id, this.brand, this.imagePath, this.model, this.price);

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      json['id'] as String,
      json['brand'] as String,
      json['imagePath'] as String,
      json['model'] as String,
      json['price'] as num,
    );
  }

  factory Car.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return Car(
      snapshot.id,
      json['brand'] as String,
      json['imagePath'] as String,
      json['model'] as String,
      json['price'] as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'imagePath': imagePath,
      'model': model,
      'price': price,
    };
  }

  String toString() {
    return 'YourClassName{id: $id, brand: $brand, imagePath: $imagePath, model: $model, price: $price}';
  }
}

class AllCars {
  final List<Car> cars;

  AllCars(this.cars);

  factory AllCars.fromJson(List<dynamic> json) {
    List<Car> cars = json.map((item) => Car.fromJson(item)).toList();
    return AllCars(cars);
  }

  factory AllCars.fromSnapshot(QuerySnapshot qs) {
    List<Car> cars = qs.docs.map((DocumentSnapshot ds) {
      Map<String, dynamic> dataWithId = ds.data() as Map<String, dynamic>;
      dataWithId['id'] = ds.id;
      return Car.fromJson(dataWithId);
    }).toList();
    return AllCars(cars);
  }

  Map<String, dynamic> toJson() {
    return {
      'cars': cars.map((car) => car.toJson()).toList(),
    };
  }
}

class CarsProvider extends ChangeNotifier {
  List<Car>? _allCars = [];

  List<Car>? get allCars => _allCars;

  void setCars(List<Car>? cars) {
    _allCars = cars;
    notifyListeners();
  }

  void addCar(Car car) {
    print("addCar @ provider is called");
    _allCars!.add(car);
    notifyListeners();
  }

  void updateCar(Car updatedCar) {
    print("updateCar @ provider is called");
    int index = _allCars!.indexWhere((car) => car.id == updatedCar.id);
    if (index != -1) {
      _allCars![index] = updatedCar;
      notifyListeners();
    }
  }
}

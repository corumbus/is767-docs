import 'dart:async';

import 'package:first_app/models/car_model.dart';
import 'package:first_app/services/car_service.dart';

class CarController {
  final CarService _carService = CarService();

  StreamController<bool> onSyncController = StreamController();
  Stream<bool> get onSync => onSyncController.stream;

  Future<List<Car>> fetchCars() async {
    print('fetchCars is called');
    onSyncController.add(true);
    try {
      List<Car> cars = await _carService.fetchCars();
      print(cars);
      onSyncController.add(false);
      return cars;
    } catch (e) {
      onSyncController.add(false);
      throw e;
    }
  }

  Future<Car?> addCar(Map<String, dynamic> newCarData) async {
    print('addCar is called');
    onSyncController.add(true);
    try {
      Car addedCar = await _carService.addCar(newCarData);
      print(addedCar);
      onSyncController.add(false);
      return addedCar;
    } catch (e) {
      print("Error adding car: $e");
      onSyncController.add(false);
      return null;
    }
  }

  Future<Car?> updateCar(
      String carId, Map<String, dynamic> updatedCarData) async {
    print('updateCar is called');
    onSyncController.add(true);
    try {
      Car updatedCar = await _carService.updateCar(carId, updatedCarData);
      print(updatedCar);
      onSyncController.add(false);
      return updatedCar;
    } catch (e) {
      print("Error updating car: $e");
      onSyncController.add(false);
      return null;
    }
  }
}

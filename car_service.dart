import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/car_model.dart';

class CarService {
  Future<List<Car>> fetchCars() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('cars').get();

      print("Cars in firebase count:${snapshot.docs.length}");

      return snapshot.docs.map((doc) => Car.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Error fetching cars: $e");
      throw e; // rethrow the error for the controller to handle
    }
  }

  Future<Car> addCar(Map<String, dynamic> newCarData) async {
    try {
      DocumentReference ref =
          await FirebaseFirestore.instance.collection('cars').add(newCarData);

      // Fetch the newly added document
      DocumentSnapshot newDoc = await ref.get();
      return Car.fromSnapshot(newDoc);
    } catch (e) {
      print("Error adding car: $e");
      throw e; // rethrow the error for the controller to handle
    }
  }

  Future<Car> updateCar(
      String carId, Map<String, dynamic> updatedCarData) async {
    try {
      DocumentReference carRef =
          FirebaseFirestore.instance.collection('cars').doc(carId);

      // Update the document
      await carRef.update(updatedCarData);

      // Fetch the updated document
      DocumentSnapshot updatedDoc = await carRef.get();
      return Car.fromSnapshot(updatedDoc);
    } catch (e) {
      print("Error updating car: $e");
      throw e;
    }
  }

  // Future<void> deleteCar(String carId) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('cars')
  //         .doc(carId)
  //         .delete();
  //   } catch (e) {
  //     print("Error deleting car: $e");
  //     throw e; // rethrow the error for the controller to handle
  //   }
  // }
}

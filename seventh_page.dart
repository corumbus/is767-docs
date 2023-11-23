import 'package:first_app/controllers/car_controller.dart';
import 'package:first_app/models/car_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeventhPage extends StatefulWidget {
  @override
  _SeventhPageState createState() => _SeventhPageState();
}

class _SeventhPageState extends State<SeventhPage> {
  List<Car> cars = List.empty();
  bool isLoading = false;
  CarController _carController = CarController();

  @override
  void initState() {
    super.initState();
    _getCars();
  }

  void _getCars() async {
    print('_getCars start');
    var newCarData = await _carController.fetchCars();
    print(newCarData.length);
    cars = newCarData;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      CarsProvider carsProvider = context.read<CarsProvider>();
      carsProvider.setCars(cars);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cars'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddCarPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Car',
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: context.watch<CarsProvider>().allCars?.length ?? 0,
              itemBuilder: (context, index) {
                final car = context.watch<CarsProvider>().allCars?[index];
                if (car == null) return Container(); // Handle null case

                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditCarPage(car: car),
                        ),
                      );
                    },
                    leading: Image.network(
                      car.imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                            Icons.error); // Placeholder in case of error
                      },
                    ),
                    title: Text(car.brand),
                    subtitle: Text(
                        'Model: ${car.model}\nID: ${car.id}\nPrice: \$${car.price}'),
                    isThreeLine: true,
                    // Add onTap or other interactions if needed
                  ),
                );
              },
            ),
    );
  }
}

class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  String brand = '';
  String imagePath = '';
  String model = '';
  num price = 0;

  CarController _carController = CarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Car'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Brand'),
                onSaved: (value) => brand = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a brand' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image Path'),
                onSaved: (value) => imagePath = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an image path' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model'),
                onSaved: (value) => model = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a model' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = num.tryParse(value!) ?? 0,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // call controller
                    Car? newCar = await _carController.addCar({
                      "brand": brand,
                      "imagePath": imagePath,
                      "model": model,
                      "price": price
                    });
                    print(newCar?.toJson());

                    // adding new Car to state
                    context.read<CarsProvider>().addCar(newCar!);

                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditCarPage extends StatefulWidget {
  final Car car;

  EditCarPage({required this.car});

  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final _formKey = GlobalKey<FormState>();
  late String brand;
  late String imagePath;
  late String model;
  late num price;

  CarController _carController = CarController();

  @override
  void initState() {
    super.initState();
    // Initialize form fields with car details
    brand = widget.car.brand;
    imagePath = widget.car.imagePath;
    model = widget.car.model;
    price = widget.car.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Car'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                initialValue: brand,
                decoration: InputDecoration(labelText: 'Brand'),
                onSaved: (value) => brand = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a brand' : null,
              ),
              TextFormField(
                initialValue: imagePath,
                decoration: InputDecoration(labelText: 'Image Path'),
                onSaved: (value) => imagePath = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an image path' : null,
              ),
              TextFormField(
                initialValue: model,
                decoration: InputDecoration(labelText: 'Model'),
                onSaved: (value) => model = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a model' : null,
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = num.tryParse(value!) ?? 0,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // call controller
                    Car? updatedCar = await _carController.updateCar(
                        widget.car.id, {
                      "brand": brand,
                      "imagePath": imagePath,
                      "model": model,
                      "price": price
                    });

                    // update data to state
                    if (updatedCar != null) {
                      // Update car in the provider
                      context.read<CarsProvider>().updateCar(updatedCar);

                      // Go back to the previous screen
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

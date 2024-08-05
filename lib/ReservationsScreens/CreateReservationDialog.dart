import 'package:flutter/material.dart';
import 'package:hotel_app/ApiService.dart';
import 'package:hotel_app/HomePage.dart';
import 'package:hotel_app/Models/Guest.dart';
import 'package:intl/intl.dart';

class CreateReservationDialog extends StatefulWidget {
  final Guest guest;

  const CreateReservationDialog({Key? key, required this.guest})
      : super(key: key);

  @override
  _CreateReservationDialogState createState() =>
      _CreateReservationDialogState();
}

class _CreateReservationDialogState extends State<CreateReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  int? _numberOfRooms;
  DateTime? _checkIn;
  DateTime? _checkOut;
  String? _note;
  String? _mealPlan;
  String? _source;
  double? _price;
  int? _pax;
  bool _isLoading = false;

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(width: 16),
              Text(
                'Success!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your reservation has been created successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HotelApp()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveReservation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if(_note == null) {_note ="";}
        int reservationResponse = await ApiService.createReservation(
          numberOfRooms: _numberOfRooms!,
          checkIn: _checkIn!,
          checkOut: _checkOut!,
          note: _note!,
          mealPlan: _mealPlan!,
          source: _source!,
          price: _price!,
          pax: _pax!,
        );

        await ApiService.createGuest(
            nationality: widget.guest.nationality!,
            documentType: widget.guest.documentType!,
            gender: widget.guest.gender!,
            date: widget.guest.dateOfBirth!,
            name: widget.guest.name!,
            documentID: widget.guest.documentID!,
            birthPlace: widget.guest.birthPlace!,
            reservationNumber: reservationResponse);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          content: Text(
            "Reservation saved successfully",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'EduAUVICWANTHand',
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ));

        Navigator.of(context).pop();
        showSuccessDialog(context);
      } catch (e) {
        print("error $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error: $e",
            style: const TextStyle(color: Colors.white),
          ),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Create Reservation\n${widget.guest.name}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'EduAUVICWANTHand',
          color: Colors.black,
          fontSize: 25,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Check-In Date
              TextFormField(
                controller: _checkInController,
                decoration: const InputDecoration(
                  labelText: 'Check-In Date',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _checkIn = pickedDate;
                      _checkInController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a check-in date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Check-Out Date
              TextFormField(
                controller: _checkOutController,
                decoration: const InputDecoration(
                  labelText: 'Check-Out Date',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _checkIn ?? DateTime.now(),
                    firstDate: _checkIn ?? DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _checkOut = pickedDate;
                      _checkOutController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a check-out date';
                  }
                  if (_checkIn != null && _checkOut != null) {
                    if (_checkOut!.isBefore(_checkIn!)) {
                      return 'Check-out date cannot be before check-in date';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 10),
              // Source
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Source',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.source),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the source';
                  }
                  return null;
                },
                onChanged: (value) {
                  _source = value;
                },
              ),
              const SizedBox(height: 10),
              // Number of Rooms
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Number of Rooms',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.hotel),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of rooms';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _numberOfRooms = int.tryParse(value);
                },
              ),
              const SizedBox(height: 10),
              // Pax
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Pax',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of pax';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _pax = int.tryParse(value);
                },
              ),
              const SizedBox(height: 10),
              // Price
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onChanged: (value) {
                  _price = double.tryParse(value);
                },
              ),
              const SizedBox(height: 10),
              // Meal Plan
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Meal Plan',
                  border: const UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                items: ['BO', 'BB', 'HB', 'FB']
                    .map((plan) => DropdownMenuItem<String>(
                          value: plan,
                          child: Text(plan),
                        ))
                    .toList(),
                validator: (value) =>
                    value == null ? 'Please select a meal plan' : null,
                onChanged: (value) {
                  _mealPlan = value;
                },
              ),
              const SizedBox(height: 10),
              // Note
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                onChanged: (value) {
                  _note = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveReservation,
          child: _isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

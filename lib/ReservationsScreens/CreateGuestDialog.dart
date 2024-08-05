import 'package:flutter/material.dart';
import 'package:hotel_app/Models/Guest.dart';
import 'package:hotel_app/ReservationsScreens/CreateReservationDialog.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';  // Import the package

class CreateGuestDialog extends StatefulWidget {
  @override
  _CreateGuestDialogState createState() => _CreateGuestDialogState();
}

class _CreateGuestDialogState extends State<CreateGuestDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _documentIdController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();

  String? _documentType;
  String? _gender;
  DateTime? _selectedDate;
  String? _name;
  String? _documentID;
  String? _birthPlace;
  Country? _selectedCountry;

  @override
  void dispose() {
    _nameController.dispose();
    _documentIdController.dispose();
    _birthPlaceController.dispose();
    _dateOfBirthController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _nationalityController.text = country.name;  
        });
      },
      showPhoneCode: true, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Create New Guest',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'EduAUVICWANTHand',
          color: Colors.black,
          fontSize: 25,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                controller: _nationalityController,
                readOnly: true,
                onTap: _selectCountry,
                decoration: const InputDecoration(
                  labelText: 'Nationality',
                  icon: Icon(Icons.flag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a nationality';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _documentIdController,
                decoration: const InputDecoration(
                  labelText: 'Document ID',
                  icon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a document ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _documentID = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _documentType,
                decoration: const InputDecoration(
                  labelText: 'Document Type',
                  icon: Icon(Icons.card_travel),
                ),
                items: <String>['Personal ID', 'Passport', 'Driving License']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _documentType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a document type';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  icon: Icon(Icons.transgender),
                ),
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthPlaceController,
                decoration: const InputDecoration(
                  labelText: 'Birth Place',
                  icon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a birth place';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _birthPlace = value;
                  });
                },
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  icon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date of birth';
                  }
                  return null;
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
        TextButton(
          child: const Text('Next'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final Guest myGuest = Guest(
                newNationality: _selectedCountry?.name ?? '',
                newDocumentType: _documentType!,
                newGender: _gender!,
                newName: _name!,
                newDocumentID: _documentID!,
                newBirthPlace: _birthPlace!,
                newDateOfBirth: _selectedDate!,
              );

              Navigator.of(context).pop();
              await showDialog<void>(barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return CreateReservationDialog(guest: myGuest);
                },
              );
            }
          },
        ),
      ],
    );
  }
}

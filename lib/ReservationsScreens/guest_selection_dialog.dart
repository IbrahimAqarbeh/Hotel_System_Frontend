// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hotel_app/ApiService.dart';
import 'package:hotel_app/Models/Guest.dart';
import 'package:hotel_app/ReservationsScreens/CreateGuestDialog.dart';
import 'package:hotel_app/ReservationsScreens/CreateReservationDialog.dart';
import 'package:hotel_app/main.dart';

import 'package:intl/intl.dart';

class GuestSelectionDialog extends StatefulWidget {
  const GuestSelectionDialog({Key? key}) : super(key: key);

  @override
  _GuestSelectionDialogState createState() => _GuestSelectionDialogState();
}

class _GuestSelectionDialogState extends State<GuestSelectionDialog> {
  late Future<List<Map<String, dynamic>>> _guestsFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredGuests = [];
  bool _isLoading = true;
  List<Map<String, dynamic>> initialGuests = [];
  @override
  void initState() {
    super.initState();
    _guestsFuture = _fetchGuests();
  }

  Future<List<Map<String, dynamic>>> _fetchGuests() async {
    try {
      final guests = await ApiService.getAllGuests();
      setState(() {
        initialGuests = guests;
        _filteredGuests = guests;
        _isLoading = false;
      });
      return guests;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return [];
    }
  }

  void _filterGuests(String query) {
    final filtered = initialGuests
        .where((guest) => (guest['name'] as String)
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredGuests = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select A Guest',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'EduAUVICWANTHand',
          color: Colors.black,
          fontSize: 25,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _guestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: MyApp.loadindCircularColor,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              if (_isLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: MyApp.loadindCircularColor));
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by name',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            Navigator.pop(context);
                            await showDialog<Map<String, dynamic>>(
                                    barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return CreateGuestDialog();
                              },
                            );
                          },
                        ),
                      ),
                      onChanged: _filterGuests,
                    ),
                    SizedBox(
                      height: 300,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: _filteredGuests.length,
                          itemBuilder: (context, index) {
                            final guest = _filteredGuests[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1.25,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  guest['name'] ?? 'No Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 8, 38, 63),
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  'Guest ID: ${guest['guestId']}\n'
                                  'Date of Birth: ${guest['dateOfBirth'].toString().substring(0, 10)}\n'
                                  'Document ID: ${guest['documentId']}',
                                ),
                                onTap: () async {
                                  final Guest myGuest = Guest(
                                      newNationality: guest['nationality'],
                                      newDocumentType: guest['documentType'],
                                      newGender: guest['gender'],
                                      newName: guest['name'],
                                      newDocumentID: guest['documentId'],
                                      newBirthPlace: guest['birthPlace'],
                                      newDateOfBirth: DateFormat('yyyy-MM-dd')
                                          .parse(guest['dateOfBirth']));

                                  Navigator.of(context).pop();
                                  await showDialog<void>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CreateReservationDialog(
                                          guest: myGuest);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No guests found'));
            }
          },
        ),
      ),
    );
  }
}

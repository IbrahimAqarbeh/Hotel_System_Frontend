import 'package:flutter/material.dart';
import 'package:hotel_app/main.dart';
import 'ReservationsScreens/guest_selection_dialog.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  
   const TextStyle titleTextStyle =  TextStyle(
    fontWeight: FontWeight.bold,
                        fontFamily: 'EduAUVICWANTHand',
                        color: Colors.black,
                        fontSize: 25,
                      );
    return Drawer(backgroundColor: MyApp.color,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 81.0,
            color: MyApp.secondColor,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Menu',
                      style: MyApp.titleTextStyle
            ),
          ),
          ExpansionTile(
            title: const Text('Reservations',style: titleTextStyle,),
            children: <Widget>[
              ListTile(
                title: const Text('Create'),
                onTap: () async {
                  await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (BuildContext context) {
                return const GuestSelectionDialog();
              },
            );
                },
              ),
              ListTile(
                title: const Text('View'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

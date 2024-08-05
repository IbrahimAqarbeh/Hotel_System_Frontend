

import 'package:hotel_app/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://192.168.8.56:7124";

  static Future<Map<String, dynamic>> signIn(
      String email, String password) async {
    final signInRequest = {'email': email, 'password': password};
    final response = await http.post(
      Uri.parse('$baseUrl/api/User/signin'),
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Content-Length': '${json.encode(signInRequest).length}',
      },
      body: json.encode(signInRequest),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  static Future<Map<String, double>> getDailyCounts(String token) async {
    final Uri uri = Uri.parse("$baseUrl/api/reservation/getDailyCounts");
    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((key, value) => MapEntry(key, value.toDouble()));
    } else {
      throw Exception('Failed to fetch reservations: ${response.statusCode}');
    }
  }

  static Future<String> createGuest(
      {
      required String nationality,
      required String documentType,
      required String gender,
      required DateTime date,
      required String name,
      required String documentID,
      required String birthPlace,
      required int reservationNumber}) async {
    final String? token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Invalid token');
    }

    final Map<String, dynamic> body = {
  "name": name,
  "nationality": nationality,
  "documentId": documentID,
  "documentType": documentType,
  "gender": gender,
  "birthPlace": birthPlace,
  "dateOfBirth": date.toUtc().toIso8601String(),
  "reservationNumber": reservationNumber 
};

    final Uri uri = Uri.parse("$baseUrl/api/guest/create");

    final response = await http.post(
      uri,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Host': '192.168.8.20:7124',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create reservation: ${response.statusCode}');
    }
  }

  static Future<int> createReservation({
    required int numberOfRooms,
    required DateTime checkIn,
    required DateTime checkOut,
    required String note,
    required String mealPlan,
    required String source,
    required double price,
    required int pax,
  }) async {
    final String? token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Invalid token');
    }

    final Map<String, dynamic> body = {
      "countOfRoomsReserved": numberOfRooms,
      "checkIn": checkIn.toUtc().add(Duration(hours: 3)).toIso8601String(),
      "checkOut": checkOut.toUtc().add(Duration(hours: 3)).toIso8601String(),
      "statusMessage": note,
      "mealPlan": mealPlan,
      "source": source,
      "price": price,
      "pax": pax
    };

    final Uri uri = Uri.parse("$baseUrl/api/reservation/create");

    final response = await http.post(
      uri,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Host': '192.168.8.20:7124',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to create reservation: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllGuests() async {
    final Uri uri = Uri.parse("$baseUrl/api/guest/allguests");
    final String? token = await getToken();
    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch guests: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getUser(String token) async {
    final Uri uri = Uri.parse("$baseUrl/api/user/getUser");
    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchReservations({
    String? token,
    int? userId,
    int? guestId,
    String? roomNumber,
    DateTime? reservedOn,
    DateTime? checkIn,
    DateTime? checkOut,
    String? status,
    String? mealPlan,
    String? source,
    double? price,
  }) async {
    final Map<String, String> queryParams = {};

    if (userId != null) queryParams['userId'] = userId.toString();
    if (guestId != null) queryParams['guestId'] = guestId.toString();
    if (roomNumber != null) queryParams['roomNumber'] = roomNumber;
    if (reservedOn != null)
      queryParams['reservedOn'] = reservedOn.toIso8601String();
    if (checkIn != null) queryParams['checkIn'] = checkIn.toIso8601String();
    if (checkOut != null) queryParams['checkOut'] = checkOut.toIso8601String();
    if (status != null) queryParams['status'] = status;
    if (mealPlan != null) queryParams['mealPlan'] = mealPlan;
    if (source != null) queryParams['source'] = source;
    if (price != null) queryParams['price'] = price.toString();

    final Uri uri = Uri.parse("$baseUrl/api/reservation/search")
        .replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Host': '192.168.8.20:7124',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch reservations: ${response.statusCode}');
    }
  }
}

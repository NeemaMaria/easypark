import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;

class Reservation {
  static Future<int> reserve_slot(slot_id, user_id) async {
    var response = await http
        .post(Uri.parse("http://${dotenv.env['SERVER']}:8000/reserve_slot/$slot_id/$user_id/"));
    return response.statusCode;
  }

  static Future<int> cancel_reservation(slot_id, user_id) async {
    var response = await http.post(
        Uri.parse("http://${dotenv.env['SERVER']}:8000/cancel_reservation/$slot_id/$user_id/"));
    return response.statusCode;
  }
}

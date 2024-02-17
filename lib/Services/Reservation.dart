import "../variables.dart";
import "package:http/http.dart" as http;

class Reservation {
  static Future<int> reserve_slot(slot_id, user_id) async {
    var response = await http
        .post(Uri.parse("http://$server:8000/reserve_slot/$slot_id/$user_id/"));
    return response.statusCode;
  }

  static Future<int> cancel_reservation(slot_id, user_id) async {
    var response = await http.post(
        Uri.parse("http://$server:8000/cancel_reservation/$slot_id/$user_id/"));
    return response.statusCode;
  }
}

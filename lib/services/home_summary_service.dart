import 'dart:convert';
import 'package:delivery_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeSummary {
  Future<Map<String, dynamic>> fetchDeliverySummary() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/summary'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.toString()}',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(response.body.toString());
        throw Exception('Failed to load delivery summary');
      }
    } catch (e) {
      print('Exception caught in fetch summary: $e');
      throw Exception('Failed to load summary');
    }
  }
}

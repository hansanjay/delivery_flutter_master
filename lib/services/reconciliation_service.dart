import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reconciliation_model.dart';
import '../utils/const_utils.dart';

class ReconciliationService {
  Future<List<DailyItems>> getAllItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reconcile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.toString()}',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<DailyItems> dailyItems = data.map((item) => DailyItems.fromJson(item)).toList();
        return dailyItems;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Exception caught in recosciliation: $e');
      throw Exception('Failed to load reconsiliation');
    }
  }
}

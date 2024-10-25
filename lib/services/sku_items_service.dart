import 'dart:convert';
import 'package:delivery_flutter_master/models/sku_items_model.dart';
import 'package:delivery_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SKUService {
  Future<SKUSummary> fetchSKUItemsById(int routeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/route/$routeId/sku'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.toString()}',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        return SKUSummary.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load delivery summary');
      }
    } catch (e) {
      print('Exception caught in fetch summary: $e');
      throw Exception('Failed to load summary');
    }
  }

  Future<void> collectSKUItems(Map<String, dynamic> orderPayload,int id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId =
          '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.post(
        Uri.parse('$baseUrl/route/$id/sku'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode(orderPayload),
      );

      if (response.statusCode == 200) {
        print('Items collected successfully');
      } else {
        print('Error: '+response.body.toString());
        throw Exception('Failed to collect items');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

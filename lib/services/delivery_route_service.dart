import 'dart:convert';
import 'package:delivery_flutter_master/models/delivery_route_model.dart';
import 'package:delivery_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RoutesService {

  Future<List<Routes>> fetchAllRoutes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/route'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.toString()}',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Routes.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load routes');
      }
    } catch (e) {
      print('Exception caught in fetch routes: $e');
      throw Exception('Failed to load routes');
    }
  }
}

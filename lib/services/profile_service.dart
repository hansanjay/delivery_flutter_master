import 'dart:convert';
import 'package:delivery_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

class ProfileService {
  Future<Profile> fetchProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId =
          '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Profile.fromJson(data);
      } else {
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      print('Error in fetchProfile: $e');
      throw Exception('Failed to fetch profile');
    }
  }
}
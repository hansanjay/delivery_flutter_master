import 'dart:convert';
import 'package:delivery_flutter_master/models/client_orders_model.dart';
import 'package:delivery_flutter_master/utils/const_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  Future<RouteOrders> fetchAllOrders(int routeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/route/$routeId/order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.toString()}',
          'x-app-id-token': appId,
        },
      );

      if (response.statusCode == 200) {
        return RouteOrders.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Exception caught in fetchAllOrders: $e');
      throw Exception('Failed to load orders');
    }
  }
  Future<Order> getOrderById(int routeId, int orderId) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String appId = '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/route/$routeId/order/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
      );
    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load order');
    }
    } catch (e) {
      print('Exception caught in fetch orders: $e');
      throw Exception('Failed to load orders');
    }
  }

  Future<void> deliverOrder(Map<String, dynamic> orderPayload,int routeId, int orderId) async {
    var response2;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("Token");
      String appId =
          '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

      final response = await http.patch(
        Uri.parse('$baseUrl/route/$routeId/order/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-app-id-token': appId,
        },
        body: jsonEncode(orderPayload),
      );
      response2=response;
      if (response.statusCode == 200) {
        print('Order delivered successfully');
      } else {
        print('Error: '+response.body.toString());
        var data = jsonDecode(response.body);
        throw Exception(data['errors']);
      }
    } catch (e) {
      var data = jsonDecode(response2.body);
      throw Exception(data['errors']);
    }
  }
}

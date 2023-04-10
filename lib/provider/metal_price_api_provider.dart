import 'dart:convert';
import 'package:http/http.dart' as http;

class MetalPriceApi {
  static const String _baseUrl = 'https://api.metalpriceapi.com';
  static const String _apiKey = 'YOUR_API_KEY_HERE';

  static Future<Map<String, dynamic>> getMetalPrices() async {
    final url = '$_baseUrl/api/rates?access_key=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch metal prices');
    }
  }
}